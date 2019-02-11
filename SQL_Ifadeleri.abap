*------------ UPDATE ----------*
UPDATE zmsaa_t_mold_tme SET  bit_ktrhsaat = lv_datetime_now
                                    bit_trhsaat = lv_bittarsaat

                                    iptal_katalogart = i_iptal_katalogart
                                    iptal_codegruppe = i_iptal_codegruppe
                                    iptal_code       = i_iptal_code
                                 WHERE  werks            = ll_zmsaa_t_mach_mld-werks
                                   AND  arbpl            = ll_zmsaa_t_mach_mld-arbpl
                                   AND  statu            = c_kalip_baglama
                                   AND  kalip            = ll_zmsaa_t_mach_mld-kalip
                                   AND  hcdatetime = ll_zmsaa_t_mach_mld-cdatetime
                                   AND bit_trhsaat EQ c_datetime_initial.
          COMMIT WORK AND WAIT.

UPDATE zmsaa_t_maint_01 FROM wa_rec.

