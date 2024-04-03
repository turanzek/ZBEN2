*&---------------------------------------------------------------------*
*&  Include           ZBEN_RESET_PERSONS_CLS
*&---------------------------------------------------------------------*
CLASS lcl_alv DEFINITION .
  PUBLIC SECTION.
    METHODS:

      handle_data_changed FOR EVENT data_changed   OF cl_gui_alv_grid
                          IMPORTING er_data_changed
                                    e_onf4
                                    e_onf4_before
                                    e_onf4_after
                                    e_ucomm
                                    sender,

      handle_user_command FOR EVENT user_command   OF cl_gui_alv_grid
                          IMPORTING e_ucomm
                                    sender,

      handle_toolbar      FOR EVENT toolbar        OF cl_gui_alv_grid
                          IMPORTING e_object
                                    sender,

      handle_data_changed_finished FOR EVENT data_changed_finished OF cl_gui_alv_grid
                                   IMPORTING e_modified
                                             et_good_cells
                                             sender.


      METHODS : GET_DATA,
                LIST_DATA.
ENDCLASS.                    " lcl_alv
*&---------------------------------------------------------------------*

CLASS lcl_alv IMPLEMENTATION.

  METHOD handle_data_changed.
    PERFORM handle_data_changed
      USING er_data_changed
                  e_onf4
                  e_onf4_before
                  e_onf4_after
                  e_ucomm
                  sender.

    "er_data_changed içinde değişen satırın value degerını ve
    "row indexini tutuyor
  ENDMETHOD.                    "handle_data_changed

  METHOD handle_user_command.
    PERFORM handle_user_command
      USING e_ucomm
            sender.
  ENDMETHOD.                    "handle_user_command

  METHOD handle_toolbar.
    PERFORM handle_toolbar
      USING e_object
            sender.
  ENDMETHOD.                    "handle_toolbar

                  "handle_hotspot_click
  METHOD handle_data_changed_finished.
    PERFORM handle_data_changed_finished
      USING e_modified
            et_good_cells
            sender.

  ENDMETHOD.                    "handle_data_changed_finished
                "handle_menu_button
  METHOD get_data.
    PERFORM get_data.
  ENDMETHOD.
  method list_data .
    PERFORM list_data.
  ENDMETHOD.

ENDCLASS.                    " LCL_ALV
