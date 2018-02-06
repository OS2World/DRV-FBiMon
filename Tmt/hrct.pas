PROGRAM HrcT;

USES UFBiMon;

VAR 
   i,j                                    :Integer;
   x,y,r                                  :Integer;
   Chaine                                 :String;

BEGIN
   SetMode(0);
   Chaine:='Hello everybody';
   SetAttribute(Att_Normal);    Locate(10,5); Print(Chaine);
   SetAttribute(Att_Underline); Locate(10,6); Print(Chaine);
   SetAttribute(Att_Inversed);  Locate(10,7); Print(Chaine);
   SetAttribute(Att_Nothing);   Locate(10,8); Print(Chaine);
   SetAttribute(Att_Normal or Att_HighIntensity);    Locate(30,5); Print(Chaine);
   SetAttribute(Att_Underline or Att_HighIntensity); Locate(30,6); Print(Chaine);
   SetAttribute(Att_Inversed or Att_HighIntensity);  Locate(30,7); Print(Chaine);
   SetAttribute(Att_Nothing or Att_HighIntensity);   Locate(30,8); Print(Chaine);

   SetAttribute(Att_Normal or Att_Blink);    Locate(10,9); Print(Chaine);
   SetAttribute(Att_Underline or Att_Blink); Locate(10,10); Print(Chaine);
   SetAttribute(Att_Inversed or Att_Blink);  Locate(10,11); Print(Chaine);
   SetAttribute(Att_Nothing or Att_Blink);   Locate(10,12); Print(Chaine);
   SetAttribute(Att_Normal or Att_Blink or Att_HighIntensity);    Locate(30,9); Print(Chaine);
   SetAttribute(Att_Underline or Att_Blink or Att_HighIntensity); Locate(30,10); Print(Chaine);
   SetAttribute(Att_Inversed or Att_Blink or Att_HighIntensity);  Locate(30,11); Print(Chaine);
   SetAttribute(Att_Nothing or Att_Blink or Att_HighIntensity);   Locate(30,12); Print(Chaine);
END.
