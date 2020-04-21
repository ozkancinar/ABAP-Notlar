TABLES : scarr .
DATA : it_scarr TYPE TABLE OF scarr .

DATA : ob_custom TYPE REF TO cl_gui_custom_container ,
       ob_split1 TYPE REF TO cl_gui_easy_splitter_container ,
       ob_split2 TYPE REF TO cl_gui_easy_splitter_container ,
       ob_grid1  TYPE REF TO cl_gui_alv_grid ,
       ob_grid2  TYPE REF TO cl_gui_alv_grid ,
       ob_grid3  TYPE REF TO cl_gui_alv_grid .

SELECT-OPTIONS : s_carrid FOR scarr-carrid .

START-OF-SELECTION .

  SELECT *
    INTO TABLE it_scarr
    FROM scarr
   WHERE carrid IN s_carrid .

  CALL SCREEN 100 .

*&---------------------------------------------------------------------*
*& Module status_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET TITLEBAR 'ZTITLE01' .
  SET PF-STATUS 'ZPF01' .

* This will create a container
  CREATE OBJECT ob_custom
    EXPORTING
      container_name = 'CONTAINER'.

* This spit the container OB_CUSTOM into two
  CREATE OBJECT ob_split1
    EXPORTING
      parent      = ob_custom
      orientation = cl_gui_easy_splitter_container=>orientation_vertical.

* Now we have two container
* OB_SPLIT1->TOP_LEFT_CONTAINER
* OB_SPLIT1->BOTTOM_RIGHT_CONTAINER
* Since these two are itself a container we can further devide them into two.
* Let try to divide OB_SPLIT1->BOTTOM_RIGHT_CONTAINER into two

  CREATE OBJECT ob_split2
    EXPORTING
      parent      = ob_split1->bottom_right_container
      orientation = cl_gui_easy_splitter_container=>orientation_horizontal.

* Now we have total 3 container available with us
* OB_SPLIT1->TOP_LEFT_CONTAINER
* OB_SPLIT2->TOP_LEFT_CONTAINER
* OB_SPLIT2->BOTTOM_RIGHT_CONTAINER
* Note that OB_SPLIT1->BOTTOM_RIGHT_CONTAINER is not available because we divided
* that into two.
* Now Put a grid in each container

  CREATE OBJECT ob_grid1
    EXPORTING
      i_parent = ob_split1->top_left_container.

  CREATE OBJECT ob_grid2
    EXPORTING
      i_parent = ob_split2->top_left_container.

  CREATE OBJECT ob_grid3
    EXPORTING
      i_parent = ob_split2->bottom_right_container.

  CALL METHOD ob_grid1->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SCARR'
    CHANGING
      it_outtab        = it_scarr.

  CALL METHOD ob_grid2->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SCARR'
    CHANGING
      it_outtab        = it_scarr.

  CALL METHOD ob_grid3->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SCARR'
    CHANGING
      it_outtab        = it_scarr.

ENDMODULE. " status_0100 OUTPUT

*&---------------------------------------------------------------------*
*& Module user_command_0100 INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  IF sy-ucomm = 'BACK' OR sy-ucomm = 'EXIT' .
    FREE : ob_grid1 ,
           ob_grid2 ,
           ob_grid3 ,
           ob_split1 ,
           ob_split2 ,
           ob_custom .

    LEAVE TO SCREEN 0 .
  ENDIF.

ENDMODULE. " user_command_0100 INPUT