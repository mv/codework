/*

  levantar a base de dados

*/


FORCE    - se a base estiver levantada faz um shutdown abort e inicia novamente 
RESTRICT - so permite conexao de usuarios com RESTRICTED SESSION no perfil

OPEN - disponibiliza a base para os usuarios
MOUNT - monta a base mais nao abre os databafiles
NOMOUNT - monta so a SGA

-- estas opcoes sao usadas com o parametro MOUNT
EXCLUSIVE - abri exclusiva
SHARED    - abrir compartilhada 

startup 
FORCE/RESTRICT    
pfile='/db/oradata/glpp/script/initglpp.ora' 
OPEN/MOUNT/NOMOUNT
EXCLUSIVE/SHARED


-- outros
alter database open;
alter database mount;

shutdown immediate;
shutdown abort:
shutdown normal;
shutdown transactional;


