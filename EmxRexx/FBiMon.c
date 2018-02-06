/* FBiMon.c */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define INCL_BASE
#define INCL_DOSDEVIOCTL
#define INCL_REXXSAA
#include <os2.h>
#include "FBiMonApi.h"
#include "FBiMon.h"

unsigned long _DLL_InitTerm (unsigned long mod_handle, unsigned long flag) {
   ULONG action;

   switch (flag) {
      case 0:
         if (_CRT_init() == 0) {
            __ctordtorInit();
            return FBiMonInit();
         }
         return 0;
      case 1:
         FBiMonClose();
         __ctordtorTerm();
         _CRT_term();
         return 1;
      default:
         return 0;
   }
   return 1;
}

ULONG _System FBiMonSleep(UCHAR *name,ULONG numargs,const RXSTRING *args,PSZ *queuename,RXSTRING *retstr) {
   ULONG duree;

   if (numargs>1) {
      retstr->strlength=1;
      strcpy(retstr->strptr,"1");
      return 1;
   } /* endif */

   if (numargs==0) {
      duree=1000;
   } else {
      sscanf(RXSTRPTR(args[0]),"%d",&duree);
   } /* endif */

   DosSleep(duree);

   retstr->strlength=1;
   strcpy(retstr->strptr,"0");
   return 0;
}

LONG _System FBiMonCls(UCHAR *name,ULONG numargs,const RXSTRING *args,PSZ *queuename,RXSTRING *retstr) {
   FBiMonSetMode(0);
   retstr->strlength=1;
   strcpy(retstr->strptr,"0");
   return 0;
}

