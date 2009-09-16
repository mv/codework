--SELECT COUNT(1) FROM (
SELECT /***** RULE */
       DISTINCT
       ewo.wip_entity_name                                                                  ordem_servico
     , ewo.wip_entity_name                                                                  ordem_servico2
     , DECODE( NVL(ewo.parent_wip_entity_name,NVL(ewo.manual_rebuild_flag,'N'))
             , 'N','Ordem de Serviço'
             ,'Ordem de Serviço de Recriação')                                              tipo_ordem
     , db.department_code||' - '||db.description                                            departamento_responsavel
     , NVL(ewo.service_request, wewr.work_request_number )                                  num_solicitacao_servico
     , mel.location_codes||' - '||mel.description                                           area
     , ewo.activity_source_meaning                                                          origem_ativo
     , fu.user_name                                                                         planejador
     , ewo.asset_number                                                                     tag_comum
     , msi.segment1                                                                         grupo_ativos
     , msi.description                                                                      desc_grupo_ativos
     , mea.descriptive_text                                                                 desc_ativos
     , DECODE( NVL(ewo.rebuild_serial_number,'X')
             , ewo.rebuild_serial_number, DECODE( NVL(ewo.parent_wip_entity_name, NVL(ewo.manual_rebuild_flag,'N'))
                                                , 'N',ewo.asset_description
                                                , mear.descriptive_text
                                                )
             , NULL)                                                                        ativo
     , mea.fa_asset_number                                                                  num_patrimonio
     , ewo.rebuild_serial_number                                                            tag_recriavel
     , msb.segment1                                                                         grupo_ativos_recriavel
     , msb.description                                                                      desc_grupo_ativos_recriavel
     , msb.description                                                                      desc_ativos
     , CASE WHEN SUBSTR(UPPER(flv.meaning),1,1) IN ('N') THEN 'NÃO' ELSE 'SIM'          END medidor
     , CASE WHEN SUBSTR(UPPER(flv.meaning),1,1) IN ('N') THEN ''    ELSE me.meter_name  END nome
     , CASE WHEN SUBSTR(UPPER(flv.meaning),1,1) IN ('N') THEN ''    ELSE me.meter_uom   END udm
     , DECODE( mrr.reset_flag
             , 'Y', 0
             , mrr.current_reading
             )                                                                              ultima_leitura
     , mfgl_tp.meaning                                                                      tipo_os
     , ewo.priority_disp                                                                    prioridade
     , TO_CHAR(ewo.creation_date       ,'dd/mm/yy hh24:mi')                                 data_emissao
     , ewo.activity_type_disp                                                               tipo_atividade
     , ewo.activity_cause_disp                                                              causa_atividade
     , TO_CHAR(ewo.scheduled_start_date,'dd/mm/yy hh24:mi')                                 data_programada
     , NVL(meav.activity, msi_at.segment1)                                                  numero_atividade
     , NVL(meav.activity_description, NVL(msi_at.description,ewo.description))              descricao_atividade
     , ewo.status_type_disp                                                                 status
     , TO_CHAR(ewo.scheduled_start_date     ,'dd/mm/yy hh24:mi')                            inicio_programado
     , TO_CHAR(ewo.scheduled_completion_date,'dd/mm/yy hh24:mi')                            final_programado
     , (ewo.scheduled_completion_date - ewo.scheduled_start_date)*24*60                     tempo_parada_programado -- Em minutos
     , db.department_id
     , NULL                                                                                 inicio_real
     , NULL                                                                                 final_real
     , NULL                                                                                 tempo_real
     , NULL                                                                                 leitura_atual
     , ewo.organization_id
     , ewo.status_type
     , ewo.wip_entity_id
     , mea.serial_number
  FROM wip_eam_work_requests_v              wewr
     , bom_departments                      db
     , mtl_eam_locations                    mel
     , mtl_serial_numbers                   msn
     , fnd_user                             fu
     , mtl_system_items_b                   msi_at       --\ Ativo Standard
     , mtl_system_items_b                   msi
     , mtl_system_items_b                   msb
     , mtl_eam_asset_numbers_all_v          mea
     , mtl_eam_asset_numbers_all_v          mear      -- Descrição ativo Recriavel
     , eam_meters                           me
     , eam_asset_meters                     am
     , eam_meter_readings                   mrr
     , mfg_lookups                          mfgl_tp
     , mfg_lookups                          mfgl
     , fnd_lookup_values                    flv
     , wip_discrete_jobs                    j
     , mtl_eam_asset_activities             meaa
     , mtl_eam_asset_activities_v           meav
     , eam_work_orders_v                    ewo
 WHERE db.department_code                   = ewo.owning_department_code
   AND db.organization_id                   = ewo.organization_id
   AND ewo.maintenance_object_id            = msn.gen_object_id             (+)
   AND ewo.organization_id                  = msn.current_organization_id   (+)
   AND msn.eam_location_id                  = mel.location_id               (+)
   AND ewo.created_by                       = fu.user_id
   AND ewo.asset_group_id                   = msi.inventory_item_id         (+)
   AND ewo.organization_id                  = msi.organization_id           (+)
   AND ewo.primary_item_id                  = msi_at.inventory_item_id      (+)
   AND ewo.organization_id                  = msi_at.organization_id        (+)
   AND ewo.asset_number                     = mea.maintained_unit           (+)
   AND ewo.rebuild_serial_number            = mear.serial_number            (+)  -- descrição de ativo recriavel -- 08/01/2007
   AND ewo.rebuild_item_id                  = mear.inventory_item_id        (+)  -- descrição de ativo recriavel -- 08/01/2007
   AND ewo.rebuild_item_id                  = msb.inventory_item_id         (+)
   AND ewo.organization_id                  = msb.organization_id           (+)
   AND me.meter_id                          = am.meter_id
   AND am.meter_id                          = mrr.meter_id                  (+)
   AND NVL(mrr.meter_reading_id, -1)        = NVL(eam_meter_readings_jsp.get_latest_meter_reading_id(me.meter_id), -1)
   AND NVL(me.from_effective_date, SYSDATE)<= SYSDATE
   AND NVL(me.to_effective_date, SYSDATE+1)>= SYSDATE
   AND 'EAM_METER_VALUE_CHANGE'             = mfgl.lookup_type              (+)
   AND me.value_change_dir                  = mfgl.lookup_code              (+)
   AND ewo.work_order_type                  = mfgl_tp.lookup_code           (+)
   AND 'WIP_EAM_WORK_ORDER_TYPE'            = mfgl_tp.lookup_type           (+)
   AND NVL(mfgl_tp.enabled_flag,'Y')        = 'Y'
   AND flv.lookup_type                      = 'EAM_YES_NO'
   AND flv.lookup_code                      = eam_meter_readings_jsp.is_meter_reading_mandatory(j.wip_entity_id,am.meter_id)
   AND flv.language                         = USERENV('LANG')
   AND j.wip_entity_id                      = ewo.wip_entity_id
   AND meaa.activity_association_id         = meav.activity_association_id  (+)
   AND meaa.asset_activity_id               = meav.asset_activity_id        (+)
   AND meaa.inventory_item_id               = meav.inventory_item_id        (+)
   AND meaa.wip_entity_id          (+)      = ewo.wip_entity_id
   AND ewo.wip_entity_name            BETWEEN NVL(&p_ordem_servico_ini, ewo.wip_entity_name)
                                          AND NVL(&p_ordem_servico_fim, ewo.wip_entity_name)
   AND ewo.scheduled_start_date       BETWEEN NVL(      TO_DATE(&p_dt_ini_ini,'rrrr/mm/dd hh24:mi:ss')          , ewo.scheduled_start_date )
                                          AND NVL(TRUNC(TO_DATE(&p_dt_ini_fim,'rrrr/mm/dd hh24:mi:ss') + .99999), ewo.scheduled_start_date )
   AND NVL(mel.location_codes,'x')    BETWEEN NVL(&p_area_ativo_ini , NVL(mel.location_codes,'x'))
                                          AND NVL(&p_area_ativo_fim , NVL(mel.location_codes,'x'))
   AND NVL(ewo.asset_number,'x')            = NVL(&p_num_ativo      , NVL(ewo.asset_number,'x'))
   AND ewo.status_type                      = NVL(&p_status_os      , ewo.status_type)
   AND db.department_code                   = NVL(&p_depart_atrib   , db.department_code)
   AND wewr.wip_entity_id (+)               = ewo.wip_entity_id
   AND ewo.organization_id                  = NVL(&p_organization_id, ewo.organization_id)
UNION
SELECT  
       DISTINCT
       ewo.wip_entity_name                                                                  ordem_servico
     , ewo.wip_entity_name                                                                  ordem_servico2
     , DECODE( NVL(ewo.parent_wip_entity_name,NVL(ewo.manual_rebuild_flag,'N'))
             , 'N','Ordem de Serviço'
             , 'Ordem de Serviço de Recriação')                                             tipo_ordem
     , db.department_code||' - '||db.description                                            departamento_responsavel
     , NVL(ewo.service_request, wewr.work_request_number )                                  num_solicitacao_servico
     , mel.location_codes||' - '||mel.description                                           area
     , ewo.activity_source_meaning                                                          origem_ativo
     , fu.user_name                                                                         planejador
     , ewo.asset_number                                                                     tag_comum
     , msi.segment1                                                                         grupo_ativos
     , msi.description                                                                      desc_grupo_ativos
     , mea.descriptive_text                                                                 desc_ativos
     , DECODE( NVL(ewo.rebuild_serial_number,'x')
             , ewo.rebuild_serial_number, DECODE( NVL(ewo.parent_wip_entity_name, NVL(ewo.manual_rebuild_flag,'N'))
                                                , 'N', ewo.asset_description
                                                , mear.descriptive_text)
             , NULL )                                                                       ativo
     , mea.fa_asset_number                                                                  num_patrimonio
     , ewo.rebuild_serial_number                                                            tag_recriavel
     , msb.segment1                                                                         grupo_ativos_recriavel
     , msb.description                                                                      desc_grupo_ativos_recriavel
     , mea.descriptive_text                                                                 desc_ativos
     , 'NÃO'                                                                                medidor
     , NULL                                                                                 nome
     , NULL                                                                                 udm
     , NULL                                                                                 ultima_leitura
     , mfgl_tp.meaning                                                                      tipo_os
     , ewo.priority_disp                                                                    prioridade
     , TO_CHAR(EWO.CREATION_DATE,'DD/MM/YY HH24:MI')                                        Data_Emissao
     , ewo.activity_type_disp                                                               tipo_atividade
     , ewo.activity_cause_disp                                                              causa_atividade
     , TO_CHAR(ewo.scheduled_start_date,'dd/mm/yy hh24:mi')                                 data_programada
     , NVL(meav.activity, msi_at.segment1)                                                  numero_atividade
     , NVL(meav.activity_description, NVL(msi_at.description,
            ewo.description) )                                                              descricao_atividade
     , ewo.status_type_disp                                                                 status
     , TO_CHAR(ewo.scheduled_start_date     , 'dd/mm/yy hh24:mi')                           inicio_programado
     , TO_CHAR(ewo.scheduled_completion_date, 'dd/mm/yy hh24:mi')                           final_programado
     , (ewo.scheduled_completion_date - ewo.scheduled_start_date)*24*60                     tempo_parada_programado -- em minutos
     , db.department_id
     , NULL                                                                                 inicio_real
     , NULL                                                                                 final_real
     , NULL                                                                                 tempo_real
     , NULL                                                                                 leitura_atual
     , ewo.organization_id
     , ewo.status_type
     , ewo.wip_entity_id
     , mea.serial_number
  FROM
       wip_eam_work_requests_v              wewr
     , bom_departments                      db
     , mtl_eam_locations                    mel
     , mtl_serial_numbers                   msn
     , fnd_user                             fu
     , mtl_system_items_b                   msi_at       --\ Ativo Standard
     , mtl_system_items_b                   msi
     , mtl_system_items_b                   msb
     , mtl_eam_asset_numbers_all_v          mea
     , mtl_eam_asset_numbers_all_v          mear      -- Descrição ativo Recriavel
     , mfg_lookups                          mfgl_tp
     , mfg_lookups                          mfgl
     , fnd_lookup_values                    flv
     , wip_discrete_jobs                    j
     , mtl_eam_asset_activities             meaa
     , mtl_eam_asset_activities_v           meav
     , eam_work_orders_v                    ewo
 WHERE db.department_code                   = ewo.owning_department_code
   AND db.organization_id                   = ewo.organization_id
   AND ewo.maintenance_object_id            = msn.gen_object_id             (+)
   AND ewo.organization_id                  = msn.current_organization_id   (+)
   AND msn.eam_location_id                  = mel.location_id               (+)
   AND ewo.created_by                       = fu.user_id
   AND ewo.asset_group_id                   = msi.inventory_item_id         (+)
   AND ewo.organization_id                  = msi.organization_id           (+)
   AND ewo.primary_item_id                  = msi_at.inventory_item_id      (+)
   AND ewo.organization_id                  = msi_at.organization_id        (+)
   AND ewo.asset_number                     = mea.maintained_unit           (+)
   AND ewo.rebuild_serial_number            = mear.serial_number            (+)
   AND ewo.rebuild_item_id                  = mear.inventory_item_id        (+)
   AND ewo.rebuild_item_id                  = msb.inventory_item_id         (+)
   AND ewo.organization_id                  = msb.organization_id           (+)
   AND 'EAM_METER_VALUE_CHANGE'             = mfgl.lookup_type              (+)
   AND ewo.work_order_type                  = mfgl_tp.lookup_code           (+)
   AND 'WIP_EAM_WORK_ORDER_TYPE'            = mfgl_tp.lookup_type           (+)
   AND NVL(mfgl_tp.enabled_flag,'Y')        = 'Y'
   AND flv.lookup_type                      = 'EAM_YES_NO'
   AND flv.lookup_code                      = eam_meter_readings_jsp.is_meter_reading_mandatory(j.wip_entity_id,NULL) --am.meter_id)
   AND flv.language                         = USERENV('LANG')
   AND j.wip_entity_id                      = ewo.wip_entity_id
   AND meaa.activity_association_id         = meav.activity_association_id  (+)
   AND meaa.asset_activity_id               = meav.asset_activity_id        (+)
   AND meaa.inventory_item_id               = meav.inventory_item_id        (+)
   AND meaa.wip_entity_id          (+)      = ewo.wip_entity_id
   AND ewo.wip_entity_name            BETWEEN NVL(&p_ordem_servico_ini, ewo.wip_entity_name)
                                          AND NVL(&p_ordem_servico_fim, ewo.wip_entity_name)
   AND ewo.scheduled_start_date       BETWEEN NVL(      TO_DATE(&p_dt_ini_ini,'rrrr/mm/dd hh24:mi:ss')          , ewo.scheduled_start_date )
                                          AND NVL(TRUNC(TO_DATE(&p_dt_ini_fim,'rrrr/mm/dd hh24:mi:ss') + .99999), ewo.scheduled_start_date )
   AND NVL(mel.location_codes,'x')    BETWEEN NVL(&p_area_ativo_ini , NVL(mel.location_codes,'x'))
                                          AND NVL(&p_area_ativo_fim , NVL(mel.location_codes,'x'))
   AND NVL(ewo.asset_number,'x')            = NVL(&p_num_ativo      , NVL(ewo.asset_number  ,'x'))
   AND ewo.status_type                      = NVL(&p_status_os      , ewo.status_type           )
   AND db.department_code                   = NVL(&p_depart_atrib   , db.department_code        )
   AND wewr.wip_entity_id (+)               = ewo.wip_entity_id
   AND ewo.organization_id                  = NVL(&p_organization_id,ewo.organization_id)
   AND (SELECT COUNT(me.meter_id)
          FROM eam_meters    me )           = 0
   AND ROWNUM = 3

/****/
--)