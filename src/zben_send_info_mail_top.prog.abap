*&---------------------------------------------------------------------*
*&  Include           ZBEN_SEND_INFO_MAIL_TOP
*&---------------------------------------------------------------------*

DATA: gv_begin_date LIKE zben_period-begin_date.

 DATA: gt_alicibilgileri  TYPE STANDARD TABLE OF somlreci1,
       gs_alicibilgileri  TYPE somlreci1,
       gt_mailicerik      TYPE STANDARD TABLE OF solisti1,
       gs_mailicerik      TYPE solisti1,
       gt_icerikbilgiler  TYPE STANDARD TABLE OF sopcklsti1
       WITH HEADER LINE,
       gs_icerikbilgiler  TYPE  sopcklsti1,
       gs_mailozellikleri TYPE  sodocchgi1,
       gv_gonderen        TYPE soextreci1-receiver
        VALUE 'anillcetin2000@gmail.com'.
