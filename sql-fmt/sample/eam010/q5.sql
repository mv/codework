SELECT we.wip_entity_name
     , wo.operation_seq_num
     , wor.resource_seq_num                         seq_recurso
     , rec.description                              rec_desc
     , wor.usage_rate_or_amount                     duracao
     , wor.uom_code                                 udm_recurso_operacao
     , wo.operation_seq_num                         sequencia_da_operacao
     , bd.department_code||' - '||bd.description    depto_executante
     , wo.description                               descricao_da_operacao
     , wo.long_description                          descricao_longa
  FROM apps.eam_work_orders_v                       ewov
     , eam_op_completion_txns_v                     eoctv
     , mfg_lookups                                  lu1
     , mfg_lookups                                  lu2
     , wip_operations                               wo
     , wip_entities                                 we
     , bom_standard_operations                      bs
     , bom_departments                              bd
     , wip_discrete_jobs                            wdj
     , wip_operation_resources_v                    wor
     , bom_resources                                rec
 WHERE bd.department_id             = wo.department_id
   AND NVL(bs.operation_type,1)     = 1
   AND eoctv.wip_entity_id     (+)  = wo.wip_entity_id
   AND eoctv.operation_seq_num (+)  = wo.operation_seq_num
   AND bs.line_id                   IS NULL
   AND wo.wip_entity_id             = we.wip_entity_id
   AND lu2.lookup_code              = wo.backflush_flag
   AND lu2.lookup_type              = 'SYS_YES_NO'
   AND lu1.lookup_code              = wo.count_point_type
   AND lu1.lookup_type              = 'BOM_COUNT_POINT_TYPE'
   AND bs.standard_operation_id(+)  = wo.standard_operation_id
   AND ewov.wip_entity_id           = wo.wip_entity_id
   AND we.wip_entity_id             = wdj.wip_entity_id
   AND we.organization_id           = wdj.organization_id
   AND wdj.wip_entity_id            = wo.wip_entity_id
   AND wo.wip_entity_id             = wor.wip_entity_id
   AND wo.operation_seq_num         = wor.operation_seq_num
   AND rec.resource_id              = wor.resource_id
