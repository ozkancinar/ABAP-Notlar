////////////// SİSTEM DEĞİŞKENLERİ ///////////////

sy ile başlayan değişkenlerdir
sy- yerine syst- de kullanılabilir. Aynı şeydir. sy tercih edilir syst- eski programlarda görülür
syst - structure - sistem degiskenleri tablosu

sy-datum : Tarihi verir
sy-uzeit : Zaman verir
sy-subrc : Bir abap cümlesinde yapılan işlem başarılı olduysa 0 değeri döner. 
sy-dbcnt : Select ifadesinde toplam satırın numarasını döndürür. COUNT(*) gibi. Select döngüsünün içerisinde de 				kullanılabilir. 
sy-abcde : Alfabeyi döndürür
sy-dbsys : Veri tabanı sisteminin adını döndürür. Örn: Oracle
sy-host  : Host server bilgisini döndürür. Örn. sapserver
sy-langu : Sistem dilini döndürür
sy-mandt : Client numarasını döndürür. Örn. 400
sy-opsys : İşletim sistemi bilgisini göndürür
sy-tcode : Transaction kodunu döndürür
sy-uname : SAP kullanıcı adını döndürür
sy-repid : O anda çalışan reportun adını döndürür
sy-cprog : Ana programın adı
sy-tabix : Loop Döngülerinde ve read table okunan indexi ifade eder
sy-index : Do döngülerinde indexi ifade eder
sy-lsind : Start-of-selection ile beraber kullanılır. Kullanıcı tıklamaları yakalanır. Listenin kaçıncı indexine tıklandığını verir
sy-zonlo : O anki kullanıcının zaman tipi 
tvdir-tabname : Tablo adı yerine geçer Kullanım: PARAMETER: viewname TYPE tvdir-tabname.
sy-vline : Dikey çizgi çizer. include <list> zorunlu 
sy-uline : Yatay çizgi çizer
sy-fdpos : String içerisindeki bir harfin konumunu gösterir
sy-tfill : Internal tabledaki o anki girdi numarası
SY-TLENG : Bir internal tableın satır genişliği
SY-TMAXL : Internal tabledaki en büyük numaralı girdi
SY-TNAME : Bir internal tableın adı
SY-TOCCU : OCCURS parameter for internal tables
SY-TPAGI : Flag indicating roll-out of internal table
SY-TTABC : Number of line last read in an internal table
SY-TTABI : Offset of internal table in the roll area

*Program:
SY-DBNAM : Logical database for executable ABAP programs
SY-FMKEY : Current function code menu
SY-LDBPG : Program: ABAP database program for SY-DB
SY-MACDB : Program: ABAP database program for SY-DB
SY-SUBTY : ABAP: Call type for SUBMIT
SY-TITLE : Title of ABAP program
SY-UCOMM : Interact.: Command field function entry
SY-XCODE : Extended command field

*Lists:
SY-COLNO : Current column during list creation
SY-CPAGE : Sayfa numarası
SY-CUCOL : Cursor position (column)
SY-CUROW : Cursor position (line)
SY-LILLI : Number of current list line
SY-LINCT : Number of list lines
SY-LINNO : Current line for list creation
SY-LINSZ : Current line for list creation
SY-LISEL : Interact.: Selected line
SY-LISTI : Number of current list line
SY-LSIND : Number of secondary list
SY-LSTAT : Interact.: Status information for each list
SY-PAGNO : Runtime: Current pa~e in list
SY-STACO : Interact.: List displayed from column
SY-STARO : Interact.: Page displayed from line
SY-WTITL : Standard page header indicator

*Window:
SY-SCOLS : Standard page header indicator
SY-SROWS : Lines on screen
SY-WILLI : Number of current window line
SY-WINCO : Cursor position in window (column)
SY-WINDI : Index of current window line
SY-WINRO : Cursor position in window (line)
SY-WINSL : Interact.: Selected window line
SY-WINXI : Window coordinate (column left)
SY-WINX2 : Window coordinate (column right)
SY-WINYI : Window coordinate (line left)
SY-WINY2 : Window coordinate (line right)


*Dynpro:
SY-DYNGR : Screen group ofcurrent screen
SY-DYNNR : Number of current screen
SY-LOOPC : Number of LOOP lines at screen step loop
SY-STEPL : Number of LOOP line at screen step

