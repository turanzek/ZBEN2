*&---------------------------------------------------------------------*
*&  Include           ZBEN_CARSI_KALAN_BAK_F01
*&---------------------------------------------------------------------*

*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data .

  DATA: lv_baslangic TYPE sy-datum.
  DATA: lv_bitis TYPE sy-datum.
  DATA: lv_son TYPE sy-datum.
  DATA: lt_is_gunleri TYPE TABLE OF zhr_rafmet_isgun.

  DATA: lv_index1 TYPE i.
  DATA: lv_index2 TYPE i.
  DATA: lv_char(5).

  DATA: BEGIN OF ls_itab,
          pernr           TYPE pa0001-pernr,
          ename           TYPE pa0001-ename,
          flexible_budget TYPE zben_defin_pers-flexible_budget,
          fixed_budget    TYPE zben_defin_pers-fixed_budget,
        END OF ls_itab,
        lt_itab LIKE TABLE OF ls_itab.

  CONCATENATE p_year '%' INTO lv_char.

  SELECT * FROM zben_defin_pers AS a
    INNER JOIN pa0000 AS b ON b~pernr = a~pernr
      INTO CORRESPONDING FIELDS OF TABLE lt_itab
        WHERE a~pernr IN s_pernr AND
              a~zyear EQ p_year
         AND b~massn = '10'
         AND b~endda = '99991231'
         AND b~begda LIKE lv_char..

  IF lt_itab IS NOT INITIAL..
    SELECT pernr,
           ename
      FROM pa0001 INTO TABLE @DATA(lt_pa0001)
      FOR ALL ENTRIES IN @lt_itab
      WHERE pernr = @lt_itab-pernr
        AND endda LIKE @lv_char.

    SELECT pernr,
       begda,
       endda,
       massn
  FROM pa0000 INTO TABLE @DATA(lt_pa0000)
  FOR ALL ENTRIES IN @lt_itab WHERE pernr = @lt_itab-pernr
                                    AND massn = '10'
                                    AND endda = '99991231'
                                    AND begda LIKE @lv_char.

  ENDIF.

  SELECT * FROM zben_t_params
        INTO TABLE @DATA(lt_params).


  SELECT SINGLE begin_date,
              end_date
      FROM zben_period
        WHERE begin_date LT @sy-datum
            AND end_date GT @sy-datum
            AND active EQ 'X'
          INTO @DATA(ls_dates).



