UNIT UFBiMon;

INTERFACE
CONST
   { Text Attributes constants }
   Att_Nothing                            =$00;
   Att_Underline                          =$01;
   Att_Normal                             =$07;
   Att_Inversed                           =$70;
   Att_HighIntensity                      =$08;
   Att_Blink                              =$80;

   MaxX                                   =719;
   MaxY                                   =347;

   PROCEDURE SetMode(Mode:Byte);
   PROCEDURE SetAttribute(Attribute:Byte);
   PROCEDURE Locate(x,y:Word);
   PROCEDURE Print(VAR Message:String);
   PROCEDURE HoriLine(x0,x1,y:Word;c:Byte);
   PROCEDURE VertLine(x,y0,y1:Word;c:Byte);
   PROCEDURE Line(x0,y0,x1,y1:Word;c:Byte);
   PROCEDURE LineMotif(x0,y0,x1,y1:Word;m,c:Byte);
   PROCEDURE Circle(x,y,r:Word;c:Byte);

   PROCEDURE FlushPoint;
   PROCEDURE FlushHorizontalLine;
   PROCEDURE FlushVerticalLine;

IMPLEMENTATION
TYPE 
   OnePoint                               =Record
      Command                             :Word;
      x,y                                 :Word;
      color                               :Byte;
   End;

   ScreenMode                             =Record
      Command                             :Word;
      Md                                  :Byte;
   End;

   ScreenAttribute                        =Record
      Command                             :Word;
      Att                                 :Byte;
   End;

   ScreenPosition                         =Record
      Command                             :Word;
      spx,spy                             :Word;
   End;

   ScreenPrintIn                          =Record
      Command                             :Word;
      Dummy                               :Byte;
      Msg                                 :String;
   End;

   HorizontalLine                         =Record
      Command                             :Word;
      x0,x1                               :Word;
      y                                   :Word;
      color                               :Byte;
   End;

   VerticalLine                           =Record
      Command                             :Word;
      x                                   :Word;
      y0,y1                               :Word;
      color                               :Byte;
   End;

CONST
   MaxVerticalLine                        =40;
   MaxHorizontalLine                      =40;
   MaxPoint                               =40;
   SetPixelCmd                            =$0A;
   HoriLineCmd                            =$0C;
   VertLineCmd                            =$0D;
   ScreenModeCmd                          =$01;
   ScreenAttributeCmd                     =$02;
   ScreenPositionCmd                      =$09;
   PrintCmd                               =$07;

VAR
   FichierOut                             :File;
   BytesWritten                           :LongInt;
   SeveralPoints                          :Record
      State                               :Byte;
      Liste                               :Array[0..MaxPoint-1] of OnePoint;
   End;
   SeveralHorizontalLine                  :Record
      State                               :Byte;
      Liste                               :Array[0..MaxHorizontalLine-1] of HorizontalLine;
   End;
   SeveralVerticalLine                    :Record
      State                               :Byte;
      Liste                               :Array[0..MaxVerticalLine-1] of VerticalLine;
   End;

PROCEDURE SetMode(Mode:Byte);
VAR 
   Dummy                                  :ScreenMode;
BEGIN { SetMode }
   With Dummy do Begin
      Command:=ScreenModeCmd;
      Md:=Mode;
   End;
   BlockWrite(FichierOut,Dummy,Sizeof(Dummy),BytesWritten);
END; { SetMode }

PROCEDURE SetAttribute(Attribute:Byte);
VAR 
   Dummy                                  :ScreenAttribute;
BEGIN { SetAttribute }
   With Dummy do Begin
      Command:=ScreenAttributeCmd;
      Att:=Attribute;
   End;
   BlockWrite(FichierOut,Dummy,Sizeof(Dummy),BytesWritten);
END; { SetAttribute }

PROCEDURE Locate(x,y:Word);
VAR 
   Dummy                                  :ScreenPosition;
BEGIN { Locate }
   With Dummy do Begin
      spx:=x; spy:=y;
      Command:=ScreenPositionCmd;
   End;
   BlockWrite(FichierOut,Dummy,SizeOf(Dummy),BytesWritten);
END; { Locate }

PROCEDURE Print(VAR Message:String);
VAR 
   Dummy                                  :ScreenPrintIn;
BEGIN { Print }
   With Dummy do Begin
      Command:=PrintCmd;
      Msg:=Message;
      Dummy:=Length(Message);
      Byte(Msg[0]):=0;
   End;
   BlockWrite(FichierOut,Dummy,Length(Message)+4,BytesWritten);
END; { Print }

