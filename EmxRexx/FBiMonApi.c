/* FBiMonApi.c */
#include "FBiMonApi.h"

HFILE FBiMonID=0;      // FBiMon DD handle

int FBiMonInit() {
   ULONG action;
   if (DosOpen("FBIMON$",&FBiMonID,&action,0,FILE_NORMAL,FILE_OPEN, OPEN_ACCESS_READWRITE | OPEN_SHARE_DENYREADWRITE,0)==0) return 1;
   return 0;
}

void FBiMonClose() {
   FBiMonSetMode(0);
   if (FBiMonID) DosClose(FBiMonID);
}

void FBiMonSetMode(int mode) {
   ScreenMode Dummy;
   ULONG BytesWritten;

   Dummy.Command=ScreenModeCmd;
   Dummy.Md=mode;
   DosWrite(FBiMonID,&Dummy,sizeof(Dummy),&BytesWritten);
}

void FBiMonWriteString(char *buffer,int x,int y) {
   ScreenPrintIn DummyStr;
   ScreenPosition DummyPos;
   ULONG BytesWritten;

   FBiMonSetPos(x,y);

   DummyStr.Command=PrintCmd;
   DummyStr.Length=strlen(buffer);
   strcpy(DummyStr.Msg,buffer);
   DosWrite(FBiMonID,&DummyStr,sizeof(DummyStr),&BytesWritten);
}

void FBiMonSetPos(int x,int y) {
   ScreenPosition DummyPos;
   ULONG BytesWritten;

   DummyPos.Command=ScreenPositionCmd;
   DummyPos.spx=x;
   DummyPos.spy=y;
   DosWrite(FBiMonID,&DummyPos,sizeof(DummyPos),&BytesWritten);
}

void FBiMonWriteTTY(char *buffer) {
   ScreenPrintIn DummyStr;
   ULONG BytesWritten;

   DummyStr.Command=PrintCmd;
   DummyStr.Length=strlen(buffer);
   strcpy(DummyStr.Msg,buffer);
   DosWrite(FBiMonID,&DummyStr,sizeof(DummyStr),&BytesWritten);
}

void FBiMonAttribute(char att) {
   ScreenAttribute Dummy;
   ULONG BytesWritten;

   Dummy.Command=ScreenAttributeCmd;
   Dummy.Att=att;
   DosWrite(FBiMonID,&Dummy,sizeof(Dummy),&BytesWritten);
}

void FBiMonSetCursorAspect(char first,char second,char options) {
   SetCursorAspect Dummy;
   ULONG BytesWritten;

   Dummy.Command=SetCursorAspectCmd;
   Dummy.first=first;
   Dummy.second=second;
   Dummy.options=options;
   DosWrite(FBiMonID,&Dummy,sizeof(Dummy),&BytesWritten);
}
