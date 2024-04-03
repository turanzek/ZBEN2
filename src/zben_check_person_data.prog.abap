*&---------------------------------------------------------------------*
*& Report ZBEN_SEND_INFO_MAIL
*&---------------------------------------------------------------------*
* Project           : TT Çarşı Project
*----------------------------------------------------------------------*
* Program           : ZBEN_CHECK_PERSON_DATA
* ABAP Consultant   : Anıl Çetin
* ———————————————————————–———–———–———–
* Title             : TT Send Info Mail
* Description       : TT Send Info Mail
*&---------------------------------------------------------------------*
REPORT ZBEN_CHECK_PERSON_DATA.

INCLUDE ZBEN_CHECK_PERSON_DATA_TOP.
*INCLUDE ZBEN_SEND_INFO_MAIL_TOP.
*INCLUDE ZBEN_SEND_INFO_MAIL_CLS.
INCLUDE ZBEN_CHECK_PERSON_DATA_F01.
*INCLUDE ZBEN_SEND_INFO_MAIL_F01.

*----------------------------------------------------------------------*
*INITIALIZATION.
*----------------------------------------------------------------------*
INITIALIZATION.
  perform get_data.


*önce period tablosu kontrol edilecek
*sy-datum period tablosundaki tarihten(END_DATE) 1 gün sonra ise sistemdeki tüm personelleri bulucaz ()---->bir aşağıdaki satırı dikkate al
*lv_date = sy-datum - 1. de. where koşuluna end_date buna eşit olanları ve active = 'X' olanı çek
*veri gelmesi önemli değil select count ile yap yani olup olmaması önemli
*check sy-subrc eq 0 ise işleme devam edecek
*ZBEN_DEFIN_PERS tablosuna git tüm verileri çek
*bu tablo ile ZBEN_TRAN_PERS tablosuna for all entries ile git personel ve yıl ile
*sonra ZBEN_DEFIN_PERS dataları için loopta dön
*içerde read table ile zben_tran_pers tablosuna bak with key perner ve zyear ile kayıt var mı yok mu diye bakacağız eğer kayıt yoksa
*burada basit bir işlem yapacağız
