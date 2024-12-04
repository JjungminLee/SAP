*&---------------------------------------------------------------------*
*&  Include           ZPROJECT13_PO_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SET_INIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SET_INIT .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_OBJECT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_OBJECT .

  CREATE OBJECT GC_DOCKING
  EXPORTING
*    PARENT                      =
    REPID                       = SY-REPID
    DYNNR                       = SY-DYNNR
*    SIDE                        = DOCK_AT_LEFT
    EXTENSION                   = 2000
*    STYLE                       =
*    LIFETIME                    = lifetime_default
*    CAPTION                     =
*    METRIC                      = 0
*    RATIO                       =
*    NO_AUTODEF_PROGID_DYNNR     =
*    NAME                        =
*  EXCEPTIONS
*    CNTL_ERROR                  = 1
*    CNTL_SYSTEM_ERROR           = 2
*    CREATE_ERROR                = 3
*    LIFETIME_ERROR              = 4
*    LIFETIME_DYNPRO_DYNPRO_LINK = 5
*    others                      = 6
    .
IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

CREATE OBJECT GC_GRID
  EXPORTING
*    I_SHELLSTYLE      = 0
*    I_LIFETIME        =
    I_PARENT          = GC_DOCKING
*    I_APPL_EVENTS     = space
*    I_PARENTDBG       =
*    I_APPLOGPARENT    =
*    I_GRAPHICSPARENT  =
*    I_NAME            =
*    I_FCAT_COMPLETE   = SPACE
*  EXCEPTIONS
*    ERROR_CNTL_CREATE = 1
*    ERROR_CNTL_INIT   = 2
*    ERROR_CNTL_LINK   = 3
*    ERROR_DP_CREATE   = 4
*    others            = 5
    .
IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CLASS_EVENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CLASS_EVENT .

  CALL METHOD GC_GRID->REGISTER_EDIT_EVENT
    EXPORTING
      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED
*    EXCEPTIONS
*      ERROR      = 1
*      others     = 2
          .
  IF SY-SUBRC <> 0.
*   Implement suitable error handling here
  ENDIF.
  IF P_CREATE = 'X' .
    CREATE OBJECT GO_EVENT_APPEND .
    SET HANDLER GO_EVENT_APPEND->HANDLER_DATA_APPEND_CHANGED FOR GC_GRID .

    CREATE OBJECT GO_EVENT_DELETE .
    SET HANDLER GO_EVENT_DELETE->HANDLER_DATA_DELETE_CHANGED FOR GC_GRID .

    CREATE OBJECT GO_EVENT_CREATE .
    SET HANDLER GO_EVENT_CREATE->HANDLER_DATA_CREATE_CHANGED FOR GC_GRID .

  ENDIF .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELD_CATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FIELD_CATALOG .

  CLEAR : GS_FIELDCAT , GT_FIELDCAT .
  GS_FIELDCAT-COL_POS = 1.
  GS_FIELDCAT-FIELDNAME = 'ZEKPO_EBELP' .
  GS_FIELDCAT-COLTEXT = '품목' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 2.
  GS_FIELDCAT-FIELDNAME = 'ZEKPO_MATNR' .
  GS_FIELDCAT-COLTEXT = '자재번호' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .


  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 3.
  GS_FIELDCAT-FIELDNAME = 'ZMAKT_MAKTX' .
  GS_FIELDCAT-COLTEXT = '자재명' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 4.
  GS_FIELDCAT-FIELDNAME = 'ZEKPO_MENGE' .
  GS_FIELDCAT-COLTEXT = 'PO수량' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 5.
  GS_FIELDCAT-FIELDNAME = 'ZEKPO_BPRME' .
  GS_FIELDCAT-COLTEXT = '단가' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 6.
  GS_FIELDCAT-FIELDNAME = 'ZEKPO_MEINS' .
  GS_FIELDCAT-COLTEXT = '단위' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 7.
  GS_FIELDCAT-FIELDNAME = 'ZEKKO_WAERS' .
  GS_FIELDCAT-COLTEXT = '통화' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 8.
  GS_FIELDCAT-FIELDNAME = 'ZLFM1_MWSKZ' .
  GS_FIELDCAT-COLTEXT = '세금코드' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 9.
  GS_FIELDCAT-FIELDNAME = 'ZEKPO_PRDAT' .
  GS_FIELDCAT-COLTEXT = '납품일' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .


  CLEAR : GS_FIELDCAT  .
   GS_FIELDCAT-COL_POS = 10.
   GS_FIELDCAT-FIELDNAME = 'ZEKPO_WERKS' .
   GS_FIELDCAT-COLTEXT = '플랜트' .
   APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 11.
  GS_FIELDCAT-FIELDNAME = 'ZEKPO_LGORT' .
  GS_FIELDCAT-COLTEXT = '저장위치' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_LAYOUT .

  IF P_CREATE = 'X' .
    GS_LAYOUT-EDIT = 'X'.
  ENDIF .


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALL_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_ALV .

  IF P_CREATE = 'X' .
     CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*      I_BUFFER_ACTIVE               =
