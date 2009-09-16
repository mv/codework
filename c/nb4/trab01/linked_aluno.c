/* $Id: linked_aluno.c 6 2006-09-10 15:35:16Z marcus $
**
** Linguagem de Programacao II / Calebe
**
** Exercicios: no. 7
**
*/


#include <stdio.h>

struct st_aluno
{
    char[30] nome;
    int      ra;
    float    nota_final;
    struct   st_aluno *next;
} aluno;

void insere (struct st_aluno *aluno);
void procura(int ra);
void print  (struct st_aluno *aluno);

int main(void)
{
    struct st_aluno aluno1;
    struct st_aluno aluno2;
    struct st_aluno aluno3;

    aluno1.nome =

}