*&---------------------------------------------------------------------*


  FIELD-SYMBOLS: <fs_data> TYPE any.

  LOOP AT lt_params ASSIGNING FIELD-SYMBOL(<fs_str>).
    IF <fs_str> IS ASSIGNED.
      ASSIGN COMPONENT 'PARAMID' OF STRUCTURE <fs_str> TO <fs_data>.
      IF <fs_data> IS ASSIGNED.
        CASE <fs_data>.
          WHEN 'YST'. "Yıllık SSK Tavan Matrahı
            gs_value-yst = <fs_str>-paramvalue.
          WHEN 'YGS'. "Yıllık İş Günü Sayısı
            gs_value-ygs = <fs_str>-paramvalue.
          WHEN 'YAU'. "Yıllık Asgari Ücret
            gs_value-yau = <fs_str>-paramvalue.
          WHEN 'TEMPKES'. "tempkesinti
            gs_value-tempkes = <fs_str>-paramvalue.
          WHEN 'SSKS'. "SSK Sakat kesinti ORANI
            gs_value-ssks = <fs_str>-paramvalue.
          WHEN 'SSKO'. "SSK prim oranı-Diğer
            gs_value-ssko = <fs_str>-paramvalue.
          WHEN 'SSKN'. "SSK prim oranı-Normal
            gs_value-sskn = <fs_str>-paramvalue.
          WHEN 'SSKE'. "SSK prim oranı-Emekli
            gs_value-sske = <fs_str>-paramvalue.
          WHEN 'SSKA'. "SSK Argeli kesinti ORANI
            gs_value-sska = <fs_str>-paramvalue.
          WHEN 'SSK'. "SGK kesintisi"
            gs_value-ssk = <fs_str>-paramvalue.
          WHEN 'REC'. "işe alım suresi
            gs_value-rec = <fs_str>-paramvalue.
          WHEN 'MUL'. "Mevcut yan hak seçiminde yemek kartına yükleme
            gs_value-mul = <fs_str>-paramvalue.
          WHEN 'GYM'. "Günlük Gelir Vergisi Yemek Muafiyet tutarı
            gs_value-gym = <fs_str>-paramvalue.
          WHEN 'EKEBB'."Eksi KEBB Bakiye Limiti
            gs_value-ekebb = <fs_str>-paramvalue.
          WHEN 'DVO'. "Damga Vergisi Kesinti Oranı
            gs_value-dvo = <fs_str>-paramvalue.

          WHEN OTHERS.
        ENDCASE.
        UNASSIGN <fs_data>.
      ENDIF.
    ENDIF.
  ENDLOOP.


  CONCATENATE p_year '0101' INTO lv_baslangic.
  CONCATENATE p_year '3112' INTO lv_son.

  LOOP AT lt_itab INTO ls_itab.
    CLEAR gs_pers.

    READ TABLE lt_pa0001 INTO DATA(ls_pa0001) WITH KEY pernr = ls_itab-pernr.
    IF sy-subrc EQ 0.
      gs_pers-ename = ls_pa0001-ename.
    ELSE.
      SELECT SINGLE ename FROM pa0001
        WHERE pernr EQ @ls_itab-pernr
        INTO @gs_pers-ename.
    ENDIF.

    SELECT SINGLE flexible_budget FROM zben_tran_pers
          WHERE pernr EQ @ls_itab-pernr
            AND zyear EQ @p_year
          INTO @DATA(ls_tran_pers).


    gs_pers-pernr = ls_itab-pernr.
*    gs_pers-ename = ls_itab-ename.
    gs_pers-carsi_gun_sayisi = gs_value-ygs.
    IF ls_tran_pers IS NOT INITIAL.
      gs_pers-carsi_yemek_ucret = ls_tran_pers / gs_pers-carsi_gun_sayisi.
    ELSE.
      gs_pers-carsi_yemek_ucret = ls_itab-flexible_budget / gs_pers-carsi_gun_sayisi.  "eğer işlem yapıldıysa zben_trans_perstekini alıcaz
    ENDIF.
    gs_pers-gunluk_yemek_tutar = ls_itab-flexible_budget / gs_pers-carsi_gun_sayisi. "her zaman böyle
    gs_pers-carsi_ek_butce = ls_itab-fixed_budget.
    gs_pers-carsi_bas_tarih = ls_dates-begin_date.
*


    READ TABLE lt_pa0000 INTO DATA(ls_pa0000) WITH KEY pernr = ls_itab-pernr.
    IF sy-subrc EQ 0.
      lv_bitis = ls_pa0000-begda.
      gs_pers-isten_ayrilma_tarih = ls_pa0000-begda.
*      gs_pers-isten_ayrilma_tarih = '20230630'.
    ELSE.
*        lv_bitis = sy-datum.
      lv_bitis = lv_son.
    ENDIF.
    CLEAR: lt_is_gunleri.
    CALL FUNCTION 'ZBEN_IS_GUNU_HESAPLAMA'
      EXPORTING
        baslangictarihi = lv_baslangic
        bitistarihi     = lv_bitis
      TABLES
        gt_out          = lt_is_gunleri.

    CLEAR: lv_index1, lv_index2.
    LOOP AT lt_is_gunleri INTO DATA(ls_is_gunleri).
      IF ls_is_gunleri-aciklama = 'İş Günü'.
        lv_index1 = lv_index1 + 1.
      ELSEIF ls_is_gunleri-aciklama = 'Yarım Gün Resmi Tatil'.
        lv_index2 = lv_index2 + 1.
      ENDIF.
    ENDLOOP.



    gs_pers-carsi_calisilan_gun = lv_index1 + lv_index2.
    gs_pers-hakedis_tutari = ( gs_pers-gunluk_yemek_tutar - gs_pers-carsi_yemek_ucret ) * gs_pers-carsi_calisilan_gun.