*      I_BYPASSING_BUFFER            =
*      I_CONSISTENCY_CHECK           =
*      I_STRUCTURE_NAME              =
*      IS_VARIANT                    =
*      I_SAVE                        =
*      I_DEFAULT                     = 'X'
      IS_LAYOUT                     = GS_LAYOUT
*      IS_PRINT                      =
*      IT_SPECIAL_GROUPS             =
*      IT_TOOLBAR_EXCLUDING          =
*      IT_HYPERLINK                  =
*      IT_ALV_GRAPHICS               =
*      IT_EXCEPT_QINFO               =
*      IR_SALV_ADAPTER               =
    CHANGING
      IT_OUTTAB                     = GT_PURCHASE
      IT_FIELDCATALOG               = GT_FIELDCAT
*      IT_SORT                       =
*      IT_FILTER                     =
*    EXCEPTIONS
*      INVALID_PARAMETER_COMBINATION = 1
*      PROGRAM_ERROR                 = 2
*      TOO_MANY_LINES                = 3
*      others                        = 4
  .

  ELSE .

     CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
*    EXPORTING
*      I_BUFFER_ACTIVE               =
*      I_BYPASSING_BUFFER            =
*      I_CONSISTENCY_CHECK           =
*      I_STRUCTURE_NAME              =
*      IS_VARIANT                    =
*      I_SAVE                        =
*      I_DEFAULT                     = 'X'
*      IS_LAYOUT                     = GS_LAYOUT
*      IS_PRINT                      =
*      IT_SPECIAL_GROUPS             =
*      IT_TOOLBAR_EXCLUDING          =
*      IT_HYPERLINK                  =
*      IT_ALV_GRAPHICS               =
*      IT_EXCEPT_QINFO               =
*      IR_SALV_ADAPTER               =
    CHANGING
      IT_OUTTAB                     = GT_PURCHASE
      IT_FIELDCATALOG               = GT_FIELDCAT
*      IT_SORT                       =
*      IT_FILTER                     =
*    EXCEPTIONS
*      INVALID_PARAMETER_COMBINATION = 1
*      PROGRAM_ERROR                 = 2
*      TOO_MANY_LINES                = 3
*      others                        = 4
  .

  ENDIF .


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REFRESH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM REFRESH .
  DATA : LS_STABLE TYPE LVC_S_STBL .
  LS_STABLE-ROW = 'X' .
  LS_STABLE-COL = 'X' .

  CALL METHOD GC_GRID->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE      = LS_STABLE
*      I_SOFT_REFRESH =
*    EXCEPTIONS
*      FINISHED       = 1
*      others         = 2
          .
  IF SY-SUBRC <> 0.
