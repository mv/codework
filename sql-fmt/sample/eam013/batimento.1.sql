--
-- Fornecido pelo Vinicius Bocacchino em 2007-08-01
--
SELECT wdj.asset_number ativo
     , we.wip_entity_name ordem
     , we.wip_entity_id
     , we.organization_id
     , wdj.work_order_type_disp tipo_ordem
     , wdj.status_type_disp status
     , MIN(wor.start_date) data_inicial
     , MAX(wor.completion_date) data_final
     , dept.department_code depto
     , wo.operation_seq_num operacao
     , rec.resource_code codigo
     , rec.description descricao
     , wor.uom_code udm
     , SUM(wor.assigned_units) unidades_atribuidas
     , SUM(wor.usage_rate_or_amount) valor_programado
     , SUM(wor.applied_resource_units) valor_apontado
     , SUM(wor.usage_rate_or_amount) - SUM(wor.applied_resource_units) diferenca
  FROM org_organization_definitions ood
     , wip_entities                 we
     , wip_eam_work_orders_v        wdj
     , wip_operations               wo
     , wip_operation_resources      wor
     , bom_departments              dept
     , bom_resources                rec
 WHERE we.wip_entity_id = wdj.wip_entity_id
   AND we.organization_id = wdj.organization_id
   AND wdj.wip_entity_id = wo.wip_entity_id
   AND wo.wip_entity_id = wor.wip_entity_id
   AND wo.operation_seq_num = wor.operation_seq_num
   AND rec.resource_id = wor.resource_id
   AND dept.department_id = wor.department_id
   AND ood.organization_id = we.organization_id
   AND we.wip_entity_name = 'OS01100001'
 GROUP BY wdj.asset_number
        , we.wip_entity_id
        , we.organization_id
        , wdj.work_order_type_disp
        , wdj.status_type_disp
        , ood.organization_code
        , we.wip_entity_name
        , dept.department_code
        , wo.operation_seq_num
        , dept.description
        , rec.resource_code
        , rec.description
        , wor.uom_code
        ;

