*&---------------------------------------------------------------------*
*&  Include           ZBEN_CARSI_KALAN_BAK_PAI
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA: lv_subrc LIKE sy-subrc,
        e_ucomm  LIKE sy-ucomm.
  CLEAR gv_okcode.
  gv_okcode = sy-ucomm.

  CASE gv_okcode.
    WHEN 'BACK'.
      PERFORM free.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL' OR 'EXIT'.
      PERFORM free.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.

"*screen 0100 container: CON