PROCEDURE AddPoint(adx,ady:Integer;c:Byte);
BEGIN { AjoutePoint }
   if (adx>=0) and (adx<=MaxX) and (ady>=0) and (ady<=MaxY) then begin
      With SeveralPoints.Liste[SeveralPoints.State] do Begin
         Command:=SetPixelCmd;
         x:=adx;
         y:=ady;
         color:=c;
      End;
      Inc(SeveralPoints.State);
      If (SeveralPoints.State>=MaxPoint) then begin
         SeveralPoints.State:=0;
         BlockWrite(FichierOut,SeveralPoints.Liste,SizeOf(OnePoint)*MaxPoint,BytesWritten);
      end; {endif}
   end; {endif}
END; { AjoutePoint }

PROCEDURE FlushPoint;
BEGIN { FlushPoint }
   If (SeveralPoints.State<>0) Then Begin
      BlockWrite(FichierOut,SeveralPoints.Liste,SizeOf(OnePoint)*SeveralPoints.State,BytesWritten);
   End;
   SeveralPoints.State:=0;
END; { FlushPoint }

PROCEDURE AddHorizontalLine(adx0,adx1,ady:Integer;c:Byte);
BEGIN { AddHorizontalLine }
   if (adx0>=0) and (adx0<=MaxX) and (ady>=0) and (ady<=MaxY) and (adx1>=0) and (adx1<=MaxX) then begin
      With SeveralHorizontalLine.Liste[SeveralHorizontalLine.State] do Begin
         Command:=HoriLineCmd;
         x0:=adx0;
         x1:=adx1;
         y:=ady;
         color:=c;
      End;
      With SeveralHorizontalLine do Begin
         Inc(State);
         If (State>=MaxHorizontalLine) then begin
            BlockWrite(FichierOut,Liste,SizeOf(SeveralHorizontalLine),BytesWritten);
            State:=0;
         end; {endif}
      end;
   end; {endif}
END; { AddHorizontalLine }

PROCEDURE FlushHorizontalLine;
BEGIN { FlushHorizontalLine }
   With SeveralHorizontalLine do Begin
      If (State<>0) Then Begin
         BlockWrite(FichierOut,Liste,SizeOf(HorizontalLine)*State,BytesWritten);
         State:=0;
      End;
   End;
END; { FlushHorizontalLine }

PROCEDURE AddVerticalLine(adx,ady0,ady1:Integer;c:Byte);
BEGIN { AddVerticalLine }
   if (adx>=0) and (adx<=MaxX) and (ady0>=0) and (ady0<=MaxY) and (ady1>=0) and (ady1<=MaxY) then begin
      With SeveralVerticalLine.Liste[SeveralVerticalLine.State] do Begin
         Command:=VertLineCmd;
         x:=adx;
         y0:=ady0;
         y1:=ady1;
         color:=c;
      End;
      With SeveralVerticalLine do Begin
         Inc(State);
         If (State>=MaxVerticalLine) then begin
            BlockWrite(FichierOut,Liste,SizeOf(SeveralVerticalLine),BytesWritten);
            State:=0;
         end; {endif}
      end;
   end; {endif}
END; { Add }

PROCEDURE FlushVerticalLine;
BEGIN { FlushVerticalLine }
   With SeveralVerticalLine do Begin
      If (State<>0) Then Begin
         BlockWrite(FichierOut,Liste,SizeOf(VerticalLine)*State,BytesWritten);
         State:=0;
      End;
   End;
END; { FlushVerticalLine }

PROCEDURE HoriLine(x0,x1,y:Word;c:Byte);
BEGIN { HoriLine }
   AddHorizontalLine(x0,x1,y,c);
END; { HoriLine }

PROCEDURE VertLine(x,y0,y1:Word;c:Byte);
BEGIN { VertLine }
   AddVerticalLine(x,y0,y1,c);
END; { VertLine }


PROCEDURE Line(x0,y0,x1,y1:Word;c:Byte);
VAR
   d,dx,dy                                :Integer;
   aincr,bincr,xincr,yincr                :Integer;
   x,y,dummy                              :Integer;
   anx,any                                :Integer;
