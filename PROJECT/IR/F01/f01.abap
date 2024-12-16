*&---------------------------------------------------------------------*
*&  Include           ZPROJECT13_IR_F01
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
  P_DATS1 = SY-DATUM .

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
  IF P_EBELN1 IS INITIAL OR P_WERKS1 IS INITIAL OR P_DATS1 IS INITIAL .
    MESSAGE '구매오더, 플랜트, 송장처리일을 입력하시오' TYPE 'E' .
  ENDIF .
DATA : LS_PO TYPE ZEDT13_205 .
  DATA : LT_PO LIKE TABLE OF ZEDT13_205 .
  SELECT * FROM ZEDT13_205 INTO CORRESPONDING FIELDS OF TABLE LT_PO .
  DATA : LV_EBELN TYPE C LENGTH 10 .
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    input  = P_EBELN1
  IMPORTING
    output = LV_EBELN .
  LOOP AT LT_PO INTO LS_PO .
    IF LS_PO-ZEKKPO_EBELN = LV_EBELN .
      GV_FOUND = 'Y' .
    ENDIF .
  ENDLOOP .

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
    CREATE OBJECT GO_EVENT .
    SET HANDLER GO_EVENT->HANDLER_DATA_SELECT_CHANGED FOR GC_GRID .

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
  GS_FIELDCAT-FIELDNAME = 'L_CHECK' .
  GS_FIELDCAT-COLTEXT = '송장' .
  GS_FIELDCAT-CHECKBOX = 'X' .
  GS_FIELDCAT-EDIT = 'X' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 2.
  GS_FIELDCAT-FIELDNAME = 'ZEKKPO_EBELN' .
  GS_FIELDCAT-COLTEXT = '구매오더번호' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 2.
  GS_FIELDCAT-FIELDNAME = 'ZEKKO_BUKRS' .
  GS_FIELDCAT-COLTEXT = '회사코드' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 3.
  GS_FIELDCAT-FIELDNAME = 'ZBSIK_DMBTR_STR' .
  GS_FIELDCAT-COLTEXT = '공급가액' .
  GS_FIELDCAT-EDIT = 'X' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 4 .
  GS_FIELDCAT-FIELDNAME = 'ZBSIK_WAERS' .
  GS_FIELDCAT-COLTEXT = '통화' .
  GS_FIELDCAT-EDIT = 'X' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 5 .
  GS_FIELDCAT-FIELDNAME = 'ZBSIK_MWSKZ' .
  GS_FIELDCAT-COLTEXT = '세금코드' .
  GS_FIELDCAT-EDIT = 'X' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 6 .
  GS_FIELDCAT-FIELDNAME = 'ZBSIK_GSBER' .
  GS_FIELDCAT-COLTEXT = '사업장' .
  GS_FIELDCAT-EDIT = 'X' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .


  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 7 .
  GS_FIELDCAT-FIELDNAME = 'ZEKKO_LIFNR' .
  GS_FIELDCAT-COLTEXT = '구매처' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 8 .
  GS_FIELDCAT-FIELDNAME = 'ZEKPO_EBELP' .
  GS_FIELDCAT-COLTEXT = '품목' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELD_CATALOG_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FIELD_CATALOG_DISPLAY .
  CLEAR : GS_FIELDCAT , GT_FIELDCAT .
  GS_FIELDCAT-COL_POS = 1.
  GS_FIELDCAT-FIELDNAME = 'ZMSEG_BUKRS' .
  GS_FIELDCAT-COLTEXT = '회사코드' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 2 .
  GS_FIELDCAT-FIELDNAME = 'ZMSEG_EBELN' .
  GS_FIELDCAT-COLTEXT = '구매오더번호' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 3 .
  GS_FIELDCAT-FIELDNAME = 'ZBSIK_DMBTR' .
  gs_fieldcat-currency = 'krw'.
  gs_fieldcat-DECIMALS_O = '0'.
  GS_FIELDCAT-COLTEXT = '공급가액' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 4 .
  GS_FIELDCAT-FIELDNAME = 'ZBSIK_MWSTS' .
  gs_fieldcat-currency = 'krw'.
  gs_fieldcat-DECIMALS_O = '0'.
  GS_FIELDCAT-COLTEXT = '세액' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 5 .
  GS_FIELDCAT-FIELDNAME = 'ZBSIK_WRBTR' .
  gs_fieldcat-currency = 'krw'.
  gs_fieldcat-DECIMALS_O = '0'.
  GS_FIELDCAT-COLTEXT = '금액' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 6 .
  GS_FIELDCAT-FIELDNAME = 'ZBSIK_MWSKZ' .
  GS_FIELDCAT-COLTEXT = '세금코드' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 7 .
  GS_FIELDCAT-FIELDNAME = 'ZBSIK_SGTXT' .
  GS_FIELDCAT-OUTPUTLEN = 30 .
  GS_FIELDCAT-COLTEXT = '텍스트' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 8 .
  GS_FIELDCAT-FIELDNAME = 'ZMSEG_ZEILE' .
  GS_FIELDCAT-COLTEXT = '품목번호' .
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
  GS_LAYOUT-NO_COLEXPD = 'X' .
  GS_LAYOUT-ZEBRA = 'X' .
  GS_LAYOUT-SEL_MODE = 'A' .

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
  ELSE .
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
      IT_OUTTAB                     = GT_ITEM
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
*&      Form  GET_PO_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_PO_DATA .

 "만약 입고가 먼저 처리됐다면, 입고처리된 데이터는 제외되고 보여짐
  " 구매오더 P_EBELN1
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    input  = P_EBELN1
  IMPORTING
    output = P_EBELN1.

