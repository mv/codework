SELECT ewo.organization_id
     , ewo.wip_entity_name ordem_servico
     , msn.serial_number nr_ativo
     , NVL(ewo.work_order_type_disp, '') tipo_servico
     , ewo.status_type_disp status
     , TO_CHAR(ewo.scheduled_start_date, 'DD/MM/YYYY HH24:MI:SS') inicio_programado
     , TO_CHAR(ewo.scheduled_completion_date, 'DD/MM/YYYY HH24:MI:SS') final_programado
     , wo.operation_seq_num op
     , db.department_code depart
     , rb.resource_code codigo
     , db.description descricao
     , msi.primary_uom_code udm
     , wor.assigned_units unid_atrib
     , wor.usage_rate_or_amount valor_prog
     , wor.applied_resource_units valor_apont
     , wor.usage_rate_or_amount - wor.applied_resource_units valor_dif_prog_apont
     , wt.transaction_quantity valor_apont_func
     , NVL(func.last_name, 'SEM ASSOCIAÇÃO') funcionario
  FROM wip_eam_work_requests_v     wewr
     , bom_departments             db
     , bom_resources               rb
     , mtl_eam_locations           mel
     , mtl_serial_numbers          msn
     , fnd_user                    fu
     , mtl_system_items_b          msi_at
     , mtl_system_items_b          msi
     , mtl_system_items_b          msb
     , mtl_eam_asset_numbers_all_v mea
     , mtl_eam_asset_numbers_all_v mear
     , mfg_lookups                 mfgl_tp
     , mfg_lookups                 mfgl
     , fnd_lookup_values           flv
     , wip_discrete_jobs           j
     , mtl_eam_asset_activities    meaa
     , mtl_eam_asset_activities_v  meav
     , eam_work_orders_v           ewo
     , wip_operations              wo
     , wip_operation_resources     wor
     , apps.per_all_people_f       func
     , wip_transactions            wt
 WHERE wt.employee_id = func.person_id
   AND wt.wip_entity_id = ewo.wip_entity_id
   AND wt.organization_id = ewo.organization_id
   AND wt.operation_seq_num = wor.operation_seq_num
   AND wt.resource_seq_num = wor.resource_seq_num
   AND wt.resource_id = wor.resource_id
   AND db.department_code = ewo.owning_department_code
   AND db.organization_id = ewo.organization_id
   AND wo.organization_id = ewo.organization_id
   AND wo.wip_entity_id = ewo.wip_entity_id
   AND rb.resource_id = wor.resource_id
   AND wo.operation_seq_num = wor.operation_seq_num
   AND wo.wip_entity_id = wor.wip_entity_id
   AND ewo.maintenance_object_id = msn.gen_object_id(+)
   AND ewo.organization_id = msn.current_organization_id(+)
   AND msn.eam_location_id = mel.location_id(+)
   AND ewo.created_by = fu.user_id
   AND ewo.asset_group_id = msi.inventory_item_id(+)
   AND ewo.organization_id = msi.organization_id(+)
   AND ewo.primary_item_id = msi_at.inventory_item_id(+)
   AND ewo.organization_id = msi_at.organization_id(+)
   AND ewo.asset_number = mea.maintained_unit(+)
   AND ewo.rebuild_serial_number = mear.serial_number(+)
   AND ewo.rebuild_item_id = mear.inventory_item_id(+)
   AND ewo.rebuild_item_id = msb.inventory_item_id(+)
   AND ewo.organization_id = msb.organization_id(+)
   AND 'EAM_METER_VALUE_CHANGE' = mfgl.lookup_type(+)
   AND ewo.work_order_type = mfgl_tp.lookup_code(+)
   AND 'WIP_EAM_WORK_ORDER_TYPE' = mfgl_tp.lookup_type(+)
   AND NVL(mfgl_tp.enabled_flag, 'Y') = 'Y'
   AND flv.lookup_type = 'EAM_YES_NO'
   AND flv.lookup_code = eam_meter_readings_jsp.is_meter_reading_mandatory(j.wip_entity_id, NULL) --AM.METER_ID)
   AND flv.LANGUAGE = USERENV('LANG')
   AND j.wip_entity_id = ewo.wip_entity_id
   AND meaa.activity_association_id = meav.activity_association_id(+)
   AND meaa.asset_activity_id = meav.asset_activity_id(+)
   AND meaa.inventory_item_id = meav.inventory_item_id(+)
   AND meaa.wip_entity_id(+) = ewo.wip_entity_id
   AND ewo.wip_entity_name >= NVL(&p_ordem_servico_ini, ewo.wip_entity_name)
   AND ewo.wip_entity_name <= NVL(&p_ordem_servico_fim, ewo.wip_entity_name)
      --          AND  EWO.SCHEDULED_START_DATE             >= NVL(&l_DT_INI_INI,EWO.SCHEDULED_START_DATE)
      --          AND  EWO.SCHEDULED_START_DATE             <= NVL(TRUNC(&l_DT_INI_FIM)+.99999,EWO.SCHEDULED_START_DATE)
   AND NVL(ewo.work_order_type_disp, 'x') = NVL(&p_tipo_ord_servico, NVL(ewo.work_order_type_disp, 'x'))
   AND NVL(ewo.asset_number, 'x') = NVL(&p_num_ativo, NVL(ewo.asset_number, 'x'))
   AND NVL(rb.resource_code, 'x') = NVL(&p_codigo_recurso, NVL(rb.resource_code, 'x'))
   AND db.department_code BETWEEN NVL(&p_depart_atrib_ini, db.department_code) AND NVL(&p_depart_atrib_fim, db.department_code)
   AND NVL(func.last_name, 'x') = NVL(&p_funcionario, NVL(func.last_name, 'x'))
   AND wewr.wip_entity_id(+) = ewo.wip_entity_id
   AND ewo.organization_id = NVL(&p_organization_id, ewo.organization_id)
 ORDER BY ewo.organization_id
        , ewo.wip_entity_name
        , msn.serial_number
        , NVL(ewo.work_order_type_disp, '')
        , ewo.status_type_disp
        , TO_CHAR(ewo.scheduled_start_date, 'DD/MM/YYYY HH24:MI:SS')
        , TO_CHAR(ewo.scheduled_completion_date, 'DD/MM/YYYY HH24:MI:SS')
        , wo.operation_seq_num
        , db.department_code
        , rb.resource_code
        , db.description
        , msi.primary_uom_code
        , NVL(func.last_name, 'SEM ASSOCIAÇÃO')
        ;