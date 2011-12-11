@ECHO OFF

rem
rem $Id: autoexec.bat,v 1.1 2002/05/20 14:32:42 marcus Exp $
rem

PATH c:\windows;
PATH "%PATH%";c:\windows\command;
PATH "%PATH%";c:\windows\system;
PATH "%PATH%";c:\arj;
PATH "%PATH%";c:\arj32;

PATH "%PATH%";C:\oracle\ora81\bin;
PATH "%PATH%";c:\oracle\ora80\bin;

PATH "%PATH%";c:\jdk1.2.2\bin;
PATH "%PATH%";"C:\Arquivos de programas\Oracle\jre\1.1.8\bin";
PATH "%PATH%";"C:\Arquivos de programas\Oracle\jre\1.1.7\bin";
PATH "%PATH%";C:\oracle\ora80\jdk\bin;

PATH=%PATH%;C:\BC5\BIN;

mode con codepage prepare=((850) c:\windows\COMMAND\ega.cpi)
mode con codepage select=850

rem keyb br,,c:\windows\COMMAND\keybrd2.sys /id:275
    keyb br,,c:\windows\COMMAND\keyboard.sys

lh doskey