IF P_WERKS1 IS INITIAL.

  SELECT *
  FROM ZEDT13_204 AS A
       INNER JOIN ZEDT13_205 AS B ON A~ZEKKO_EBELN = B~ZEKKPO_EBELN
  INTO CORRESPONDING FIELDS OF TABLE GT_PURCHASE
  WHERE A~ZEKKO_EBELN = P_EBELN1 AND A~ZEKKO_EBELN NOT IN (
    SELECT ZMSEG_EBELN
      FROM ZEDT13_209 AS C WHERE C~ZMSEG_ZEILE = B~ZEKPO_EBELP ) .
ELSE .
  SELECT *
  FROM ZEDT13_204 AS A
       INNER JOIN ZEDT13_205 AS B ON A~ZEKKO_EBELN = B~ZEKKPO_EBELN
  INTO CORRESPONDING FIELDS OF TABLE GT_PURCHASE
  WHERE A~ZEKKO_EBELN = P_EBELN1 AND B~ZEKPO_WERKS = P_WERKS1 AND A~ZEKKO_EBELN NOT IN (
    SELECT ZMSEG_EBELN
      FROM ZEDT13_209 AS C WHERE C~ZMSEG_ZEILE = B~ZEKPO_EBELP )  .
ENDIF.

SELECT * FROM ZEDT13_207 INTO CORRESPONDING FIELDS OF TABLE GT_GR .

"207번에서 붙여넣을 데이터들
LOOP AT GT_GR INTO GS_GR .
  IF SY-TABIX MOD 2 = 0.
    READ TABLE GT_PURCHASE INTO GS_PURCHASE WITH KEY ZEKKPO_EBELN = gs_gr-ZMSEG_EBELN
            ZEKPO_EBELP = gs_gr-ZMSEG_ZEILE.
    " GS_PURCHASE-ZEKKPO_EBELN = GS_GR-ZMSEG_EBELN
    " AND GS_PURCHASE-ZEKPO_EBELP = GS_GR-ZMSEG_ZEILE
    IF SY-SUBRC = 0.
      "전표번호
      GS_PURCHASE-ZEKKPO_EBELN = GS_GR-ZMSEG_EBELN .
      "입고문서번호
      GS_PURCHASE-ZEKPO_EBELP = GS_GR-ZMSEG_ZEILE .
    ENDIF .
  ENDIF .
