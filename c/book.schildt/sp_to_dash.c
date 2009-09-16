/*
** $Id: sp_to_dash.c 6 2006-09-10 15:35:16Z marcus $
*/

/*
** sp_to_dash
**   replaces spaces for dashes
*/

char _id[] = "$Id: sp_to_dash.c 6 2006-09-10 15:35:16Z marcus $";

int sp_to_dash(char *str)
{
    while (*str)
        if(*str == ' ') *str = '-';

        str++;

    return 0;
}