*Print:
SY-CALLR : Print: ID for print dialog function
SY-PAART : Print: Fonnat
SY-PDEST : Print: Output device
SY-PEXPI : PRINT: Spool retention period
SY-PLIST : Print: Name of spool request (list name)
SY-PRABT : Print: Department on cover sheet
SY-PRBIG : Print: Selection cover sheet
SY-PRCOP : Print: Number of copies
SY-PRDSN : Print: Name of spool dataset
SY-PRIMM : PRINT: Print immediately
SY-PRNEW : PRINT: New spool request (list)
SY-PRREC : Print: Recipient
SY-PRREL : PRINT: Delete after printing
SY-PRTXT : Print: Text for cover sheet
SY-RTITL : Print: Report title ofprint program

*Date-Time
SY-DAYST : Is 'daylight saving time' active?
SY-FDAYW : Factory calendar weekday
SY-TSTLO : User''s timestamp
SY-TZONE : Time difference from Greenwich Mean Time
SY-ZONLO : User''s timezone

*Currency
SY-CCURS : Rate specification/result field (CURRENCY CONVERT)
SY-CCURT : Table rate from currency conversion
SY-CDATE : Date of rate from currency conversion
SY-CTABL : Exchange rate table from currency conversion
SY-CTYPE : Exchange rate type 'M','B','G' from CURRENCY CONY.
SY-WAERS : TOO1: Company code currency after reading

*System:
SY-APPLI : SAP applications
SY-BATCH : Batch active (X)
SY-BINPT : Batch-input active (X)
SY-CALLD : Call-mode active (X)
SY-DBSYS : System: Database system
SY-DCSYS : System: Dialog system
SY-HOST : Host328 Appendix
SY-MODNO : Number of alternative sessions
SY-OPSYS : System: Operating system
SY-SAPRL : System: SAP release
SY-SYSID : System: SAP system ID

*Batch
SY-BATZD : Background SUBMIT: Daily
SY-BATZM : Background SUBMIT: Monthly
SY-BATZO : Background SUBMIT: One-off
SY-BATZS : Background SUBMIT: Immediately
SY-BATZW : Background SUBMIT: Weekly
SY-BREP4 : Background SUBMIT: Root name of request
SY-BSPLD : Background SUBMIT: List output to spool
SY-PREFX : ABAP prefix for background jobs

*Runtime
SY-ABCDE : Constant: Alphabet (A,B,C,...)
SY-DATAR : Flag: Data received
SY-DSNAM : Runtime: Name of dataset for spool output
SY-PFKEY : Runtime: Current PF key status
SY-SPONO : Runtime: Spool number for list output
SY-SPONR : Runtime: Spool number from TRANSFER statement
SY-TFDSN : Runtime: Dataset for data extracts

*Messages
SY-MSGID : Message-ID
SY-MSGLI : Interact.: Message line (line 23)
SY-MSGNO : Message-Number
SY-MSGTY : Message-Type (E, I, W, ...2
SY-MSGVl : Message variable
SY-MSGV2 : Message variable
SY-MSGV3 : Message variable
SY-MSGV4 : Message variable
--------- sy-datum -----------------

DATA lv_date type d.

lv_date = sy-datum + 1; "Bu ifade ertesi günü ifade eder


------------------------


///////////// sy-subrc /////////////
* endselect'ten sonra değer bulunup bulunmadığını test etmek için kullanılır

report ztx0206.
tables ztxlfa1.
select * from ztxlfa1 where lifnr > 'Z'.
	write / ztxlfa1-lifnr.
	endselect.
if sy-subrc <> 0. 
	write / 'No records found'.
	endif.


/////////////////////////////////	

/////////////// sy-dbcnt ///////////////

report ztx0207.
tables ztxlfa1.
select * from ztxlfa1 order by lifnr.
	write / sy-dbcnt.
	write ztxlfa1-lifnr.
	endselect.
write / sy-dbcnt.
write 'records found'.


1 1000
2 1010
3 1020
4 1030
5 1040
6 1050
7 1060
7 records found

////////////////////////////////////////

//////////// Örnek ///////////////

reports ztx0901.
tables ztxlfa1.
parameters land1 like ztxlfa1-land1 obligatory default 'US'.
write: / 'Current date:', sy-datum,
		/ 'Current time:', sy-uzeit,
		/ 'Current user:', sy-uname.
select * from ztxlfa1 where land1 = land1 order by lifnr.
	write: / sy-dbcnt, ztxlfa1-lifnr.
	endselect.
write: / sy-dbcnt, 'records found'.
if sy-subrc <> 0.
	write: / 'No vendors exist for country', land1.
	endif.

