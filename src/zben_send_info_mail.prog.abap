*&---------------------------------------------------------------------*
*& Report ZBEN_SEND_INFO_MAIL
*&---------------------------------------------------------------------*
* Project           : TT Çarşı Project
*----------------------------------------------------------------------*
* Program           : ZBEN_SEND_INFO_MAIL
* ABAP Consultant   : Anıl Çetin
* ———————————————————————–———–———–———–
* Title             : TT Send Info Mail
* Description       : TT Send Info Mail
*&---------------------------------------------------------------------*
REPORT ZBEN_SEND_INFO_MAIL.

INCLUDE ZBEN_SEND_INFO_MAIL_TOP.
*INCLUDE ZBEN_SEND_INFO_MAIL_CLS.
INCLUDE ZBEN_SEND_INFO_MAIL_F01.

*----------------------------------------------------------------------*
*INITIALIZATION.
*----------------------------------------------------------------------*
INITIALIZATION.
  perform get_data.
