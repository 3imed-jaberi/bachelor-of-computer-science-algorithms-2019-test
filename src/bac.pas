//___ Nom de programme ___//
program bac2019 ; 


//___ Bibliotheques ___//

// borland-pascal-compiler ( turbo pascal ) : wincrt
// free-pascal-compiler : crt 

uses crt ; 

//___ Nouveaux Types ___//
type
   matrice1 = array [ 'A'..'F', 'A'..'F' ] of char; // 6*6
   matrice2 = array [ 'A'..'G' , 'A'..'F' ] of char; // 7*6
   tableau = array [ 'A'..'F' ] of char; // 6 
  

//___ Variables Globals ___//
var 
 msg , cle : string ; 
 M1 : matrice1 ;
 M2 : matrice2 ;


//___ FUNCs & PROCs ___//


// Verification de msg et cle .. 
function ValidationMsgEtCle(ch:string ; key : boolean ):boolean;
var 
  j : integer ;
begin
  j := 1 ;
  if (key) then 
    begin
          while ( (ch[j] in ['A'..'Z']) and (j <= length(ch)) ) do 
            begin
                j := j+1;
            end;
          ValidationMsgEtCle := ((j>length(ch)) and ( length(ch) = 6 )) ;       
    end
  else
    begin
          while ( (ch[j] in ['a'..'z','0'..'9',' ']) and (j <= length(ch)) ) do 
            begin
                j := j+1;
            end;
          ValidationMsgEtCle := ((j>length(ch)) and ( length(ch) in [1..18])) ;            
    end;
end;

// Saisir le message à crypter Msg
procedure SaisirMsg (var msg:string);
begin
  repeat
    Writeln('Taper le message à crypter :');      
    Readln(msg);  
  until (ValidationMsgEtCle(msg , false));         
end;

// Saisir la clé de chiffrement
procedure SaisirCle (var cle:string);
begin
  repeat
    Writeln(' Taper le cle : ');      
    Readln(cle);  
  until (ValidationMsgEtCle(cle , true));        
end;

// Init M1 .. 
procedure GenererCryptageRef (var M1:matrice1);
var
  j , i : char ; 
  RandomNumber : byte ;

begin
   randomize();
   for i := 'A' to 'F' do
   begin
     for j := 'A' to 'F' do
       begin
          repeat
            RandomNumber := random(255);       
          until ((RandomNumber in [48..57] ) or (RandomNumber in [97..122] ));

          M1[i,j] := chr(RandomNumber)  ; 

       end;             
   end;            
end;

// Générer le message Msgi à partir de M1
function GenererMsgi (M1:matrice1 ; msg:string):string;
var 
  j , i : char ; 
  msgi : string ; 
  k : integer ;
begin
   msgi := '' ; 
   for k := 1 to length(msg) do
    //Retourner les indices d’un caractère dans la matrice M1
   begin
     if ( msg[k] = ' ' ) then
       begin
          msgi := msgi + msg[k] ;
       end
     else
       begin
          i := 'A';
          j := 'A';
          while ( (i <= 'F') and (m1[i,j] <> msg[k]) ) do 
            begin
               if ( j = 'F' ) then
                 begin
                    j := 'A' ;
                    i := succ(i);    
                 end
               else
                 begin
                    j := succ(j);
                 end;
            end;
          msgi := msgi + i+j ;
       end;       
   end; 
   GenererMsgi := msgi ;      
end;

//Générer la matrice M2 à partir de la clé
procedure GenererCryptageAvecCleRef(var M2 : matrice2 ; cle , msgi : string);
var 
  j , i : char ; 
  k : integer ; 
begin
  for j := 'A' to 'F' do
    M2['A',j] := cle[ord(j)-64];

  k := 1 ; 
  
  for i := 'B' to 'G' do
     for j := 'A' to 'F' do
       begin
         if (k <= length(msgi)) then
           begin
             m2[i,j] := msgi[k] ;
             k := k + 1 ;
           end
         else
           begin
             m2[i,j] := ' ' ; 
           end;        
       end;              
end;

// Trier M2 selon la ligne numéro 1 (Clé)
procedure Trier(var M2 : matrice2);
var 
  j , i , aux : char ; 
  t : tableau ; 
  temp : boolean ;  
begin
  t := M2['A'] ; 
  repeat
    temp := false ; 
    for j := 'A' to 'E' do
      begin
        if (t[j] > t[succ(j)]) then 
         begin
          aux := t[j];
          t[j] := t[succ(j)];
          t[succ(j)] := aux ;
          temp := true ;
          for i := 'A' to 'G' do
            begin
              aux := M2[i,j] ;
              M2[i,j] := M2[i,succ(j)] ;
              M2[i,succ(j)] := aux ;        
            end;
         end;
      end;   
  until (temp = false);         
end;

// result de cryptage .. 
function ResultCrypter (M2 : matrice2):string;
var 
  j , i : char ; 
  ch : string ; 
begin
   ch := '' ;
   for j := 'A' to 'F' do
     for i := 'B' to 'G' do
       ch := ch + M2[i,j] ;
               
  ResultCrypter := ch ;                    
end;


//___ Main ___//
BEGIN

  SaisirMsg(msg);
  SaisirCle(cle);
  GenererCryptageRef(M1);       
  GenererCryptageAvecCleRef(M2,cle,GenererMsgi(M1 , msg ));
  Trier(M2);
  Writeln(' La resultat de cryptage : \n ',ResultCrypter(M2)); 

END.