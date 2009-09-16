/*
   Marcus Vinicius Ferreira
   CCO-NB2 02127044
   04/Set/2002

   ex3.c

   Senha de 4 letras

*/

#include <stdio.h>
#include <conio.h>

int main(void)
{
    int i;
    char senha[4];

    /* Entrada dos valores
    */
    printf("\n\n  Digite a senha: ");
    for ( i=0; i<4; i++ )
    senha[i] = getch();

    /* Verifica qual a senha */
    if ( senha[0] == 'A' ) {
        if ( senha[1] == 'B' )
            if ( senha[2] == 'C' )
                if ( senha[3] == 'D' )
                    printf("\nSenha Correta! \n\n");
    }
    else {
       printf("\nSenha Incorreta! \n\n");
    }

    return 0;
}