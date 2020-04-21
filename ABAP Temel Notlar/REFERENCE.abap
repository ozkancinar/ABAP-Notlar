"set reference"
GET REFERENCE OF dobj INTO dref.

READ TABLE t_alv_data1 REFERENCE INTO data(alv_line) INDEX row.
printed_vda_labels->* = alv_line->t_printed_vda.
