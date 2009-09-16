        select ewo.ORGANIZATION_ID
              ,MSN.SERIAL_NUMBER                                               NR_ATIVO
              ,EWO.WIP_ENTITY_NAME                                             Ordem_Servico
              ,nvl(EWO.WORK_ORDER_TYPE_DISP,'')                                tipo_Servico
              ,EWO.STATUS_TYPE_DISP                                            Status
              ,TO_CHAR(EWO.SCHEDULED_START_DATE,'DD/MM/YYYY HH24:MI:SS')       Inicio_Programado
              ,TO_CHAR(EWO.SCHEDULED_COMPLETION_DATE,'DD/MM/YYYY HH24:MI:SS')  Final_Programado
              ,WO.OPERATION_SEQ_NUM                                            OP
              ,DB.DEPARTMENT_CODE                                              Depart
              ,RB.RESOURCE_CODE                                                Codigo
              ,DB.DESCRIPTION                                                  descricao
              ,msi.PRIMARY_UOM_CODE                                            UDM
              ,nvl(FUNC.LAST_NAME ,'SEM ASSOCIAÇÃO')                           FUNCIONARIO
              ,SUM(WT.TRANSACTION_QUANTITY)                                    VALOR_APONT_FUNC
              ,SUM(WOR.ASSIGNED_UNITS)                                         UNID_ATRIB
              ,SUM(WOR.USAGE_RATE_OR_AMOUNT)                                   VALOR_PROG
              ,SUM(WOR.APPLIED_RESOURCE_UNITS)                                 VALOR_APONT
              ,SUM(WOR.USAGE_RATE_OR_AMOUNT) - SUM(WOR.APPLIED_RESOURCE_UNITS) VALOR_DIF_PROG_APONT
         from
               WIP_EAM_WORK_REQUESTS_V     wewr
              ,BOM_DEPARTMENTS             DB
              ,BOM_RESOURCES               RB
              ,MTL_EAM_LOCATIONS           MEL
              ,MTL_SERIAL_NUMBERS          MSN
              ,FND_USER                    FU
              ,MTL_SYSTEM_ITEMS_B          MSI_at
              ,MTL_SYSTEM_ITEMS_B          MSI
              ,MTL_SYSTEM_ITEMS_B          MSB
              ,MTL_EAM_ASSET_NUMBERS_ALL_V MEA
              ,MTL_EAM_ASSET_NUMBERS_ALL_V MEAR
              ,mfg_lookups                 mfgl_tp
              ,MFG_LOOKUPS                 MFGL
              ,FND_LOOKUP_VALUES           FLV
              ,WIP_DISCRETE_JOBS           J
              ,MTL_EAM_ASSET_ACTIVITIES    MEAA
              ,MTL_EAM_ASSET_ACTIVITIES_V  MEAV
              ,EAM_WORK_ORDERS_V           EWO
              ,WIP_OPERATIONS              WO
              ,WIP_OPERATION_RESOURCES     WOR
              ,APPS.PER_ALL_PEOPLE_F       FUNC
              ,WIP_TRANSACTIONS            WT
        WHERE  WT.EMPLOYEE_ID                       =  FUNC.PERSON_ID
          and  WT.WIP_ENTITY_ID                     =  ewo.WIP_ENTITY_ID
          and  WT.ORGANIZATION_ID                   =  ewo.ORGANIZATION_ID
          and  WT.OPERATION_SEQ_NUM                 =  wor.OPERATION_SEQ_NUM
          and  WT.RESOURCE_SEQ_NUM                  =  wor.RESOURCE_SEQ_NUM
          and  WT.RESOURCE_ID                       =  wor.RESOURCE_ID
          and  DB.DEPARTMENT_CODE                   =  EWO.OWNING_DEPARTMENT_CODE
          and  db.organization_id                   =  ewo.organization_id
          and  wo.organization_id                   =  ewo.organization_id
          and  wo.WIP_ENTITY_ID                     =  ewo.WIP_ENTITY_ID
          and  RB.RESOURCE_ID                       =  WOR.RESOURCE_ID
          and  WO.OPERATION_SEQ_NUM                 =  WOR.OPERATION_SEQ_NUM
          and  WO.WIP_ENTITY_ID                     =  WOR.WIP_ENTITY_ID
          and  EWO.MAINTENANCE_OBJECT_ID            =  MSN.GEN_OBJECT_ID(+)
          and  EWO.ORGANIZATION_ID                  =  MSN.CURRENT_ORGANIZATION_ID(+)
          and  MSN.EAM_LOCATION_ID                  =  MEL.LOCATION_ID(+)
          and  EWO.CREATED_BY                       =  FU.USER_ID
          and  EWO.ASSET_GROUP_ID                   =  MSI.INVENTORY_ITEM_ID   (+)
          and  EWO.ORGANIZATION_ID                  =  MSI.ORGANIZATION_ID        (+)
          and  EWO.primary_item_id                  =  MSI_at.INVENTORY_ITEM_ID  (+)
          and  EWO.ORGANIZATION_ID                  =  MSI_at.ORGANIZATION_ID    (+)
          and  EWO.ASSET_NUMBER                     =  MEA.MAINTAINED_UNIT(+)
          and  EWO.REBUILD_SERIAL_NUMBER            =  mear.SERIAL_NUMBER (+)
          and  EWO.REBUILD_ITEM_ID                  =  mear.inventory_item_id    (+)
          and  EWO.REBUILD_ITEM_ID                  =  MSB.INVENTORY_ITEM_ID(+)
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
          and  MEAA.WIP_ENTITY_ID          (+)      =  EWO.WIP_ENTITY_ID
