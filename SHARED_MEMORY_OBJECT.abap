* bir tane root sınıf yaratılır. İçerisine getter setter koyulur
* SHMA işlem koduyla bu sınıf shared memory olarak tanımlanır. Bir tane sınıf generate eder
* bu generate edilen sınıf ile kayıt atma ve okuma işlemleri yapılır
* Tcode: SHMM - shared memory kayıtlı nesneler alanlar
REPORT ZOZ_SHARED_MEMORY.

* WRITE:
data my_handle TYPE REF TO ZOZ_MY_SHARED.
data my_root TYPE REF TO ZOZ_CL_SHARED_ROOT.

TRY .
  ZOZ_MY_SHARED=>attach_for_write(
    EXPORTING
*      client                        = client
      inst_name                     = 'INST_NAME1'    " Name of a Shared Object Instance of an Area
*      attach_mode                   = attach_mode    " Mode of ATTACH (Constants in CL_SHM_AREA)
*      wait_time                     = wait_time    " Maximum Wait Time (in Milliseconds)
    RECEIVING
      handle                        = my_handle    " SHM: Model of an Area Class
  ).

  create OBJECT my_root AREA HANDLE my_handle.

  my_handle->set_root( root = my_root ).

  my_root->set_data(
    EXPORTING
      i_number = '112345'    " Personel numarası
      i_name   = 'Özkan3'   "Çalışanın/başvuranın biçimlendirilmiş adı
  ).

  my_handle->detach_commit( ).

  Write: 'success' COLOR COL_POSITIVE.
CATCH cx_root.
  WRITE: 'Error' COLOR COL_NEGATIVE.
ENDTRY.
*---------------------------------------------
* READ:
data number TYPE persno.
data name TYPE emnam.

TRY .
  ZOZ_MY_SHARED=>attach_for_read(
    EXPORTING
*      client                       = client
      inst_name                    = 'INST_NAME1'    " Name of a Shared Object Instance of an Area
    RECEIVING
      handle                       = my_handle    " SHM: Model of an Area Class
  ).

  my_handle->root->get_data(
    IMPORTING
      e_number = number    " Personel numarası
      e_name   = name    " Çalışanın/başvuranın biçimlendirilmiş adı
  ).

  my_handle->detach( ).

  WRITE: 'name: ', name, 'number: ', number.
CATCH cx_root.
  WRITE: 'Error' COLOR COL_NEGATIVE.
ENDTRY.
