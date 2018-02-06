PROGRAM HrcInfo;

USES
   Dos;

CONST
   ModeList                               :Array[0..1] of String=('Text Mode','Graphic Mode');
   UnitList                               :Array[0..1] of String=('characters','pixels');

TYPE
   DriverState                            =Record
      VersionHI                           :Word;
      VersionLO                           :Word;
      Mode                                :Word;
      ScreenWidth                         :Word;
      ScreenHeight                        :Word;
      XPosition                           :Word;
      YPosition                           :Word;
      Attribute                           :Byte;
      State                               :Byte;
      TextOffset                          :Word;
   End;

VAR
   FichierIn                              :File;
   Taille                                 :LongInt;
   BytesRead,BytesWritten                 :LongInt;
   Buffer                                 :DriverState;

BEGIN
   Assign(FichierIn,'FBIMON$');
   Reset(FichierIn,1);

   (* Taille:=FileSize(FichierIn); *)
   Taille:=18;
   BlockRead(FichierIn,Buffer,Taille,BytesRead);

   Close(FichierIn);

   With Buffer do Begin
      WriteLN('FBiMon driver state :');
      WriteLN('Version        : ',VersionHI:2,'.',VersionLO:2);
      WriteLN('Screen Mode    : ',ModeList[Mode]);
      WriteLN('Screen Width   : ',ScreenWidth,' ',UnitList[Mode]);
      WriteLN('Screen Height  : ',ScreenHeight,' ',UnitList[Mode]);
      If (Mode=0) Then Begin
         WriteLN('Cursor X       : ',XPosition);
         WriteLN('Cursor Y       : ',YPosition);
         WriteLN('Text Attribute : ',Attribute);
         WriteLN('Text Offset    : ',TextOffset);
      End;
      WriteLN('Card State     : ',State);
   End;
END.
