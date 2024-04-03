*&---------------------------------------------------------------------*
*&  Include           ZBEN_UPLOAD_FILE_TOP
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK in1 WITH FRAME TITLE TEXT-t01.

PARAMETERS: p_bnft TYPE zben_s_alv_upload-benefit_id
                   LOWER CASE MODIF ID chr.
PARAMETER p_file TYPE rlgrap-filename DEFAULT 'C:\TEST.jpg'.
SELECTION-SCREEN END OF BLOCK in1.

SELECTION-SCREEN BEGIN OF BLOCK in2 WITH FRAME TITLE TEXT-t02.

PARAMETERS: r_jpg RADIOBUTTON GROUP rbg1 DEFAULT 'X' USER-COMMAND radio1,
            r_pdf RADIOBUTTON GROUP rbg1.
SELECTION-SCREEN END OF BLOCK in2.

*SELECTION-SCREEN BEGIN OF BLOCK in3 WITH FRAME TITLE TEXT-t02.
*
*PARAMETERS: r_uplo RADIOBUTTON GROUP rbg2 DEFAULT 'X' USER-COMMAND radio2,
*            r_down RADIOBUTTON GROUP rbg2.
*SELECTION-SCREEN END OF BLOCK in3.
*
DATA: gv_rc TYPE i.