BEGIN { Line }
   if (abs(x1-x0)<abs(y1-y0)) Then Begin
      if (y0>y1) Then Begin
         dummy:=x0; x0:=x1; x1:=dummy;
         dummy:=y0; y0:=y1; y1:=dummy;
      End;

      if (x1>x0) Then Begin
         xincr:=1;
      End else Begin
         xincr:=-1;
      End;

      dy:=y1-y0;
      dx:=abs(x1-x0);
      d:=(dx shl 1)-dy;
      aincr:=(dx-dy) shl 1;
      bincr:=dx shl 1;
      x:=x0;
      y:=y0;

      any:=y0;
      for y:=y0+1 to y1 do Begin
         if (d>=0) Then Begin
            AddVerticalLine(x,any,y-1,c);
            any:=y;
            inc(x,xincr);
            inc(d,aincr);
         End Else Begin
            inc(d,bincr);
         End;
      End;
      AddVerticalLine(x,any,y1,c);
      {FlushVerticalLine;}
   End Else Begin
      if (x0>x1) Then Begin
         dummy:=x0; x0:=x1; x1:=dummy;
         dummy:=y0; y0:=y1; y1:=dummy;
      End;

      if (y1>y0) Then Begin
         yincr:=1;
      End Else Begin
         yincr:=-1;
      End;

      dx:=x1-x0;
      dy:=abs(y1-y0);
      d:=(dy shl 1)-dx;
      aincr:=(dy-dx) shl 1;
      bincr:=dy shl 1;
      x:=x0;
      y:=y0;

      anx:=x0;
      for x:=x0+1 to x1 do Begin
         if (d>=0) Then Begin
            AddHorizontalLine(anx,x-1,y,c);
            anx:=x;
            inc(y,yincr);
            inc(d,aincr);
         End Else Begin
            inc(d,bincr);
         End;
      End;
      AddHorizontalLine(anx,x1,y,c);
      {FlushHorizontalLine;}
   End;
   {FlushPoint;}
END; { Line }

PROCEDURE LineMotif(x0,y0,x1,y1:Word;m,c:Byte);
VAR
   d,dx,dy                                :Integer;
   aincr,bincr,xincr,yincr                :Integer;
   x,y,dummy                              :Integer;
   Compteur                               :Byte;
   Couleur                                :Byte;
BEGIN { Line }
   Compteur:=m;
   if (abs(x1-x0)<abs(y1-y0)) Then Begin
      if (y0>y1) Then Begin
         dummy:=x0; x0:=x1; x1:=dummy;
         dummy:=y0; y0:=y1; y1:=dummy;
      End;

      if (x1>x0) Then Begin
         xincr:=1;
      End else Begin
         xincr:=-1;
      End;

      dy:=y1-y0;
      dx:=abs(x1-x0);
      d:=(dx shl 1)-dy;
      aincr:=(dx-dy) shl 1;
      bincr:=dx shl 1;
      x:=x0;
      y:=y0;

      AddPoint(x,y,c);
      for y:=y0+1 to y1 do Begin
         if (d>=0) Then Begin
            inc(x,xincr);
            inc(d,aincr);
         End Else Begin
            inc(d,bincr);
         End;
         Dec(Compteur);
         If (Compteur=0) then begin
            AddPoint(x,y,c);
            Compteur:=m;
         end; {endif}
      End;
   End Else Begin
      if (x0>x1) Then Begin
         dummy:=x0; x0:=x1; x1:=dummy;
         dummy:=y0; y0:=y1; y1:=dummy;
      End;

      if (y1>y0) Then Begin
         yincr:=1;
      End Else Begin
         yincr:=-1;
      End;

      dx:=x1-x0;
      dy:=abs(y1-y0);
      d:=(dy shl 1)-dx;
      aincr:=(dy-dx) shl 1;
      bincr:=dy shl 1;
      x:=x0;
      y:=y0;

      AddPoint(x,y,c);
      for x:=x0+1 to x1 do Begin
         if (d>=0) Then Begin
            inc(y,yincr);
            inc(d,aincr);
         End Else Begin
            inc(d,bincr);
         End;
         Dec(Compteur);
         If (Compteur=0) then begin
            AddPoint(x,y,c);
            Compteur:=m;
         end; {endif}
      End;
   End;
   FlushPoint;
END; { Line }

PROCEDURE Circle(x,y,r:Word;c:Byte);
VAR
   d,ox,oy                                :Integer;
BEGIN { Circle }
   ox:=x;
   oy:=y;
   x:=0;
   y:=r;
   d:=2-r;
   Repeat
      AddPoint(ox+x,oy+y,c);
      AddPoint(ox+y,oy+x,c);
      AddPoint(ox+y,oy-x,c);
      AddPoint(ox-x,oy+y,c);
      AddPoint(ox-x,oy-y,c);
      AddPoint(ox-y,oy-x,c);
      AddPoint(ox-y,oy+x,c);
      AddPoint(ox+x,oy-y,c);
      if (d<0) Then Begin
         inc(d,x+3);
      End Else Begin
         inc(d,x-y+1);
         dec(y);
      End;
      inc(x);
   Until (x>y);
   FlushPoint;
END; { Circle }

{ Unit initialization }
BEGIN
   Assign(FichierOut,'FBIMON$');
   ReWrite(FichierOut,1);

   SeveralPoints.State:=0;
END.
