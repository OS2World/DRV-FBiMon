PROGRAM HrcDem;

USES
   UFBiMon,Doscall;

CONST
   longueur                               =15;
   arete                                  =5;

VAR 
   x,y                                    :Array[1..Arete] of Integer;
   xplus,yplus                            :Array[1..Arete] of Integer;
   xeff,yeff                              :Array[1..Arete] of Integer;
   xtraine,ytraine                        :Array[1..Longueur,1..Arete] of Integer;
   Couleur                                :Array[1..Arete] of Byte;
   i,j                                    :Integer;
   Position                               :Integer;

PROCEDURE Avance;
BEGIN { Avance }
  For i:=1 to Arete do Begin
     x[i]:=x[i]+xplus[i];
     y[i]:=y[i]+yplus[i];
  End;
END; { Avance }

PROCEDURE Decale;
BEGIN { Decale }
   Position:=1+(Position+1) mod Longueur;
   For j:=1 to Arete do Begin
      xeff[j]:=xtraine[position,j];
      yeff[j]:=ytraine[position,j];
      xtraine[position,j]:=x[j];
      ytraine[position,j]:=y[j];
   End;
END; { Decale }

PROCEDURE Efface;
BEGIN { Efface }
   For i:=1 to Arete-1 do Begin
      {LineMotif(xeff[i],yeff[i],xeff[i+1],yeff[i+1],couleur[i],0);}
      Line(xeff[i],yeff[i],xeff[i+1],yeff[i+1],0);
   End;
   {LineMotif(xeff[arete],yeff[arete],xeff[1],yeff[1],couleur[arete],0);}
   Line(xeff[arete],yeff[arete],xeff[1],yeff[1],0);
END; { Efface }

PROCEDURE Trace;
BEGIN { Trace }
   For i:=1 to arete-1 do Begin
      {LineMotif(x[i],y[i],x[i+1],y[i+1],couleur[i],1);}
      Line(x[i],y[i],x[i+1],y[i+1],1);
   End;
   {LineMotif(x[arete],y[arete],x[1],y[1],couleur[arete],1);}
   Line(x[arete],y[arete],x[1],y[1],1);
END; { Trace }

PROCEDURE Verify;
BEGIN { Verify }
   For i:=1 to Arete do Begin
      If (x[i]<0) then begin
         x[i]:=0; xplus[i]:=-xplus[i];
      end else begin
         If (x[i]>719) then begin
            x[i]:=719; xplus[i]:=-xplus[i];
         end; {endif}
      end; {endif}

      If (y[i]<0) then begin
         y[i]:=0; yplus[i]:=-yplus[i];
      end else begin
         If (y[i]>347) then begin
            y[i]:=347; yplus[i]:=-yplus[i];
         end; {endif}
      end; {endif}
   end; {endfor}
END; { Verify }

BEGIN
   DosSetPriority(2,1,0,0);
   SetMode(1);
   Randomize;

   Position:=1;

   For i:=1 to Arete do Begin
      x[i]:=Random(720);
      y[i]:=Random(348);
      xplus[i]:=Random(10)+1;
      yplus[i]:=Random(10)+1;
      xeff[i]:=x[i];
      yeff[i]:=y[i];
      For j:=1 to longueur do Begin
         xtraine[j,i]:=x[i];
         ytraine[j,i]:=y[i];
      End;
      Couleur[i]:=Arete;
   End; {endfor}

   Repeat
      Trace;
      Avance;
      Verify;
      Decale;
      Efface;
   Until (1<>1);
END.
