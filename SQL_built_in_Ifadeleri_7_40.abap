SELECT SINGLE
           FROM demo_expressions
           FIELDS CAST( num1     AS CHAR( 20 ) ) AS col1,
                  CAST( numlong1 AS CHAR( 20 ) ) AS col2,
                  CAST( dec3     AS CHAR( 20 ) ) AS col3,
                  CAST( dats2    AS CHAR( 20 ) ) AS col4
           WHERE id = 'X'
           INTO @DATA(result).

SELECT
      FROM demo_expressions
      FIELDS
        AVG(          num1                ) AS avg_no_type,
        AVG( DISTINCT num1                ) AS avg_no_type_distinct,
        AVG(          num1 AS DEC( 10,0 ) ) AS avg_dec0,
        AVG( DISTINCT num1 AS DEC( 10,0 ) ) AS avg_dec0_distinct,
        AVG(          num1 AS DEC( 14,4 ) ) AS avg_dec4,
        AVG( DISTINCT num1 AS DEC( 14,4 ) ) AS avg_dec4_distinct
      INTO @DATA(result).

SELECT SINGLE dats1, dats2,
                  dats_is_valid( dats1 ) AS valid,
                  dats_days_between( dats1, dats2 ) AS days_between,
                  dats_add_days( dats1,100 ) AS add_days,
                  dats_add_months( dats1,-1 ) AS add_month
           FROM demo_expressions
           INTO @DATA(result).

SELECT id, char1, char2,
           CASE char1
             WHEN 'aaaaa' THEN ( char1 && char2 )
             WHEN 'xxxxx' THEN ( char2 && char1 )
             ELSE @else
           END AS text
           FROM demo_expressions
           INTO TABLE @DATA(results).

  SELECT SINGLE
           FROM demo_expressions
           FIELDS CAST( num1     AS CHAR( 20 ) ) AS col1,
                  CAST( numlong1 AS CHAR( 20 ) ) AS col2,
                  CAST( dec3     AS CHAR( 20 ) ) AS col3,
                  CAST( dats2    AS CHAR( 20 ) ) AS col4
           WHERE id = 'X'
           INTO @DATA(result).

SELECT t1~a AS a1, t1~b AS b1, t1~c AS c1, t1~d AS d1,
           COALESCE( t2~d, '--' ) AS d2,
           COALESCE( t2~e, '--' ) AS e2,
           COALESCE( t2~f, '--' ) AS f2,
           COALESCE( t2~g, '--' ) AS g2,
           COALESCE( t2~h, '--' ) AS h2
       FROM demo_join1 AS t1
         LEFT OUTER JOIN demo_join2 AS t2 ON t2~d = t1~d
       ORDER BY t1~d
       INTO CORRESPONDING FIELDS OF TABLE @itab.

    SELECT char1 && '_' && char2 AS group,
           MAX( num1 + num2 ) AS max,
           MIN( num1 + num2 ) AS min,
           MIN( num1 * num2 ) AS min_product
           FROM demo_expressions
           GROUP BY char1, char2
           ORDER BY group
           INTO TABLE @DATA(grouped).
    out->write( grouped ).

    SELECT char1 && '_' && char2 AS group,
           MAX( num1 + num2 ) AS max,
           MIN( num1 + num2 ) AS min
           FROM demo_expressions
           GROUP BY char1, char2
           HAVING MIN( num1 * num2 ) > 25
           ORDER BY group
           INTO TABLE @DATA(grouped_having).


    SELECT SINGLE @abap_true
           FROM scarr
           WHERE carrid = @carrier
           INTO @DATA(exists).
      IF exists = abap_true.
        cl_demo_output=>display(
          |Carrier { carrier } exists in SCARR| ).
      ELSE.
        cl_demo_output=>display(
          |Carrier { carrier } does not exist in SCARR| ).
      ENDIF.

   SELECT num1, num2,
           CASE WHEN num1 <  50 AND num2 <  50 THEN @both_l
                WHEN num1 >= 50 AND num2 >= 50 THEN @both_gt
                ELSE @others
           END AS group
           FROM demo_expressions
           ORDER BY group
           INTO TABLE @DATA(results).

  out->begin_section( `GROUP BY num1, num2` ).
    SELECT num1 + num2 AS sum, COUNT( * ) AS count
           FROM demo_expressions
           GROUP BY num1, num2
           ORDER BY sum
           INTO TABLE @DATA(result1).
    out->write( result1 ).

    out->next_section( `GROUP BY num1 + num2` ).
    SELECT num1 + num2 AS sum, COUNT( * ) AS count
           FROM demo_expressions
           GROUP BY num1 + num2
           ORDER BY sum
           INTO TABLE @DATA(result2).
    out->write( result2 ).


    SELECT CONCAT_WITH_SPACE( CONCAT( carrid,
                              LPAD( carrname,21,' ' ) ),
                              RPAD( url,40,' ' ), 3 ) AS line
           FROM scarr
           INTO TABLE @DATA(result).

    SELECT SINGLE
           char1 AS text1,
           char2 AS text2,
           CONCAT(            char1,char2 )     AS concat,
           CONCAT_WITH_SPACE( char1,char2, 1 )  AS concat_with_space,
           INSTR(             char1,'12' )      AS instr,
           LEFT(              char1,3 )         AS left,
           LENGTH(            char1 )           AS length,
           LOWER(             char2 )           AS lower,
           LPAD(              char1,10,'x' )    AS lpad,
           LTRIM(             char1,' ' )       AS ltrim,
           REPLACE(           char1,'12','__' ) AS replace,
           RIGHT(             char1,3 )         as right,
           RPAD(              char1,10,'x' )    AS rpad,
           RTRIM(             char1,'3' )       AS rtrim,
           SUBSTRING(         char1,3,3 )       AS substring,
           UPPER(             char2 )           AS upper
           FROM demo_expressions
           INTO @DATA(result).

    "UPPER in CDS view
    SELECT arbgb, msgnr, text
           FROM demo_cds_upper
           WHERE sprsl = 'E' AND
                 upper_text LIKE @query
           ORDER BY arbgb, msgnr, text
           INTO TABLE @DATA(result1)
           UP TO @rows ROWS.

    "UPPER in Open SQL
    SELECT arbgb, msgnr, text
           FROM t100
           WHERE sprsl = 'E' AND
                 upper( text ) LIKE @query
           ORDER BY arbgb, msgnr, text
           INTO TABLE @DATA(result2)
           UP TO @rows ROWS.
