/* Teste FBiMon.dll */
rc=RxFuncAdd("SysLoadFuncs","REXXUTIL","SysLoadFuncs")
call SysLoadFuncs
rc=RxFuncAdd("FBiMonLoadAll","FBIMON","FBiMonLoadAll")
call FBiMonLoadAll

signal on halt name sortie

do while 1=1
   call FBiMonCls
   call FBiMonCursor 0,0,1
   /* Affiche les informations sur les disques */
   row=1
   lecteurliste="C D F G H I J K"
   do i=1 to 8
      lecteur=subword(lecteurliste,i,1)
      lectinfo=SysDriveInfo(lecteur":")
      if (lectinfo <> '') then do
         total=subword(lectinfo,3,1)
         libre=subword(lectinfo,2,1)
         call affichejauge 18,row,40,total,total-libre
         rc=FBiMonStrAt(lecteur,2,row+1,15)
         rc=FBiMonStrAt(amount(libre),2,row+1,60)
         row=row+3
      end
   end /* do */
   call FBiMonSleep 10000
   call FBiMonCls
   call FBiMonCursor 0,0,1

   /* Affiche l'heure */
   call affichedate
   do 10
      call afficheheure
      call FBiMonSleep 900
   end /* do */
end /* do */

exit

/* affichejauge x,y,l,max,valeur */
affichejauge:
   x=arg(1); y=arg(2); l=arg(3); lmax=arg(4); valeur=arg(5)
   nb=trunc((valeur/lmax)*(l-2))
   rc=FBiMonCadre(15,x,y,l,3);
   rc=FBiMonStrAt(copies("Û",nb)copies("°",l-2-nb),2,y+1,x+1);
return

/* Retourne l'argument ‚crit en Ko Mo ou Go */
amount: procedure
   valeur=arg(1)
   nb=1
   do while valeur > 1024
      valeur=valeur/1024
      nb=nb+1
   end /* do */
return trunc(valeur,1)" "subword("b Kb Mb Gb Tb",nb,1)

/* Affiche la date en cours en gros */
affichedate: procedure
   ladate=date('E')
   ch.1=substr(ladate,1,1)
   ch.2=substr(ladate,2,1);
   ch.3=':'
   ch.4=substr(ladate,4,1);
   ch.5=substr(ladate,5,1);
   col=12
   do i=1 to 5
      col=col+FBiMonChiffre(ch.i,2,col,1);
   end /* do */
return

/* Affiche l'heure en cours en gros */
afficheheure: procedure
   heure=time()
   ch.1=substr(heure,1,1)
   ch.2=substr(heure,2,1);
   ch.3=":"
   ch.4=substr(heure,4,1);
   ch.5=substr(heure,5,1);
   ch.6=":"
   ch.7=substr(heure,7,1);
   ch.8=substr(heure,8,1);
   col=0
   do i=1 to 8
      col=col+FBiMonChiffre(ch.i,2,col,12);
   end /* do */
   if (80 >= col) then
      do row=12 to 17
         rc=FBiMonStrAt(copies(" ",80-col),0,row,col)
      end /* do */
   
return

sortie:
   call FBiMonCls
   exit
