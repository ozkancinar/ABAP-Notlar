SELECT-OPTIONS s_aufnr FOR afko-aufnr matchcode object ASH_ORDE. "Search help ile tanımla"
SELECT-OPTIONS S_DATE FOR afko-ftrms .

SELECT-OPTIONS so_yonet for vbpa-kunnr no INTERVALS NO-EXTENSION. "parametre gibi gösterir"

*Search option help

INITIALIZATION.
** Table declaration
  TABLES : pa0001.
** Type declaration
  TYPES : BEGIN OF ty_f4pernr,
            pernr TYPE persno,
            vorna TYPE pa0002-vorna,
            nach2 TYPE pa0002-nach2,
            nachn TYPE pa0002-nachn,
          END OF ty_f4pernr.
** Internal table declaration
  DATA : int_f4pernr TYPE STANDARD TABLE OF ty_f4pernr.
** Internal table memory clear
  REFRESH : int_f4pernr.

** Selection Screen Declaration
** Begin of block with frame name
  SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-001.
** Select option declaration of pernr field
  SELECT-OPTIONS s_pernr FOR pa0001-pernr.
** End of block
  SELECTION-SCREEN END OF BLOCK a1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_pernr-low.
** Calling the perform method when the low field of select option pernr's f4 is clicked
  PERFORM pernr_f4help.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_pernr-high.
** Calling the perform method when the high field of select option pernr's f4 is clicked
  PERFORM pernr_f4help.

*&---------------------------------------------------------------------*
*&      Form  PERNR_F4HELP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pernr_f4help .
** Retrieve pernr and corressponding first, last and middle name from pa0002 and pa0003 infotype using inner join
  SELECT a~pernr b~vorna b~nach2 b~nachn INTO TABLE int_f4pernr
    FROM pa0003 AS a INNER JOIN pa0002 AS b ON a~pernr EQ b~pernr.

** Calling F4 help function module to assign that retrieved value for that select option pernr
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'PERNR'
      dynpprog        = sy-repid    " Program name
      dynpnr          = sy-dynnr    " Screen number
      dynprofield     = 'S_PERNR'   " F4 help need field
      value_org       = 'S'
    TABLES
      value_tab       = int_f4pernr " F4 help values
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

ENDFORM.                    " PERNR_F4HELP