ULONG _System FBiMonChiffre(UCHAR *name,ULONG numargs,const RXSTRING *args,PSZ *queuename,RXSTRING *retstr) {
   ULONG rc;            // result code

   long caractere='0';
   long attribute=0;
   long row=0;
   long column=0;

   if (numargs!=4) {
      retstr->strlength=1;
      strcpy(retstr->strptr,"1");
      return 1;
   } /* endif */

   attribute=2;
   sscanf(RXSTRPTR(args[0]),"%c",&caractere);
   sscanf(RXSTRPTR(args[1]),"%d",&attribute);
   sscanf(RXSTRPTR(args[2]),"%d",&column);
   sscanf(RXSTRPTR(args[3]),"%d",&row);

   FBiMonAttribute(attribute);
   switch (caractere) {
   case '1':
         FBiMonWriteString("  мллм   ",column,row  );
         FBiMonWriteString("мллллл   ",column,row+1);
         FBiMonWriteString("пплллл   ",column,row+2);
         FBiMonWriteString("  лллл   ",column,row+3);
         FBiMonWriteString(" мллллм  ",column,row+4);
         FBiMonWriteString("пллллллп ",column,row+5);
         rc=9;
      break;
   case '2':
         FBiMonWriteString(" млллллллм  ",column,row  );
         FBiMonWriteString("лллпппллллл ",column,row+1);
         FBiMonWriteString("    мллллп  ",column,row+2);
         FBiMonWriteString("  мллллп    ",column,row+3);
         FBiMonWriteString("млллллммммм ",column,row+4);
         FBiMonWriteString("плллллллллп ",column,row+5);
         rc=12;
      break;
   case '3':
         FBiMonWriteString(" млллллллм  ",column,row  );
         FBiMonWriteString("ллп   плллл ",column,row+1);
         FBiMonWriteString("    мммлллп ",column,row+2);
         FBiMonWriteString("    ппплллм ",column,row+3);
         FBiMonWriteString("ллм   млллл ",column,row+4);
         FBiMonWriteString(" плллллллп  ",column,row+5);
         rc=12;
      break;
   case '4':
         FBiMonWriteString(" мм   мллм ",column,row  );
         FBiMonWriteString("лллл  лллл ",column,row+1);
         FBiMonWriteString("ллллммлллл ",column,row+2);
         FBiMonWriteString("пллллллллл ",column,row+3);
         FBiMonWriteString("      лллл ",column,row+4);
         FBiMonWriteString("      пллп ",column,row+5);
         rc=11;
      break;
   case '5':
         FBiMonWriteString("млллллллллм ",column,row  );
         FBiMonWriteString("ллллппппппп ",column,row+1);
         FBiMonWriteString("лллллллллм  ",column,row+2);
         FBiMonWriteString(" пппппплллл ",column,row+3);
         FBiMonWriteString("мммммммлллл ",column,row+4);
         FBiMonWriteString("пллллллллп  ",column,row+5);
         rc=12;
      break;
   case '6':
         FBiMonWriteString(" млллллллм  ",column,row  );
         FBiMonWriteString("ллллпппппп  ",column,row+1);
         FBiMonWriteString("лллллллллм  ",column,row+2);
         FBiMonWriteString("ллллппплллл ",column,row+3);
         FBiMonWriteString("ллллмммлллл ",column,row+4);
         FBiMonWriteString(" плллллллп  ",column,row+5);
         rc=12;
      break;
   case '7':
         FBiMonWriteString("млллллллллм ",column,row  );
         FBiMonWriteString("ппппппллллл ",column,row+1);
         FBiMonWriteString("    мллллп  ",column,row+2);
         FBiMonWriteString("   ллллп    ",column,row+3);
         FBiMonWriteString("   лллл     ",column,row+4);
         FBiMonWriteString("   пллп     ",column,row+5);
         rc=12;
      break;
   case '8':
         FBiMonWriteString(" млллллллм  ",column,row  );
         FBiMonWriteString("лллл   лллл ",column,row+1);
         FBiMonWriteString(" пллмммллп  ",column,row+2);
         FBiMonWriteString("млллппплллм ",column,row+3);
         FBiMonWriteString("лллл   лллл ",column,row+4);
         FBiMonWriteString(" плллллллп  ",column,row+5);
         rc=12;
      break;
   case '9':
         FBiMonWriteString(" млллллллм  ",column,row  );
         FBiMonWriteString("лллп   пллл ",column,row+1);
         FBiMonWriteString("лллм   мллл ",column,row+2);
         FBiMonWriteString(" пллллллллл ",column,row+3);
         FBiMonWriteString("      млллл ",column,row+4);
         FBiMonWriteString(" плллллллп  ",column,row+5);
         rc=12;
      break;
   case '0':
         FBiMonWriteString(" млллллм  ",column,row  );
         FBiMonWriteString("ллллппллл ",column,row+1);
         FBiMonWriteString("ллл млллл ",column,row+2);
         FBiMonWriteString("ллллп ллл ",column,row+3);
         FBiMonWriteString("лллммлллл ",column,row+4);
         FBiMonWriteString(" плллллп  ",column,row+5);
         rc=10;
      break;
   case ':':
         FBiMonWriteString("     ",column,row  );
         FBiMonWriteString(" мм  ",column,row+1);
         FBiMonWriteString("пллп ",column,row+2);
         FBiMonWriteString(" мм  ",column,row+3);
         FBiMonWriteString("пллп ",column,row+4);
         FBiMonWriteString("     ",column,row+5);
         rc=5;
      break;
   }

   sprintf(retstr->strptr,"%d",rc);
   retstr->strlength=strlen(retstr->strptr);
   return 0;
}

ULONG _System FBiMonCadre(UCHAR *name,ULONG numargs,const RXSTRING *args,PSZ *queuename,RXSTRING *retstr) {
   char tableau[81];

   long attribute=0;
   long row=0;
   long column=0;
   long width=0;
   long height=0;
   int i;

   if (numargs!=5) {
     retstr->strlength=1;
      strcpy(retstr->strptr,"1");
      return 1;
   } /* endif */

   sscanf(RXSTRPTR(args[0]),"%d",&attribute);
   sscanf(RXSTRPTR(args[1]),"%d",&column);
   sscanf(RXSTRPTR(args[2]),"%d",&row);
   sscanf(RXSTRPTR(args[3]),"%d",&width);
   sscanf(RXSTRPTR(args[4]),"%d",&height);
   for (i=1;i<width-1;tableau[i++]='Ф');
   tableau[0]='к'; tableau[width-1]='П'; tableau[width]='\0';
   FBiMonAttribute(attribute);
   FBiMonWriteString(tableau,column,row);
   for (i=(row+1);i<(row+height-1);i++) {
      FBiMonWriteString("Г",column,i);
      FBiMonWriteString("Г",column+width-1,i);
   } /* endfor */
   tableau[0]='Р'; tableau[width-1]='й';
   FBiMonWriteString(tableau,column,row+height-1);

   retstr->strlength=1;
   strcpy(retstr->strptr,"0");
   return 0;
}

