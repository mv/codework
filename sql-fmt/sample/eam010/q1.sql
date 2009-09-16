SELECT COUNT(1) FROM (
select  
         distinct
       EWO.WIP_ENTITY_NAME                                                  Ordem_Servico
      , EWO.WIP_ENTITY_NAME                                                  Ordem_Servico2
     ,decode(nvl(ewo.parent_wip_entity_name,nvl(ewo.manual_rebuild_flag,'N')),
           'N','Ordem de Serviço','Ordem de Serviço de Recriação')              tipo_ordem
      ,DB.DEPARTMENT_CODE||' - '||DB.DESCRIPTION                            Departamento_Responsavel
      ,nvl(EWO.SERVICE_REQUEST, wewr.work_request_number )           Num_Solicitacao_Servico
      ,MEL.LOCATION_CODES||' - '||MEL.DESCRIPTION                           Area
      ,EWO.ACTIVITY_SOURCE_MEANING                                          Origem_Ativo
      ,FU.USER_NAME                                                         Planejador
      ,EWO.ASSET_NUMBER                                                     TAG_comum
      ,MSI.SEGMENT1                                                         Grupo_Ativos
      ,MSI.DESCRIPTION                                                      Desc_Grupo_Ativos
      ,MEA.descriptive_text                                                   Desc_Ativos
      , decode(nvl(EWO.REBUILD_SERIAL_NUMBER,'X'),EWO.REBUILD_SERIAL_NUMBER,
        decode(nvl(ewo.parent_wip_entity_name,nvl(ewo.manual_rebuild_flag,'N')),'N',EWO.ASSET_DESCRIPTION, mear.descriptive_text), null)   Ativo
      ,MEA.FA_ASSET_NUMBER                                                  Num_Patrimonio
      ,EWO.REBUILD_SERIAL_NUMBER                                            TAG_Recriavel
      ,MSB.SEGMENT1                                                          Grupo_Ativos_Recriavel
      ,MSB.DESCRIPTION                                                      Desc_Grupo_Ativos_Recriavel
      ,MSB.DESCRIPTION                                                      Desc_Ativos
      ,CASE WHEN upper(flv.meaning) in ('NÃO','NO') THEN 'NÃO' ELSE 'SIM'                   END                Medidor
      ,CASE WHEN upper(flv.meaning) in ('NÃO','NO') THEN '' ELSE ME.METER_NAME   END                NOME
      ,CASE WHEN upper(flv.meaning) in ('NÃO','NO') THEN '' ELSE ME.METER_UOM     END                 UDM
      ,DECODE(MRR.RESET_FLAG,'Y',0,MRR.CURRENT_READING)                     ULTIMA_LEITURA
      , mfgl_tp.meaning                                                       Tipo_OS
      ,EWO.PRIORITY_DISP                                                    Prioridade
      ,TO_CHAR(EWO.CREATION_DATE,'DD/MM/YY HH24:MI')                        Data_Emissao
      ,EWO.ACTIVITY_TYPE_DISP                                               Tipo_Atividade
      ,EWO.ACTIVITY_CAUSE_DISP                                              Causa_Atividade
      ,TO_CHAR(EWO.SCHEDULED_START_DATE,'DD/MM/YY HH24:MI')                 Data_Programada
      ,nvl(MEAV.ACTIVITY, msi_at.segment1)                                  NUMERO_ATIVIDADE
      ,nvl(MEAV.ACTIVITY_DESCRIPTION, nvl(msi_at.description,
            ewo.description) )                                                                                              DESCRICAO_ATIVIDADE
      ,EWO.STATUS_TYPE_DISP                                                 Status
      ,TO_CHAR(EWO.SCHEDULED_START_DATE,'DD-mon-YY HH24:MI')                Inicio_Programado
      ,TO_CHAR(EWO.SCHEDULED_COMPLETION_DATE,'DD-mon-YY HH24:MI')           Final_Programado
      ,((EWO.SCHEDULED_COMPLETION_DATE - EWO.SCHEDULED_START_DATE)*24)*60   Tempo_Parada_Programado -- Em minutos
      ,DB.DEPARTMENT_ID
      ,NULL                                                                                               Inicio_Real
      ,NULL                                                                                               Final_Real
      ,NULL                                                                                               Tempo_Real
      ,NULL                                                                                               Leitura_Atual
     ,ewo.organization_id
     ,EWO.STATUS_TYPE
     , EWO.WIP_ENTITY_ID
     ,mea.SERIAL_NUMBER
from
       WIP_EAM_WORK_REQUESTS_V     wewr
      ,BOM_DEPARTMENTS             DB
      ,MTL_EAM_LOCATIONS           MEL
      ,MTL_SERIAL_NUMBERS          MSN
      ,FND_USER                    FU
      ,MTL_SYSTEM_ITEMS_B          MSI_at       --\ Ativo Standard
      ,MTL_SYSTEM_ITEMS_B          MSI
      ,MTL_SYSTEM_ITEMS_B          MSB
      ,MTL_EAM_ASSET_NUMBERS_ALL_V MEA
      ,MTL_EAM_ASSET_NUMBERS_ALL_V MEAR      -- Descrição ativo Recriavel
      ,EAM_METERS                  ME
      ,EAM_ASSET_METERS            AM
      ,EAM_METER_READINGS          MRR
      , mfg_lookups                       mfgl_tp
      ,MFG_LOOKUPS                 MFGL
      ,FND_LOOKUP_VALUES           FLV
      ,WIP_DISCRETE_JOBS           J
      ,MTL_EAM_ASSET_ACTIVITIES    MEAA
      ,MTL_EAM_ASSET_ACTIVITIES_V  MEAV
      , EAM_WORK_ORDERS_V           EWO
where
       DB.DEPARTMENT_CODE                    =  EWO.OWNING_DEPARTMENT_CODE
  and  db.organization_id                                =  ewo.organization_id
  and  EWO.MAINTENANCE_OBJECT_ID   =  MSN.GEN_OBJECT_ID(+)
  and  EWO.ORGANIZATION_ID                  =  MSN.CURRENT_ORGANIZATION_ID(+)
  and  MSN.EAM_LOCATION_ID                  =  MEL.LOCATION_ID(+)
  and  EWO.CREATED_BY                           =  FU.USER_ID
  and  EWO.ASSET_GROUP_ID                   =  MSI.INVENTORY_ITEM_ID   (+)
  and  EWO.ORGANIZATION_ID                  =  MSI.ORGANIZATION_ID        (+)
  and  EWO.primary_item_id                           =  MSI_at.INVENTORY_ITEM_ID  (+)
  and  EWO.ORGANIZATION_ID                  =  MSI_at.ORGANIZATION_ID    (+)
  and  EWO.ASSET_NUMBER                      =  MEA.MAINTAINED_UNIT(+)
  and  EWO.REBUILD_SERIAL_NUMBER   =  mear.SERIAL_NUMBER (+)  -- Descrição de ativo recriavel -- 08/01/2007
  and  EWO.REBUILD_ITEM_ID                   =  mear.inventory_item_id    (+)  -- Descrição de ativo recriavel -- 08/01/2007
  and  EWO.REBUILD_ITEM_ID                   =  MSB.INVENTORY_ITEM_ID(+)
  and  EWO.ORGANIZATION_ID                  =  MSB.ORGANIZATION_ID(+)
  and  ME.METER_ID                          =  AM.METER_ID
  and  AM.METER_ID                          =  MRR.METER_ID(+)
  and  NVL(MRR.METER_READING_ID, -1)        =  NVL(EAM_METER_READINGS_JSP.GET_LATEST_METER_READING_ID(ME.METER_ID), -1)
  and  NVL(ME.FROM_EFFECTIVE_DATE, SYSDATE) <= SYSDATE
  and  NVL(ME.TO_EFFECTIVE_DATE, SYSDATE+1) >= SYSDATE
  and  'EAM_METER_VALUE_CHANGE'             =  MFGL.LOOKUP_TYPE(+)
  and  ME.VALUE_CHANGE_DIR                  =  MFGL.LOOKUP_CODE(+)
  and  EWO.WORK_ORDER_TYPE                  =  mfgl_tp.LOOKUP_CODE(+)
  and  'WIP_EAM_WORK_ORDER_TYPE'            =  MFGL_tp.LOOKUP_TYPE(+)
  and  nvl(mfgl_tp.enabled_flag,'Y')        = 'Y'
  and  FLV.LOOKUP_TYPE                      =  'EAM_YES_NO'
  and  FLV.LOOKUP_CODE                      =  EAM_METER_READINGS_JSP.IS_METER_READING_MANDATORY(J.WIP_ENTITY_ID,AM.METER_ID)
  and  FLV.LANGUAGE                         =  USERENV('LANG')
  and  J.WIP_ENTITY_ID                      =  EWO.WIP_ENTITY_ID
  and  MEAA.ACTIVITY_ASSOCIATION_ID         =  MEAV.ACTIVITY_ASSOCIATION_ID  (+)
  and  MEAA.ASSET_ACTIVITY_ID               =  MEAV.ASSET_ACTIVITY_ID (+)
  and  MEAA.INVENTORY_ITEM_ID               =  MEAV.INVENTORY_ITEM_ID (+)
  and  MEAA.WIP_ENTITY_ID          (+)         =  EWO.WIP_ENTITY_ID
  and  EWO.WIP_ENTITY_NAME                  >= NVL(&p_ORDEM_SERVICO_INI, EWO.wip_entity_name)
  and  EWO.WIP_ENTITY_NAME                  <= NVL(&p_ORDEM_SERVICO_FIM,EWO.wip_entity_name)
  and  TRUNC(EWO.SCHEDULED_START_DATE) >= NVL(TRUNC(TO_DATE(&p_DT_INI_INI,'RRRR/MM/DD HH24:MI:SS')),TRUNC(EWO.SCHEDULED_START_DATE))
  and  TRUNC(EWO.SCHEDULED_START_DATE) <= NVL(TRUNC(TO_DATE(&p_DT_INI_FIM,'RRRR/MM/DD HH24:MI:SS')),TRUNC(EWO.SCHEDULED_START_DATE))
  and  nvl(MEL.LOCATION_CODES,'x')                    >=  NVL(&p_AREA_ATIVO_INI  ,nvl(MEL.LOCATION_CODES,'x'))
  and  nvl(MEL.LOCATION_CODES,'x')                    <=  NVL(&p_AREA_ATIVO_FIM  ,nvl(MEL.LOCATION_CODES,'x'))
  and  nvl(EWO.ASSET_NUMBER,'x')                       =    NVL(&p_NUM_ATIVO, nvl(EWO.ASSET_NUMBER,'x'))
  and  EWO.STATUS_TYPE         =  nvl(&p_STATUS_OS,EWO.STATUS_TYPE)
  and  DB.DEPARTMENT_CODE||' - '||DB.DESCRIPTION       =   NVL(&p_DEPART_ATRIB,DB.DEPARTMENT_CODE||' - '||DB.DESCRIPTION)
  and wewr.wip_entity_id (+) = ewo.wip_entity_id
  and  ewo.organization_id = nvl(&p_ORGANIZATION_ID,ewo.organization_id)
union
select
       distinct
       EWO.WIP_ENTITY_NAME                                                  Ordem_Servico
      , EWO.WIP_ENTITY_NAME                                                  Ordem_Servico2
     ,decode(nvl(ewo.parent_wip_entity_name,nvl(ewo.manual_rebuild_flag,'N')),
           'N','Ordem de Serviço','Ordem de Serviço de Recriação')              tipo_ordem
      ,DB.DEPARTMENT_CODE||' - '||DB.DESCRIPTION                            Departamento_Responsavel
      ,nvl(EWO.SERVICE_REQUEST, wewr.work_request_number )           Num_Solicitacao_Servico
      ,MEL.LOCATION_CODES||' - '||MEL.DESCRIPTION                           Area
      ,EWO.ACTIVITY_SOURCE_MEANING                                          Origem_Ativo
      ,FU.USER_NAME                                                         Planejador
      ,EWO.ASSET_NUMBER                                                     TAG_comum
      ,MSI.SEGMENT1                                                         Grupo_Ativos
      ,MSI.DESCRIPTION                                                      Desc_Grupo_Ativos
      ,MEA.descriptive_text                                                         Desc_Ativos
      , decode(nvl(EWO.REBUILD_SERIAL_NUMBER,'X'),EWO.REBUILD_SERIAL_NUMBER,
        decode(nvl(ewo.parent_wip_entity_name,nvl(ewo.manual_rebuild_flag,'N')),'N',EWO.ASSET_DESCRIPTION, mear.descriptive_text), null)   Ativo
      ,MEA.FA_ASSET_NUMBER                                                  Num_Patrimonio
      ,EWO.REBUILD_SERIAL_NUMBER                                            TAG_Recriavel
      ,MSB.SEGMENT1                                                         Grupo_Ativos_Recriavel
      ,MSB.DESCRIPTION                                                      Desc_Grupo_Ativos_Recriavel
      ,MEA.descriptive_text                                                   Desc_Ativos
      , 'Não'   medidor
      , NULL    nome
      , NULL     UDM
      , NULL  ULTIMA_LEITURA
      , mfgl_tp.meaning                                                       Tipo_OS
      ,EWO.PRIORITY_DISP                                                    Prioridade
      ,TO_CHAR(EWO.CREATION_DATE,'DD/MM/YY HH24:MI')                        Data_Emissao
      ,EWO.ACTIVITY_TYPE_DISP                                               Tipo_Atividade
      ,EWO.ACTIVITY_CAUSE_DISP                                              Causa_Atividade
      ,TO_CHAR(EWO.SCHEDULED_START_DATE,'DD/MM/YY HH24:MI')                 Data_Programada
      ,nvl(MEAV.ACTIVITY, msi_at.segment1)                                  NUMERO_ATIVIDADE
      ,nvl(MEAV.ACTIVITY_DESCRIPTION, nvl(msi_at.description,
            ewo.description) )                                                                                              DESCRICAO_ATIVIDADE
      ,EWO.STATUS_TYPE_DISP                                                 Status
      ,TO_CHAR(EWO.SCHEDULED_START_DATE,'DD-mon-YY HH24:MI')                Inicio_Programado
      ,TO_CHAR(EWO.SCHEDULED_COMPLETION_DATE,'DD-mon-YY HH24:MI')           Final_Programado
      ,((EWO.SCHEDULED_COMPLETION_DATE - EWO.SCHEDULED_START_DATE)*24)*60   Tempo_Parada_Programado -- Em minutos
      ,DB.DEPARTMENT_ID
      ,NULL                                                                                               Inicio_Real
      ,NULL                                                                                               Final_Real
      ,NULL                                                                                               Tempo_Real
      ,NULL                                                                                               Leitura_Atual
      ,ewo.organization_id
      ,EWO.STATUS_TYPE
     , EWO.WIP_ENTITY_ID
     ,mea.SERIAL_NUMBER
 from
       WIP_EAM_WORK_REQUESTS_V     wewr
      ,BOM_DEPARTMENTS             DB
      ,MTL_EAM_LOCATIONS           MEL
      ,MTL_SERIAL_NUMBERS          MSN
      ,FND_USER                    FU
      ,MTL_SYSTEM_ITEMS_B          MSI_at       --\ Ativo Standard
      ,MTL_SYSTEM_ITEMS_B          MSI
      ,MTL_SYSTEM_ITEMS_B          MSB
      ,MTL_EAM_ASSET_NUMBERS_ALL_V MEA
      ,MTL_EAM_ASSET_NUMBERS_ALL_V MEAR      -- Descrição ativo Recriavel
      , mfg_lookups                       mfgl_tp
      ,MFG_LOOKUPS                 MFGL
      ,FND_LOOKUP_VALUES           FLV
      ,WIP_DISCRETE_JOBS           J
      ,MTL_EAM_ASSET_ACTIVITIES    MEAA
      ,MTL_EAM_ASSET_ACTIVITIES_V  MEAV
      , EAM_WORK_ORDERS_V           EWO
where
       DB.DEPARTMENT_CODE                    =  EWO.OWNING_DEPARTMENT_CODE
  and  db.organization_id                                =  ewo.organization_id
  and  EWO.MAINTENANCE_OBJECT_ID   =  MSN.GEN_OBJECT_ID(+)
  and  EWO.ORGANIZATION_ID                  =  MSN.CURRENT_ORGANIZATION_ID(+)
  and  MSN.EAM_LOCATION_ID                  =  MEL.LOCATION_ID(+)
  and  EWO.CREATED_BY                           =  FU.USER_ID
  and  EWO.ASSET_GROUP_ID                   =  MSI.INVENTORY_ITEM_ID   (+)
  and  EWO.ORGANIZATION_ID                  =  MSI.ORGANIZATION_ID        (+)
  and  EWO.primary_item_id                           =  MSI_at.INVENTORY_ITEM_ID  (+)
  and  EWO.ORGANIZATION_ID                  =  MSI_at.ORGANIZATION_ID    (+)
  and  EWO.ASSET_NUMBER                      =  MEA.MAINTAINED_UNIT(+)
  and  EWO.REBUILD_SERIAL_NUMBER   =  mear.SERIAL_NUMBER (+)
  and  EWO.REBUILD_ITEM_ID                   =  mear.inventory_item_id    (+)
  and  EWO.REBUILD_ITEM_ID                   =  MSB.INVENTORY_ITEM_ID(+)
  and  EWO.ORGANIZATION_ID                  =  MSB.ORGANIZATION_ID(+)
  and  'EAM_METER_VALUE_CHANGE'             =  MFGL.LOOKUP_TYPE(+)
  and  EWO.WORK_ORDER_TYPE                  =  mfgl_tp.LOOKUP_CODE(+)
  and  'WIP_EAM_WORK_ORDER_TYPE'            =  MFGL_tp.LOOKUP_TYPE(+)
  and  nvl(mfgl_tp.enabled_flag,'Y')        = 'Y'
  and  FLV.LOOKUP_TYPE                      =  'EAM_YES_NO'
  and  FLV.LOOKUP_CODE                      =  EAM_METER_READINGS_JSP.IS_METER_READING_MANDATORY(J.WIP_ENTITY_ID,NULL) --AM.METER_ID)
  and  FLV.LANGUAGE                         =  USERENV('LANG')
  and  J.WIP_ENTITY_ID                      =  EWO.WIP_ENTITY_ID
  and  MEAA.ACTIVITY_ASSOCIATION_ID         =  MEAV.ACTIVITY_ASSOCIATION_ID  (+)
  and  MEAA.ASSET_ACTIVITY_ID               =  MEAV.ASSET_ACTIVITY_ID (+)
  and  MEAA.INVENTORY_ITEM_ID               =  MEAV.INVENTORY_ITEM_ID (+)
  and  MEAA.WIP_ENTITY_ID          (+)         =  EWO.WIP_ENTITY_ID
  and  EWO.WIP_ENTITY_NAME                  >= NVL(&p_ORDEM_SERVICO_INI, EWO.wip_entity_name)
  and  EWO.WIP_ENTITY_NAME                  <= NVL(&p_ORDEM_SERVICO_FIM,EWO.wip_entity_name)
  and  TRUNC(EWO.SCHEDULED_START_DATE) >= NVL(TRUNC(TO_DATE(&p_DT_INI_INI,'RRRR/MM/DD HH24:MI:SS')),TRUNC(EWO.SCHEDULED_START_DATE))
  and  TRUNC(EWO.SCHEDULED_START_DATE) <= NVL(TRUNC(TO_DATE(&p_DT_INI_FIM,'RRRR/MM/DD HH24:MI:SS')),TRUNC(EWO.SCHEDULED_START_DATE))
  and  nvl(MEL.LOCATION_CODES,'x')                    >=  NVL(&p_AREA_ATIVO_INI  ,nvl(MEL.LOCATION_CODES,'x'))
  and  nvl(MEL.LOCATION_CODES,'x')                    <=  NVL(&p_AREA_ATIVO_FIM  ,nvl(MEL.LOCATION_CODES,'x'))
  and  nvl(EWO.ASSET_NUMBER,'x')                       =    NVL(&p_NUM_ATIVO, nvl(EWO.ASSET_NUMBER,'x'))
  and  EWO.STATUS_TYPE         =  nvl(&p_STATUS_OS,EWO.STATUS_TYPE)
  and  DB.DEPARTMENT_CODE||' - '||DB.DESCRIPTION       =   NVL(&p_DEPART_ATRIB,DB.DEPARTMENT_CODE||' - '||DB.DESCRIPTION)
  and wewr.wip_entity_id (+) = ewo.wip_entity_id
  and  ewo.organization_id = nvl(&p_ORGANIZATION_ID,ewo.organization_id)
AND  0 = (SELECT count(me.meter_id)
                  FROM EAM_METERS                  ME
                       )
and rownum =3

/****/
)