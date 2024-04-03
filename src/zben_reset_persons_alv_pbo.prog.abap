*&---------------------------------------------------------------------*
*&  Include           ZBEN_RESET_PERSONS_PBO
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR '0100'.
  PERFORM prepare_alv.
ENDMODULE.
