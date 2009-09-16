#include<stdio.h>
#include<stdlib.h>

struct produto
{
	long codigo;
	char desc[100];
	float preco;
};

struct no
{
	struct produto info;
	struct no *proximo;
};

struct no* getnode()
{
	struct no *aux;
	aux=(no*)malloc(sizeof(struct no));
	aux->proximo=NULL;
	return(aux);
}

void freenode(struct no *n)
{
	free (n);
	n=NULL;
}

struct no *tabela[1000];

int hash(long key)
{
	return(key % 1000);
}

struct produto * busca_e_insere(struct produto *p)
{
	int i;
	struct no* aux;
	i=hash(p->codigo);
	aux=tabela[i];
	while  ((aux!=NULL) && (aux->info.codigo != p->codigo))
		aux=aux->proximo;
	if(aux==NULL)
	{
		aux=getnode();
		aux->info=(*p);
		aux->proximo=tabela[i];
		tabela[i]=aux;
		return(&tabela[i]->info);
	}
	if (aux->info.codigo==p->codigo)
		return(&aux->info);
	return(NULL);
}