*    gs_pers-kesint_yukleme = ( gs_pers-carsi_gun_sayisi - gs_pers-carsi_calisilan_gun ) * gs_pers-gunluk_yemek_tutar.
    gs_pers-kesint_yukleme = ( ( gs_pers-gunluk_yemek_tutar - gs_pers-carsi_yemek_ucret ) * gs_pers-carsi_gun_sayisi ) - gs_pers-hakedis_tutari.
    gs_pers-icon = '2'.

*    ENDIF.

    APPEND gs_pers TO gt_pers.
  ENDLOOP.



ENDFORM.                    " GET_DATA


*&---------------------------------------------------------------------*
*&      Form  LIST_DATA
*&---------------------------------------------------------------------*
FORM list_data .
  CALL SCREEN 0100.
ENDFORM.                    " LIST_DATA
" INIT
*&---------------------------------------------------------------------*
*&      Form  PREPARE_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prepare_alv .
  DATA:  lv_fcat TYPE  slis_tabname .
  UNASSIGN <fs_data>.

  lv_fcat = 'GS_PERS'.
  ASSIGN ('GT_PERS[]') TO <fs_data>.


  IF gcl_con IS INITIAL.
    PERFORM create_container.
    PERFORM create_fcat USING lv_fcat.
    PERFORM set_fcat .
    PERFORM set_layout.
*    PERFORM set_dropdown.
    PERFORM display_alv.
    PERFORM set_handler_events.
  ELSE.
    PERFORM refresh_alv.
  ENDIF.
ENDFORM.                    " PREPARE_ALV
*&---------------------------------------------------------------------*
*&      Form  CREATE_CONTAINER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_container.

  CREATE OBJECT gcl_con
    EXPORTING
      container_name              = 'CON'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CREATE OBJECT gcl_grid
    EXPORTING
      i_parent          = gcl_con
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  "bu method edite acık gelmesı ıcın gereklı
  CALL METHOD gcl_grid->set_ready_for_input
    EXPORTING
      i_ready_for_input = 1.

ENDFORM.                    " CREATE_CONTAINER
*&---------------------------------------------------------------------*
*&      Form  CREATE_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_fcat USING p_fcat TYPE  slis_tabname .
  CLEAR: gt_fcat,gt_fcat[],it_fieldcat[].
  REFRESH: gt_fcat[].  FREE: gt_fcat[].


  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = p_fcat
      i_inclname             = 'ZBEN_CARSI_KALAN_BAK_TOP'
    CHANGING
      ct_fieldcat            = it_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  CALL FUNCTION 'LVC_TRANSFER_FROM_SLIS'
    EXPORTING
      it_fieldcat_alv = it_fieldcat
    IMPORTING
      et_fieldcat_lvc = gt_fcat
    TABLES
      it_data         = gt_pers[]
    EXCEPTIONS
      it_data_missing = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.




ENDFORM.                    " CREATE_FCAT
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_alv .
  gs_vari-report = sy-repid.
  gs_vari-variant = ''.
*  gs_layo-cwidth_opt = 'X'.
  gs_layo-zebra = 'X'.
  gs_layo-excp_fname = 'ICON'.
*  gs_layo-stylefname = 'STYLE'.

  CALL METHOD gcl_grid->set_table_for_first_display
    EXPORTING
      is_variant                    = gs_vari
      i_save                        = 'A'
      is_layout                     = gs_layo
    CHANGING
      it_outtab                     = <fs_data>
      it_fieldcatalog               = gt_fcat
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  gcl_grid->set_ready_for_input(
         i_ready_for_input = 1
     ).
ENDFORM.                    " DISPLAY_ALV
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_fcat.
  FIELD-SYMBOLS : <fcat> TYPE lvc_s_fcat.
*  IF gv_okcode EQ 'SIMULATE' OR gv_okcode EQ 'SAVE'.

