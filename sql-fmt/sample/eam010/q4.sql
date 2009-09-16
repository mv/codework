SELECT ativo.serial_number || ' - ' ||ativo.descriptive_text    nr_ativo
     , loca.location_codes || ' - ' ||loca.description          area
     , mena.network_serial_number
  FROM mtl_eam_network_assets     mena
     , mtl_eam_locations          loca
     , mtl_serial_numbers         ativo
 WHERE mena.organization_id          = ativo.current_organization_id
   AND mena.maintenance_object_id    = ativo.gen_object_id
   AND mena.maintenance_object_type  = 1
   AND ativo.eam_location_id         = loca.location_id (+)
 ORDER BY 1
