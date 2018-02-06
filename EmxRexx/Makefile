CLIBSOS2=
CDLLOPTIONS=-Zomf -Zso -Zsys -mprobe
CEXEOPTIONS=-Zomf -Zsys
CC=gcc

default:              FBiMon

FBiMon:               FBiMon.dll
FBiMonApi:            FBiMonApi.obj
essai:                essai.exe

clean:
   -del *.exe *.obj core

.SUFFIXES: .c .obj

.c.obj:
   $(CC) -c $(CDLLOPTIONS) $<

FBiMonApi.obj:        FBiMonApi.c FBiMonApi.h

FBiMon.dll: FBiMon.obj FBiMonApi.obj FBiMon.def
   $(CC) -s -O -Zdll FBiMon.obj FBiMonApi.obj FBiMon.def $(CDLLOPTIONS) $(CLIBSOS2)

essai.exe:            essai.c FBiMonApi.obj
   $(CC) essai.c FBiMonApi.obj $(CEXEOPTIONS) $(CLIBSOS2)
