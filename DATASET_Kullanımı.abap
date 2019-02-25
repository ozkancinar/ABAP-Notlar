** Dataset uygulama tarafında verileri tutmak ve daha sonra bu verilere ulaşmak için kullanılır
*OPEN DATASET dataset.
*READ DATASET dataset INTO field.
*TRANSFER field TO dataset.
*CLOSE DATASET dataset.
*DELETE DATASET dataset

*0: OK =File has been opened, line has been read
*4: End of file
*8: File not opened

*OPEN DATASET dataset
*       [FOR OUTPUT IFOR INPUT IFOR APPENDING]
*       [IN BINARY MODE IIN TEXT MODE].



OPEN DATASET <FILE NAME> FOR OUTPUT IN <MODE> MODE ENCODING DEFAULT.
**Do file operations like writing file, reading file
CLOSE DATASET <FILE NAME>. "Close data set for file

<MODE> : BINARY MODE or TEXT MODE or LEGACY BINARY MODE or LEGACY TEXT MODE.

*------

DATA file TYPE string value 'testtemp.txt' .
 "Yazmak için dataset'i aç
OPEN DATASET file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

LOOP AT it_mara INTO wa_mara .
  CONCATENATE wa_mara-matnr wa_mara-ersda wa_mara-meins INTO lv_string
            SEPARATED BY space.
  TRANSFER lv_string TO file. "dataset'e yaz
ENDLOOP.

"Yazma işlemi bittikten sonra dataset'i kapat
CLOSE DATASET file.

*Okuma işlemi için dataset'i kapat
OPEN DATASET file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
DO.
  "Dataseti oku ve değişkene ata
  READ DATASET file INTO lv_data.
  IF sy-subrc <> 0.
    EXIT.
  ELSE.
    WRITE:/ lv_data.
  ENDIF.
ENDDO.
"dataset'i okuma işleminin ardından kapat
CLOSE DATASET file.