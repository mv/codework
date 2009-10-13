

## Problem:
$a="//GMDB_Customizações/Padrão%20de%20Construção/Documentos/";
$i=0;
while( $i<=length($a) ) {
    $c=substr($a,$i,1); $i++;
    printf "%s   %03d   %x   \n", $c, ord($c), ord($c);
}

## to try:
    $hexdigit = (0 .. 9, 'a' .. 'f')[$num & 15];

