CONVERT TIME STAMP dstmp TIME ZONE sy-zonlo
           INTO DATE ddate TIME sy-uzeit.

"Porgram içerisindeki çalışma süresini almak"
DATA: lv_sta_time TYPE timestampl,
      lv_end_time TYPE timestampl,
      lv_diff_w   TYPE p DECIMALS 5.

  GET TIME STAMP FIELD lv_sta_time.
  GET TIME STAMP FIELD lv_end_time.
  lv_diff_w = lv_end_time - lv_sta_time.