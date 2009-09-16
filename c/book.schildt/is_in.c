// $Id: is_in.c 6 2006-09-10 15:35:16Z marcus $


/*
** is_in
**   return 0: false
**   return 1: true - character c is in string
*/

char _id[] = "$Id: is_in.c 6 2006-09-10 15:35:16Z marcus $";

int is_in(char *s, char c)
{
    while (*s)
        if(*s == c) return 1;
        else s++;

    return 0;
}