*  LOOP AT gt_fcat ASSIGNING <fcat>.
*
*      CASE <fcat>-fieldname.
*        WHEN 'ERNAM'.
***        <fcat>-scrtext_l =
*          <fcat>-edit = 'X'.
*        WHEN OTHERS.
*      ENDCASE.
*
*  ENDLOOP.

ENDFORM.                    " BUILD_FCAT
*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*&---------------------------------------------------------------------*
FORM set_layout.
  gs_layo-stylefname = 'STYLE'.
  gs_layo-cwidth_opt = 'X'.

  gs_layo-no_rowins = 'X'.
  gs_layo-no_rowmove = 'X'.


ENDFORM.                    " SET_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  SET_EVENTS
*&---------------------------------------------------------------------*
FORM set_handler_events .
  CREATE OBJECT gcl_evt_rec.
  SET HANDLER gcl_evt_rec->handle_data_changed
          FOR gcl_grid.
  SET HANDLER gcl_evt_rec->handle_user_command
          FOR gcl_grid.
  SET HANDLER gcl_evt_rec->handle_toolbar
          FOR gcl_grid.
  SET HANDLER gcl_evt_rec->handle_data_changed_finished
          FOR gcl_grid.
  CALL METHOD gcl_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter.
  CALL METHOD gcl_grid->set_toolbar_interactive.
ENDFORM.                    " SET_EVENTS
*&---------------------------------------------------------------------*
*&      Form  REFRESH_ALV
*&---------------------------------------------------------------------*
FORM refresh_alv .
  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stbl
      i_soft_refresh = gs_soft_ref
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.                    " REFRESH_ALV
*&---------------------------------------------------------------------*
*&      Form  FREE
*&---------------------------------------------------------------------*
FORM free .
  IF gcl_grid IS NOT INITIAL.
    CALL METHOD gcl_grid->free
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.
      FREE gcl_grid.
    ENDIF.
  ENDIF.
  IF gcl_con IS NOT INITIAL.
    CALL METHOD gcl_con->free
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.
      FREE gcl_con.
    ENDIF.
  ENDIF.
ENDFORM.                    " FREE

*&---------------------------------------------------------------------*
*&      Form  HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM handle_user_command USING e_ucomm TYPE sy-ucomm
                               e_sender TYPE REF TO cl_gui_alv_grid.
  DATA: lv_ucomm LIKE sy-ucomm,
        lv_subrc LIKE sy-subrc.
  DATA: lt_row_no TYPE lvc_t_roid,
        ls_row_no TYPE lvc_s_roid.
  DATA: lv_index TYPE i.
  CALL METHOD gcl_grid->get_selected_rows
    IMPORTING
      et_row_no = lt_row_no.
  CLEAR: gt_row_no[].
  gt_row_no = lt_row_no.


  IF lines( lt_row_no ) < 1.
    MESSAGE s008(zben) DISPLAY LIKE 'E'.
    RETURN.
*  ELSEIF lines( lt_row_no ) > 1.
*    MESSAGE s009(zben) DISPLAY LIKE 'E'..
*    RETURN.
  ENDIF.
  DATA: lv_flag.
  "bu alv nın ustundekı ekledıgımız butonların dustugu method
  CASE e_ucomm.

    WHEN 'ISLE'.

      LOOP AT lt_row_no INTO ls_row_no.
        READ TABLE gt_pers ASSIGNING FIELD-SYMBOL(<fs_tmp>) INDEX ls_row_no-row_id.


        IF sy-subrc EQ 0.

*          IF sy-datum LE <fs_tmp>-isten_ayrilma_tarih.

            DATA:ls_p0015  TYPE p0015.
            DATA:ls_return LIKE  bapireturn1.

            ls_p0015-pernr = <fs_tmp>-pernr.
