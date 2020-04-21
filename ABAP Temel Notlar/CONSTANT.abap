*Sabit değişken tanımlamak için kullanılır. Bu değişkenler ABAP programı çalışması sırasında değiştirilemez

CONSTANTS pi TYPE p LENGTH 8 DECIMALS 14 
                 VALUE '3.14159265358979'. 

CONSTANTS: BEGIN OF sap_ag, 
             zip_code TYPE n LENGTH 5 VALUE '69189', 
             city     TYPE string VALUE `Walldorf`, 
             country  TYPE string VALUE `Germany`, 
           END OF sap_ag. 
