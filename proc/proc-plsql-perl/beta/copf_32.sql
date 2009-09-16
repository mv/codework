SELECT         CHR(39)||SUBSTR(num_cpf,-4) ||CHR(39)
||''||','||''||CHR(39)||SUBSTR( SUBSTR(nom_consumidor,1,INSTR(nom_consumidor,' ',1)-1 ) ,1,10 ) ||CHR(39)
||''||','||''||CHR(39)||idc_origem         ||CHR(39)
||''||','||''||CHR(39)||SUBSTR(num_cpf,1,4)||CHR(39)
||''||','||''||CHR(39)||dat_nascimento     ||CHR(39)
||''||','||''||CHR(39)||SUBSTR(num_cpf,-2)*1000 ||CHR(39)
||''||','||''||CHR(39)||SUBSTR(num_cpf,-2)*100 ||CHR(39)
||''||','||''||CHR(39)||SUBSTR(num_cpf,-2)     ||CHR(39)
  FROM copf_32
 WHERE ide_consumidor_fisica IS NOT NULL
   AND ROWNUM <=10
/

