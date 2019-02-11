TABLES: likp, lips.

DATA: t_likp  TYPE TABLE OF likp,
      t_lips  TYPE TABLE OF lips.

DATA: w_runtime1 TYPE i,
      w_runtime2 TYPE i,
      w_index LIKE sy-index.

START-OF-SELECTION.
  SELECT *
    FROM likp
    INTO TABLE t_likp.

  SELECT *
    FROM lips
    INTO TABLE t_lips.

  GET RUN TIME FIELD w_runtime1.
  SORT t_likp BY vbeln.
  SORT t_lips BY vbeln.

  LOOP AT t_likp INTO likp.
    LOOP AT t_lips INTO lips FROM w_index.
      IF likp-vbeln NE lips-vbeln.
        w_index = sy-tabix. "cursoru güncelle
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  GET RUN TIME FIELD w_runtime2.

  w_runtime2 = w_runtime2 - w_runtime1.

  WRITE w_runtime2. 