*   Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_DATA_APPEND_CHANGED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ER_DATA_CHANGED  text
*      -->P_E_ONF4  text
*      -->P_E_ONF4_BEFORE  text
*      -->P_E_ONF4_AFTER  text
*      -->P_E_UCOMM  text
*----------------------------------------------------------------------*
FORM ALV_DATA_APPEND_CHANGED  USING    P_DATA_CHANGED TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                        P_E_ONF4
                                        P_E_ONF4_BEFORE
                                        P_E_ONF4_AFTER
                                        P_E_UCOMM.

  DATA : LS_MODI TYPE LVC_S_MODI .
  CLEAR : LS_MODI .
  LOOP AT P_DATA_CHANGED->MT_GOOD_CELLS INTO LS_MODI.

    READ TABLE GT_PURCHASE INTO GS_PURCHASE INDEX LS_MODI-ROW_ID.
    IF SY-SUBRC = 0.
      " 변경된 필드에 따라 GS_SUPPLIER 업데이트
      CASE LS_MODI-FIELDNAME.
        WHEN 'ZEKPO_EBELP'.
          GS_PURCHASE-ZEKPO_EBELP = LS_MODI-VALUE.
        WHEN 'ZEKPO_MATNR'.
          GS_PURCHASE-ZEKPO_MATNR = LS_MODI-VALUE.
        WHEN 'ZMAKT_MAKTX'.
          GS_PURCHASE-ZMAKT_MAKTX = LS_MODI-VALUE.
        WHEN 'ZEKPO_MENGE'.
          GS_PURCHASE-ZEKPO_MENGE = LS_MODI-VALUE.
        WHEN 'ZEKPO_BPRME'.
          GS_PURCHASE-ZEKPO_BPRME = LS_MODI-VALUE.
        WHEN 'ZEKPO_MEINS'.
          GS_PURCHASE-ZEKPO_MEINS = LS_MODI-VALUE.
        WHEN 'ZEKKO_WAERS'.
          GS_PURCHASE-ZEKKO_WAERS = LS_MODI-VALUE.
        WHEN 'ZLFM1_MWSKZ'.
          GS_PURCHASE-ZLFM1_MWSKZ = LS_MODI-VALUE.
        WHEN 'ZEKKO_ZEKPO_PRDAT'.
          GS_PURCHASE-ZEKPO_PRDAT = LS_MODI-VALUE.
        WHEN 'ZEKPO_WERKS'.
          GS_PURCHASE-ZEKPO_WERKS = LS_MODI-VALUE.
        WHEN 'ZEKPO_LGORT'.
          GS_PURCHASE-ZEKPO_LGORT = LS_MODI-VALUE.
      ENDCASE.
      " 수정된 GS_SUPPLIER를 GT_SUPPLIER에 반영
      MODIFY GT_PURCHASE FROM GS_PURCHASE INDEX LS_MODI-ROW_ID.
    ENDIF.
  ENDLOOP.

  PERFORM REFRESH.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_DATA_DELETE_CHANGED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ER_DATA_CHANGED  text
*      -->P_E_ONF4  text
*      -->P_E_ONF4_BEFORE  text
*      -->P_E_ONF4_AFTER  text
*      -->P_E_UCOMM  text
*----------------------------------------------------------------------*
FORM ALV_DATA_DELETE_CHANGED  USING    P_DATA_CHANGED TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                        P_E_ONF4
                                        P_E_ONF4_BEFORE
                                        P_E_ONF4_AFTER
                                        P_E_UCOMM.




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_DATA_CREATE_CHANGED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ER_DATA_CHANGED  text
*      -->P_E_ONF4  text
*      -->P_E_ONF4_BEFORE  text
*      -->P_E_ONF4_AFTER  text
*      -->P_E_UCOMM  text
*----------------------------------------------------------------------*
FORM ALV_DATA_CREATE_CHANGED  USING    P_DATA_CHANGED TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                        P_E_ONF4
                                        P_E_ONF4_BEFORE
                                        P_E_ONF4_AFTER
                                        P_E_UCOMM.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PARAM_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PARAM_CHECK .

  "실제 존재하는 구매처인지 정합성 체크하기
  DATA : BEGIN OF LS_LIFNR ,
    ZLFA1_LIFNR TYPE ZEDT13_204-ZEKKO_LIFNR ,
  END OF LS_LIFNR .

  DATA : LT_LIFNR LIKE TABLE OF LS_LIFNR .

  SELECT * FROM ZEDT13_201 INTO CORRESPONDING FIELDS OF TABLE LT_LIFNR .


  GV_FOUND = 'N' .

  LOOP AT LT_LIFNR INTO LS_LIFNR .
    IF LS_LIFNR-ZLFA1_LIFNR = P_LIFNR .
      GV_FOUND = 'Y' .
    ENDIF .
  ENDLOOP .


ENDFORM.