--          and  EWO.WIP_ENTITY_NAME                  >= NVL(&p_ORDEM_SERVICO_INI, EWO.wip_entity_name)
--          and  EWO.WIP_ENTITY_NAME                  <= NVL(&p_ORDEM_SERVICO_FIM,EWO.wip_entity_name)
--          and  EWO.SCHEDULED_START_DATE             >= NVL(l_DT_INI_INI,EWO.SCHEDULED_START_DATE)
--          and  EWO.SCHEDULED_START_DATE             <= NVL(TRUNC(l_DT_INI_FIM)+.99999,EWO.SCHEDULED_START_DATE)
--          and  nvl(EWO.WORK_ORDER_TYPE_DISP,'x')     = NVL(&p_TIPO_ORD_SERVICO, nvl(EWO.WORK_ORDER_TYPE_DISP,'x'))
          and  nvl(EWO.ASSET_NUMBER,'x')             = NVL(&p_NUM_ATIVO, nvl(EWO.ASSET_NUMBER,'x'))
--          and  nvl(RB.RESOURCE_CODE,'x')             = NVL(&p_CODIGO_RECURSO, nvl(RB.RESOURCE_CODE,'x'))
--          and  DB.DEPARTMENT_CODE||' - '||DB.DESCRIPTION >=   NVL(&p_DEPART_ATRIB_INI,DB.DEPARTMENT_CODE||' - '||DB.DESCRIPTION)
--          and  DB.DEPARTMENT_CODE||' - '||DB.DESCRIPTION <=   NVL(&p_DEPART_ATRIB_FIM,DB.DEPARTMENT_CODE||' - '||DB.DESCRIPTION)
--          and  nvl(FUNC.LAST_NAME,'x')               = NVL(&p_FUNCIONARIO, nvl(FUNC.LAST_NAME,'x'))
          and wewr.wip_entity_id (+)                 = ewo.wip_entity_id
--          and  ewo.organization_id                   = nvl(&p_ORGANIZATION_ID,ewo.organization_id)
        group by
               ewo.ORGANIZATION_ID
              ,MSN.SERIAL_NUMBER
              ,EWO.WIP_ENTITY_NAME
              ,nvl(EWO.WORK_ORDER_TYPE_DISP,'')
              ,EWO.STATUS_TYPE_DISP
              ,TO_CHAR(EWO.SCHEDULED_START_DATE,'DD/MM/YYYY HH24:MI:SS')
              ,TO_CHAR(EWO.SCHEDULED_COMPLETION_DATE,'DD/MM/YYYY HH24:MI:SS')
              ,WO.OPERATION_SEQ_NUM
              ,DB.DEPARTMENT_CODE
              ,RB.RESOURCE_CODE
              ,DB.DESCRIPTION
              ,msi.PRIMARY_UOM_CODE
              ,NVL(FUNC.LAST_NAME ,'SEM ASSOCIAÇÃO')
order by WO.OPERATION_SEQ_NUM