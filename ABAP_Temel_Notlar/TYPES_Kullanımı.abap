*internal Table declaration (new method)     "USE THIS WAY!!!
TYPES: BEGIN OF t_ekpo,
  ebeln TYPE ekpo-ebeln,
  ebelp TYPE ekpo-ebelp,
 END OF t_ekpo.
DATA: it_ekpo TYPE STANDARD TABLE OF t_ekpo INITIAL SIZE 0,      "itab
      wa_ekpo TYPE t_ekpo.                    "work area (header line)

*---- Table type tanımlama:
TYPES: BEGIN OF ty_line,
       vbeln TYPE vbeln_va,
       posnr TYPE posnr_va,
       matnr TYPE matnr,
       matkl TYPE matkl,
       meins TYPE meins,
       END OF ty_line.

TYPES: ty_table TYPE TABLE OF ty_line. "table type"


* STRUCTURED TYPES
types: begin of address,
		street(25),
		city(20),
		region(7),
		country(15),
		postal_code(9),
		end of address.

data: customer_addr type address,
		vendor_addr type address,
		employee_addr type address,
		shipto_addr type address.

customer_addr-street = '221B Bakery Street'.
employee_addr-country = 'UK'.

write: / customer_addr-street,
		employee_addr-country.

"renaming suffix
TYPES: BEGIN OF sub_struc,
          col1 TYPE c LENGTH 10,
          col2 TYPE c LENGTH 10,
       END OF sub_struc.
DATA BEGIN OF struc.
INCLUDE TYPE: sub_struc AS comp1 RENAMING WITH SUFFIX _1,
              sub_struc AS comp2 RENAMING WITH SUFFIX _2,
              sub_struc AS comp3 RENAMING WITH SUFFIX _3,
              sub_struc AS comp4 RENAMING WITH SUFFIX _4,
              sub_struc AS comp5 RENAMING WITH SUFFIX _5.
DATA END OF struc.
"structure fields
"COL1_1  COL2_1  COL1_2  COL2_2  COL1_3  COL2_3  COL1_4  COL2_4  COL1_5  COL2_5  
"col1_1  col2_1  col1_2  col2_2  col1_3  col2_3  col1_4  col2_4  col1_5  col2_5  
------------------------------------------------
