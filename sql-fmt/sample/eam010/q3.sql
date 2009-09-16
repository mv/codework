SELECT ROWNUM                           item
     , wro.operation_seq_num            seq
     , m.description                    recurso
     , m.segment1                       cod
     , 'ES'                             cat
     , mth.request_number               requisicao
     , m.primary_uom_code               udm
     , wro.required_quantity            prev
     , wro.date_required                requerida
     , we.wip_entity_id
     , NULL                             campo_null
  FROM mtl_system_items_b_kfv           msikfv
     , mtl_system_items                 m
     , mtl_item_locations               l
     , mfg_lookups                      lu
     , wip_requirement_operations       wro
     , wip_entities                     we
     , mtl_item_locations_kfv           milk
     , mtl_txn_request_headers          mth
     , mtl_txn_request_lines            mtl
 WHERE mtl.header_id                    = mth.header_id         (+)
   AND mtl.organization_id              = mth.organization_id   (+)
   AND mtl.txn_source_id     (+)        = wro.wip_entity_id
   AND mtl.organization_id   (+)        = wro.organization_id
   AND mtl.txn_source_line_id (+)       = wro.operation_seq_num
   AND mtl.inventory_item_id (+)        = wro.inventory_item_id
   AND msikfv.organization_id           = wro.organization_id
   AND msikfv.inventory_item_id         = wro.inventory_item_id
   AND m.inventory_item_id              = wro.inventory_item_id
   AND we.wip_entity_id                 = wro.wip_entity_id
   AND l.inventory_location_id (+)      = NVL(wro.supply_locator_id,'-1')
   AND milk.inventory_location_id (+)   = NVL(wro.supply_locator_id,'-1')
   AND m.organization_id                = wro.organization_id
   AND l.organization_id (+)            = wro.organization_id
   AND milk.organization_id (+)         = wro.organization_id
   AND lu.lookup_type                   = 'WIP_SUPPLY_SHORT'
   AND lu.lookup_code                   = wro.wip_supply_type
   AND wro.inventory_item_id           IN ( SELECT inventory_item_id
                                              FROM mtl_system_items
                                             WHERE stock_enabled_flag = 'Y')
 ORDER BY  1,2,3
