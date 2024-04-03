FUNCTION ZBEN_IS_GUNU_HESAPLAMA.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(BASLANGICTARIHI) TYPE  DATUM OPTIONAL
*"     VALUE(BITISTARIHI) TYPE  DATUM OPTIONAL
*"  TABLES
*"      GT_OUT STRUCTURE  ZHR_RAFMET_ISGUN
*"----------------------------------------------------------------------


data: gt_itab type TABLE OF CASDAYATTR,
      gs_itab type CASDAYATTR,
      lv_found type SCAL-INDICATOR,
      gt_THOL  TYPE TABLE OF THOL,
      gs_thol  type thol.

 CALL FUNCTION 'DAY_ATTRIBUTES_GET'
 EXPORTING
   FACTORY_CALENDAR                 = 'TR'
   HOLIDAY_CALENDAR                 = 'TR'
   DATE_FROM                        = BASLANGICTARIHI
   DATE_TO                          = BITISTARIHI
   LANGUAGE                         = 'T'
   NON_ISO                          = ' '
* IMPORTING
*   YEAR_OF_VALID_FROM               =
*   YEAR_OF_VALID_TO                 =
*   RETURNCODE                       =
  TABLES
    DAY_ATTRIBUTES                   = gt_itab
 EXCEPTIONS
   FACTORY_CALENDAR_NOT_FOUND       = 1
   HOLIDAY_CALENDAR_NOT_FOUND       = 2
   DATE_HAS_INVALID_FORMAT          = 3
   DATE_INCONSISTENCY               = 4
   OTHERS                           = 5
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.



IF not gt_itab[] is INITIAL.

  LOOP AT gt_itab into gs_itab.

    gt_out-tarih = gs_itab-DATE.

    CASE gs_itab-FREEDAY.
      WHEN 'X'.   "tatil günleri
        IF gs_itab-holiday = 'X'. "resmi tatil kontrolü

          CALL FUNCTION 'HOLIDAY_CHECK_AND_GET_INFO'
            EXPORTING
              DATE                               = gs_itab-DATE
              HOLIDAY_CALENDAR_ID                = 'TR'
              WITH_HOLIDAY_ATTRIBUTES            = 'X'
            IMPORTING
              HOLIDAY_FOUND                      = lv_found
            TABLES
              HOLIDAY_ATTRIBUTES                 = gt_thol
            EXCEPTIONS
              CALENDAR_BUFFER_NOT_LOADABLE       = 1
              DATE_AFTER_RANGE                   = 2
              DATE_BEFORE_RANGE                  = 3
              DATE_INVALID                       = 4
              HOLIDAY_CALENDAR_ID_MISSING        = 5
              HOLIDAY_CALENDAR_NOT_FOUND         = 6
              OTHERS                             = 7
                    .
          IF SY-SUBRC <> 0.
* Implement suitable error handling here
          ENDIF.

          if not lv_found is INITIAL.

            LOOP AT gt_thol INTO gs_thol.
              IF gs_thol-KLASS = '2'.
                gt_out-aciklama = 'Yarım Gün Resmi Tatil'.
              else.
                gt_out-aciklama = 'Resmi Tatil'.
              ENDIF.
            ENDLOOP.

          endif.


        else.

          gt_out-aciklama = 'Hafta Sonu Tatili'.

        ENDIF.
      WHEN ' '.

          gt_out-aciklama = 'İş Günü' .

    ENDCASE.

    append gt_out.
    clear gt_out.

  ENDLOOP.

ENDIF.






ENDFUNCTION.