ULONG _System FBiMonStrAt(UCHAR *name,ULONG numargs,const RXSTRING *args,PSZ *queuename,RXSTRING *retstr) {
   long attribute=0;
   long row=0;
   long column=0;

   if (numargs!=4) {
     retstr->strlength=1;
      strcpy(retstr->strptr,"1");
      return 1;
   } /* endif */

   sscanf(RXSTRPTR(args[1]),"%d",&attribute);
   sscanf(RXSTRPTR(args[2]),"%d",&row);
   sscanf(RXSTRPTR(args[3]),"%d",&column);
   FBiMonAttribute(attribute);
   FBiMonWriteString(RXSTRPTR(args[0]),column,row);

   retstr->strlength=1;
   strcpy(retstr->strptr,"0");
   return 0;
}

ULONG _System FBiMonStr(UCHAR *name,ULONG numargs,const RXSTRING *args,PSZ *queuename,RXSTRING *retstr) {
   long attribute=0;

   if (numargs!=2) {
     retstr->strlength=1;
      strcpy(retstr->strptr,"1");
      return 1;
   } /* endif */

   sscanf(RXSTRPTR(args[1]),"%d",&attribute);
   FBiMonAttribute(attribute);
   FBiMonWriteTTY(RXSTRPTR(args[0]));

   retstr->strlength=1;
   strcpy(retstr->strptr,"0");
   return 0;
}

ULONG _System FBiMonGotoXY(UCHAR *name,ULONG numargs,const RXSTRING *args,PSZ *queuename,RXSTRING *retstr) {
   long row=0;
   long column=0;

   if (numargs!=2) {
     retstr->strlength=1;
      strcpy(retstr->strptr,"1");
      return 1;
   } /* endif */

   sscanf(RXSTRPTR(args[0]),"%d",&row);
   sscanf(RXSTRPTR(args[1]),"%d",&column);
   FBiMonSetPos(column,row);

   retstr->strlength=1;
   strcpy(retstr->strptr,"0");
   return 0;
}

ULONG _System FBiMonCursor(UCHAR *name,ULONG numargs,const RXSTRING *args,PSZ *queuename,RXSTRING *retstr) {
   long first=0;
   long second=0;
   long options=0;

   if (numargs!=3) {
     retstr->strlength=1;
      strcpy(retstr->strptr,"1");
      return 1;
   } /* endif */

   sscanf(RXSTRPTR(args[0]),"%d",&first);
   sscanf(RXSTRPTR(args[1]),"%d",&second);
   sscanf(RXSTRPTR(args[2]),"%d",&options);
   FBiMonSetCursorAspect(first,second,options);

   retstr->strlength=1;
   strcpy(retstr->strptr,"0");
   return 0;
}

ULONG _System FBiMonSetAttribute(UCHAR *name,ULONG numargs,const RXSTRING *args,PSZ *queuename,RXSTRING *retstr) {
   long attribute=0;

   if (numargs!=1) {
     retstr->strlength=1;
      strcpy(retstr->strptr,"1");
      return 1;
   } /* endif */

   sscanf(RXSTRPTR(args[0]),"%d",&attribute);
   FBiMonAttribute(attribute);

   retstr->strlength=1;
   strcpy(retstr->strptr,"0");
   return 0;
}

static void FBiMonFun(PCSZ name){
   RexxRegisterFunctionDll(name,"FBIMON",name);
}

ULONG _System FBiMon_loadfuncs(PCSZ name,LONG argc,const RXSTRING *argv,PCSZ queuename,PRXSTRING retstr){
   retstr->strlength=0;
   if (argc!=0) return 1;
   FBiMonFun("FBIMONSTR");
   FBiMonFun("FBIMONSTRAT");
   FBiMonFun("FBIMONCLS");
   FBiMonFun("FBIMONCURSOR");
   FBiMonFun("FBIMONSETATTRIBUTE");
   FBiMonFun("FBIMONGOTOXY");
   FBiMonFun("FBIMONSLEEP");
   FBiMonFun("FBIMONCHIFFRE");
   FBiMonFun("FBIMONCADRE");
   return 0;
}

static char *rxstr_alloc (void) {
   PVOID p;

   DosAllocMem (&p,0xf000,PAG_READ|PAG_WRITE|PAG_COMMIT);
   return p;
}
