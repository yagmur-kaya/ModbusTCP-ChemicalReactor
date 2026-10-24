PROGRAM PLC_PRG
VAR
	startButon:BOOL;
	stopButon:BOOL;
	hedefSicaklik:WORD;
	isitici:BOOL;
	sogutucuVana:BOOL;
	karistirici:BOOL;
	sistemCalisiyor:BOOL;
	timer:TON;
	canliSicaklik:DUT;
	gecen_sure:WORD:=0;
	parti_sayac:WORD;
	durum_kod:WORD;
	partiRapor:ARRAY[0..2] OF WORD;
END_VAR

timer(IN:= NOT timer.Q,PT:=T#1S);
IF startButon THEN
	sistemCalisiyor:=TRUE;
	durum_kod:=10;
	karistirici:=TRUE;
END_IF
IF stopButon THEN
	sistemCalisiyor:=FALSE;
	karistirici:=FALSE;
	sogutucuVana:=FALSE;
	isitici:=FALSE;
	durum_kod:=999;
END_IF
IF timer.Q THEN
	IF sistemCalisiyor THEN
		gecen_sure:=gecen_sure+1;
		IF isitici THEN
			canliSicaklik.canliDeger:=canliSicaklik.canliDeger+1.5;
		END_IF
		IF sogutucuVana THEN
			canliSicaklik.canliDeger:=canliSicaklik.canliDeger-2.0;
		END_IF
		IF NOT isitici AND NOT sogutucuVana THEN
			canliSicaklik.canliDeger:=canliSicaklik.canliDeger-0.2;
		END_IF
	END_IF
END_IF
//Isıtıcı Kontrol
IF canliSicaklik.canliDeger<=TO_REAL(hedefSicaklik-3.0) AND sistemCalisiyor THEN
	isitici:=TRUE;
ELSIF canliSicaklik.canliDeger>=TO_REAL(hedefSicaklik) AND sistemCalisiyor THEN
    isitici:=FALSE;
END_IF
//Aşırı Isınma Emniyeti
IF 	canliSicaklik.canliDeger>=TO_REAL(hedefSicaklik+8.0) AND sistemCalisiyor THEN
	sogutucuVana:=TRUE;
ELSIF canliSicaklik.canliDeger<=TO_REAL(hedefSicaklik) AND sistemCalisiyor THEN	
    sogutucuVana:=FALSE;
END_IF
IF gecen_sure>=45 THEN
	sistemCalisiyor:=FALSE;
	startButon:=FALSE;
	isitici:=FALSE;
	karistirici:=FALSE;
	sogutucuVana:=FALSE;
	gecen_sure:=0;
	parti_sayac:=parti_sayac+1;
	durum_kod:=200;
END_IF
    partiRapor[0]:=parti_sayac;
	partiRapor[1]:=gecen_sure;
	partiRapor[2]:=durum_kod;