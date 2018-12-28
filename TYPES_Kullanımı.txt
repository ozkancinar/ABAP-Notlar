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


------------------------------------------------