*          ls_p0015-subty =
            ls_p0015-endda = <fs_tmp>-isten_ayrilma_tarih.
            ls_p0015-begda = sy-datum.
            ls_p0015-lgart = '2015'.
            ls_p0015-betrg = <fs_tmp>-kesint_yukleme.

            CALL FUNCTION 'HR_EMPLOYEE_ENQUEUE'
              EXPORTING
                number = ls_p0015-pernr.
            CALL FUNCTION 'HR_INFOTYPE_OPERATION'
              EXPORTING
                infty         = '0015'
                number        = ls_p0015-pernr
                subtype       = ls_p0015-lgart
                validityend   = ls_p0015-endda
                validitybegin = ls_p0015-begda
                record        = ls_p0015
                operation     = 'INS'
                tclas         = 'A'
              IMPORTING
                return        = ls_return.

            IF ls_return IS INITIAL.
              <fs_tmp>-icon = '3'.
              MESSAGE 'İşlem başarılı!' TYPE 'I' DISPLAY LIKE 'S'.
            ELSE.
              IF ls_return-type EQ 'E'.
                <fs_tmp>-icon = '1'.
                MESSAGE 'İşten ayrılmış personele giriş yapamazsınız!' TYPE 'I' DISPLAY LIKE 'E'.
             ENDIF.
              ENDIF.

              CALL FUNCTION 'HR_EMPLOYEE_DEQUEUE'
                EXPORTING
                  number = ls_p0015-pernr.

            ELSE.
              MESSAGE 'Geçmi tarihli işten ayrılmış personelin kesintisini yapamazsınız!' TYPE 'I' DISPLAY LIKE 'E'.

*            ENDIF.



          ENDIF.
        ENDLOOP.

*      IF lv_flag EQ '1'.
*        MESSAGE 'Bu kayıt daha önce sıfırlanmıştır!' TYPE 'I' DISPLAY LIKE 'I'.
*      ELSE.
*        MESSAGE 'İşlem başarıyla tamamlandı!' TYPE 'I' DISPLAY LIKE 'S'.
*      ENDIF.

    ENDCASE.
    PERFORM refresh_alv.
ENDFORM.                    " HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*&      Form  HANDLE_TOOLBAR
*&---------------------------------------------------------------------*
*       text  LAYOUTUN ÜSTÜNDEKİ TOOLBARLARI DEĞİŞTİREBİLMEMİZİ SAĞLAR.
*----------------------------------------------------------------------*
FORM handle_toolbar  USING e_object TYPE REF TO cl_alv_event_toolbar_set
                           e_sender TYPE REF TO cl_gui_alv_grid.

  DATA  : lt_toolbar TYPE ttb_button.
  DATA  : ls_toolbar TYPE stb_button.
  CASE e_sender.
    WHEN gcl_grid.

      ls_toolbar-function  = 'ISLE'."'Yazdırma öngörünümü'.
      ls_toolbar-quickinfo = 'Kesintiyi İşle'."Yazdırma öngörünümü'.
      ls_toolbar-butn_type = '0'.
      ls_toolbar-text      = 'Kesintiyi İşle'."Yazdırma öngörünümü'.
      ls_toolbar-icon      = icon_businav_objects."icon_start_viewer.
      INSERT ls_toolbar INTO TABLE lt_toolbar .



  ENDCASE.

  INSERT LINES OF lt_toolbar INTO TABLE  e_object->mt_toolbar[].
*  e_object->mt_toolbar[] = lt_toolbar[].
ENDFORM.                    " HANDLE_TOOLBAR

*----------------------------------------------------------------------*
FORM handle_data_changed  USING er_data_changed TYPE REF TO cl_alv_changed_data_protocol
                                e_onf4          TYPE char01
                                e_onf4_before   TYPE char01
                                e_onf4_after    TYPE char01
                                e_ucomm         TYPE sy-ucomm
                                e_sender        TYPE REF TO cl_gui_alv_grid.
  "DEGISEN VERIYI ALGILAMAK ICIN GEREKLI
  "EDITLI ALAN VAR ISE VEYA CHECKBOX O DURUMDA KULLANILIR

ENDFORM.                    " HANDLE_DATA_CHANGED
**&---------------------------------------------------------------------*
**&      Form  HANDLE_DATA_CHANGED_FINISHED
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
FORM handle_data_changed_finished  USING e_modified
                                         et_good_cells TYPE lvc_t_modi
                                         e_sender TYPE REF TO cl_gui_alv_grid.

ENDFORM.                    " HANDLE_DATA_CHANGED_FINISHED
