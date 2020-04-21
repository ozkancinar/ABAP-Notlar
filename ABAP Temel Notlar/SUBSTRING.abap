* String içerisinden belli bir bölgeyi alır
SELECT SUBSTRING ('1234567890',4,2) "substring" FROM DUMMY;

"The following example returns 'ABCD' from the binary value x'ABCDEF':

SELECT SUBSTRING(x'ABCDEF',1,2) "substring" FROM DUMMY;