ENDLOOP .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_DATA_SELECT_CHANGED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ER_DATA_CHANGED  text
*      -->P_E_ONF4  text
*      -->P_E_ONF4_BEFORE  text
*      -->P_E_ONF4_AFTER  text
*      -->P_E_UCOMM  text
*----------------------------------------------------------------------*
FORM ALV_DATA_SELECT_CHANGED  USING   P_DATA_CHANGED TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                        P_E_ONF4
                                        P_E_ONF4_BEFORE
                                        P_E_ONF4_AFTER
                                        P_E_UCOMM.

  DATA : LS_MODI TYPE LVC_S_MODI .
  CLEAR : LS_MODI .
  DATA : LV_RESULT TYPE ZEDT13_200 .
  DATA : LV_NEW_EBELP TYPE ZEDT13_205-ZEKPO_EBELP .

  LOOP AT P_DATA_CHANGED->MT_GOOD_CELLS INTO LS_MODI.

    READ TABLE GT_PURCHASE INTO GS_PURCHASE INDEX LS_MODI-ROW_ID.
    CASE LS_MODI-FIELDNAME .
      WHEN 'ZBSIK_DMBTR' .
        GS_PURCHASE-ZBSIK_DMBTR = LS_MODI-VALUE .
      WHEN 'ZBSIK_MWSKZ' .
        GS_PURCHASE-ZBSIK_MWSKZ = LS_MODI-VALUE .
      WHEN 'ZBSIK_WAERS' .
        GS_PURCHASE-ZBSIK_WAERS = LS_MODI-VALUE .
      WHEN 'ZBSIK_GSBER' .
        GS_PURCHASE-ZBSIK_GSBER = LS_MODI-VALUE .
    ENDCASE .
    MODIFY GT_PURCHASE FROM GS_PURCHASE INDEX LS_MODI-ROW_ID.

  ENDLOOP .

  PERFORM REFRESH .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INSERT_DEBIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM INSERT_DEBIT USING LV_BUKRS LV_EBELN LV_LIFNR VALUE(lv_next_value)
      VALUE(LV_BELNR_NUM)
      LV_ZBSIK_BELNR .
  CLEAR GS_ITEM .
  "회사코드
  GS_ITEM-ZMSEG_BUKRS = LV_BUKRS .
  "구매오더 번호
  GS_ITEM-ZMSEG_EBELN = LV_EBELN .
  "거래금액
  GS_ITEM-ZBSIK_DMBTR = GS_PURCHASE-ZBSIK_DMBTR_STR .
  "부가가치세
  DATA : LV_TAX TYPE ZEDT13_210-ZBSIK_MWSKZ .
  DATA : LV_DMBTR TYPE P .
  LV_DMBTR = GS_PURCHASE-ZBSIK_DMBTR_STR .
  DATA: LV_DMBTR_NUM TYPE P.
  " STRING을 숫자로 변환
  LV_DMBTR_NUM = LV_DMBTR.
  DATA : LV_TAX_RATE TYPE P DECIMALS 3 VALUE '0.1' .
  LV_TAX = GS_PURCHASE-ZBSIK_MWSKZ .
  CASE LV_TAX .
    WHEN 'V1' .
      LV_DMBTR_NUM = LV_DMBTR_NUM * LV_TAX_RATE .
    WHEN 'V2' .
      LV_DMBTR_NUM = 0 .
    WHEN 'V3' .
      LV_DMBTR_NUM = LV_DMBTR_NUM * LV_TAX_RATE .
    WHEN 'V4' .
      LV_DMBTR_NUM = LV_DMBTR_NUM * LV_TAX_RATE .
    WHEN 'V5' .
      LV_DMBTR_NUM = LV_DMBTR_NUM * LV_TAX_RATE .
  ENDCASE .
  GS_ITEM-ZBSIK_MWSTS = LV_DMBTR_NUM .
  "세금코드
  GS_ITEM-ZBSIK_MWSKZ = GS_PURCHASE-ZBSIK_MWSKZ .
  "구매처번호
  GS_ITEM-ZMSEG_LIFNR = LV_LIFNR .
  "CURR
  GS_ITEM-ZBSIK_WAERS = GS_PURCHASE-ZBSIK_WAERS .
  "텍스트
  CONCATENATE LV_EBELN lv_next_value INTO GS_ITEM-ZBSIK_SGTXT .
  "아이템번호
   GS_ITEM-ZMSEG_ZEILE = GS_PURCHASE-ZEKPO_EBELP .
  "플랜트
   GS_ITEM-ZMSEG_WERKS = GS_PURCHASE-ZEKPO_WERKS .
  "차대변
   GS_ITEM-ZMSEG_SHKZG = 'L' .
  DATA : LV_ITEM_SIZE TYPE I .
  DESCRIBE TABLE GT_ITEM LINES LV_ITEM_SIZE .
  LV_BELNR_NUM = LV_BELNR_NUM + LV_ITEM_SIZE + 1 .
  LV_ZBSIK_BELNR = LV_BELNR_NUM .
  "금액
  GS_ITEM-ZBSIK_WRBTR = GS_ITEM-ZBSIK_DMBTR + GS_ITEM-ZBSIK_MWSTS .

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
     input  = LV_ZBSIK_BELNR
  IMPORTING
     output = LV_ZBSIK_BELNR .
  GS_ITEM-ZBSIK_BELNR = LV_ZBSIK_BELNR .
   APPEND GS_ITEM TO GT_ITEM .


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INSERT_CREDIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM INSERT_CREDIT USING LV_BUKRS LV_EBELN LV_LIFNR VALUE(lv_next_value)
      VALUE(LV_BELNR_NUM) LV_ZBSIK_BELNR .
  CLEAR GS_ITEM .
  "회사코드
  GS_ITEM-ZMSEG_BUKRS = LV_BUKRS .
  "구매오더 번호
  GS_ITEM-ZMSEG_EBELN = LV_EBELN .
  "거래금액
  GS_ITEM-ZBSIK_DMBTR = GS_PURCHASE-ZBSIK_DMBTR_STR .
  "부가가치세
  DATA : LV_TAX TYPE ZEDT13_210-ZBSIK_MWSKZ .
  DATA : LV_DMBTR TYPE P .
  LV_DMBTR = GS_PURCHASE-ZBSIK_DMBTR_STR .
  DATA: LV_DMBTR_NUM TYPE P.
  " STRING을 숫자로 변환
  LV_DMBTR_NUM = LV_DMBTR.
  LV_TAX = GS_PURCHASE-ZBSIK_MWSKZ .
  DATA : LV_TAX_RATE TYPE P DECIMALS 3 VALUE '0.1' .
  CASE LV_TAX .
    WHEN 'V1' .
      LV_DMBTR_NUM = LV_DMBTR_NUM * LV_TAX_RATE .
    WHEN 'V2' .
      LV_DMBTR_NUM = 0 .
    WHEN 'V3' .
      LV_DMBTR_NUM = LV_DMBTR_NUM * LV_TAX_RATE .
    WHEN 'V4' .
      LV_DMBTR_NUM = LV_DMBTR_NUM * LV_TAX_RATE .
    WHEN 'V5' .
      LV_DMBTR_NUM = LV_DMBTR_NUM * LV_TAX_RATE .
  ENDCASE .
  GS_ITEM-ZBSIK_MWSTS = LV_DMBTR_NUM .
  "세금코드
  GS_ITEM-ZBSIK_MWSKZ = GS_PURCHASE-ZBSIK_MWSKZ .
  "구매처번호
  GS_ITEM-ZMSEG_LIFNR = LV_LIFNR .
  "CURR
  GS_ITEM-ZBSIK_WAERS = GS_PURCHASE-ZBSIK_WAERS .
  "텍스트
  CONCATENATE LV_EBELN lv_next_value INTO GS_ITEM-ZBSIK_SGTXT .
  "아이템번호
   GS_ITEM-ZMSEG_ZEILE = GS_PURCHASE-ZEKPO_EBELP .
  "플랜트
   GS_ITEM-ZMSEG_WERKS = GS_PURCHASE-ZEKPO_WERKS .
  "차대변
   GS_ITEM-ZMSEG_SHKZG = 'H' .
 DATA : LV_ITEM_SIZE TYPE I .
  DESCRIBE TABLE GT_ITEM LINES LV_ITEM_SIZE .
  LV_BELNR_NUM = LV_BELNR_NUM + LV_ITEM_SIZE + 1 .
  LV_ZBSIK_BELNR = LV_BELNR_NUM .
  "금액
  GS_ITEM-ZBSIK_WRBTR = GS_ITEM-ZBSIK_DMBTR + GS_ITEM-ZBSIK_MWSTS .



  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
     input  = LV_ZBSIK_BELNR
  IMPORTING
     output = LV_ZBSIK_BELNR .

  GS_ITEM-ZBSIK_BELNR = LV_ZBSIK_BELNR .
   APPEND GS_ITEM TO GT_ITEM .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INSERT_TAX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM INSERT_TAX USING LV_BUKRS LV_EBELN LV_LIFNR
       VALUE(lv_next_value)
      VALUE(LV_BELNR_NUM) LV_ZBSIK_BELNR .
  CLEAR GS_ITEM .

  "회사코드
  GS_ITEM-ZMSEG_BUKRS = LV_BUKRS .
  "구매오더 번호
  GS_ITEM-ZMSEG_EBELN = LV_EBELN .
  "거래금액
  GS_ITEM-ZBSIK_DMBTR = GS_PURCHASE-ZBSIK_DMBTR_STR .
  "부가가치세
  DATA : LV_TAX TYPE ZEDT13_210-ZBSIK_MWSKZ .
  DATA : LV_DMBTR TYPE P .
  LV_DMBTR = GS_PURCHASE-ZBSIK_DMBTR_STR .
  DATA: LV_DMBTR_NUM TYPE P.
  " STRING을 숫자로 변환
  LV_DMBTR_NUM = LV_DMBTR.
  LV_TAX = GS_PURCHASE-ZBSIK_MWSKZ .
  DATA : LV_TAX_RATE TYPE P DECIMALS 3 VALUE '0.1' .
  CASE LV_TAX .
    WHEN 'V1' .
      LV_DMBTR_NUM = LV_DMBTR_NUM * LV_TAX_RATE .
    WHEN 'V2' .
      LV_DMBTR_NUM = 0 .
    WHEN 'V3' .
      LV_DMBTR_NUM = LV_DMBTR_NUM * LV_TAX_RATE .
    WHEN 'V4' .
      LV_DMBTR_NUM = LV_DMBTR_NUM * LV_TAX_RATE .
    WHEN 'V5' .
      LV_DMBTR_NUM = LV_DMBTR_NUM * LV_TAX_RATE .
  ENDCASE .
  GS_ITEM-ZBSIK_MWSTS = LV_DMBTR_NUM .
  "세금코드
  GS_ITEM-ZBSIK_MWSKZ = GS_PURCHASE-ZBSIK_MWSKZ .
  "구매처번호
  GS_ITEM-ZMSEG_LIFNR = LV_LIFNR .
  "CURR
  GS_ITEM-ZBSIK_WAERS = GS_PURCHASE-ZBSIK_WAERS .
  "텍스트
  CONCATENATE LV_EBELN lv_next_value INTO GS_ITEM-ZBSIK_SGTXT .
  "아이템번호
   GS_ITEM-ZMSEG_ZEILE = GS_PURCHASE-ZEKPO_EBELP .
  "플랜트
   GS_ITEM-ZMSEG_WERKS = GS_PURCHASE-ZEKPO_WERKS .
  "금액
  GS_ITEM-ZBSIK_WRBTR = GS_ITEM-ZBSIK_DMBTR + GS_ITEM-ZBSIK_MWSTS .

  DATA : LV_ITEM_SIZE TYPE I .
  DESCRIBE TABLE GT_ITEM LINES LV_ITEM_SIZE .
  LV_BELNR_NUM = LV_BELNR_NUM + LV_ITEM_SIZE + 1 .
  LV_ZBSIK_BELNR = LV_BELNR_NUM .



  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
     input  = LV_ZBSIK_BELNR
  IMPORTING
     output = LV_ZBSIK_BELNR .
  GS_ITEM-ZBSIK_BELNR = LV_ZBSIK_BELNR .
   APPEND GS_ITEM TO GT_ITEM .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_IR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_IR_DATA .
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = P_EBELN2
    IMPORTING
      output = P_EBELN2 .

  IF P_WERKS2 IS INITIAL .
    SELECT *
    FROM ZEDT13_209
    INTO CORRESPONDING FIELDS OF TABLE GT_ITEM
      WHERE ZMSEG_EBELN = P_EBELN2  .
  ELSE .
    SELECT *
    FROM ZEDT13_209
    INTO CORRESPONDING FIELDS OF TABLE GT_ITEM
      WHERE ZMSEG_WERKS = P_WERKS2 AND ZMSEG_EBELN = P_EBELN2 .
  ENDIF .

  LOOP AT GT_ITEM INTO GS_ITEM .
    DATA : lv_p_value TYPE P LENGTH 11.
    LV_P_VALUE = GS_ITEM-ZBSIK_BELNR .
    IF LV_P_VALUE MOD 3 = 1 .
       DELETE GT_ITEM INDEX sy-tabix.
    ENDIF .
    IF LV_P_VALUE MOD 3 = 2 .
       DELETE GT_ITEM INDEX sy-tabix.
    ENDIF .
  ENDLOOP .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PARAM_CHECK2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PARAM_CHECK2 .
  IF P_EBELN2 IS INITIAL OR P_WERKS2 IS INITIAL .
    MESSAGE '구매오더, 플랜트를  입력하시오' TYPE 'E' .
  ENDIF .

ENDFORM.