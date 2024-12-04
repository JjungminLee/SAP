*&---------------------------------------------------------------------*
*&  Include           ZPROJECT13_BP_F01
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
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

  DATA LV_KTOKK TYPE NUMC4 .
  LV_KTOKK = P_KTOKK2 .

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
  EXPORTING
    input  = LV_KTOKK
  IMPORTING
    output = LV_KTOKK .


  SELECT * FROM ZEDT13_201 AS A
      INNER JOIN ZEDT13_202 AS B ON A~ZLFA1_LIFNR = B~ZLFB1_LIFNR
      INNER JOIN ZEDT13_203 AS C ON A~ZLFA1_LIFNR = C~ZLFM1_LIFNR
      INTO CORRESPONDING FIELDS OF TABLE GT_SUPPLIER
      WHERE A~ZLFA1_KTOKK = LV_KTOKK AND B~ZLFB1_BUKRS = P_BUKRS2 .


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_DATA .



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
*&      Form  CALL_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_ALV .


IF P_CREATE = 'X' .
  "생성시

  IF P_KTOKK = '3000' .
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
      IT_OUTTAB                     = GT_SUPPLIER
      IT_FIELDCATALOG               = GT_FIELDCAT_PERSON
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
      IT_OUTTAB                     = GT_SUPPLIER
      IT_FIELDCATALOG               = GT_FIELDCAT_COMPANY
*      IT_SORT                       =
*      IT_FILTER                     =
*    EXCEPTIONS
*      INVALID_PARAMETER_COMBINATION = 1
*      PROGRAM_ERROR                 = 2
*      TOO_MANY_LINES                = 3
*      others                        = 4
  .


  ENDIF .

ELSEIF P_LOOKUP = 'X' .

  "조회시

  DATA: LV_KTOKK2 TYPE ZEDT13_201-ZLFA1_STCD1 .
  LV_KTOKK2 =  P_KTOKK2 .

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      INPUT  = LV_KTOKK2
    IMPORTING
      OUTPUT = LV_KTOKK2.



    IF LV_KTOKK2 = '3000' .
      CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
*      EXPORTING
*        I_BUFFER_ACTIVE               =
*        I_BYPASSING_BUFFER            =
*        I_CONSISTENCY_CHECK           =
*        I_STRUCTURE_NAME              =
*        IS_VARIANT                    =
*        I_SAVE                        =
*        I_DEFAULT                     = 'X'
*        IS_LAYOUT                     = GS_LAYOUT
*        IS_PRINT                      =
*        IT_SPECIAL_GROUPS             =
*        IT_TOOLBAR_EXCLUDING          =
*        IT_HYPERLINK                  =
*        IT_ALV_GRAPHICS               =
*        IT_EXCEPT_QINFO               =
*        IR_SALV_ADAPTER               =
      CHANGING
        IT_OUTTAB                     = GT_SUPPLIER
        IT_FIELDCATALOG               = GT_FIELDCAT_PERSON
*        IT_SORT                       =
*        IT_FILTER                     =
*      EXCEPTIONS
*        INVALID_PARAMETER_COMBINATION = 1
*        PROGRAM_ERROR                 = 2
*        TOO_MANY_LINES                = 3
*        others                        = 4
    .

    ELSE .

      CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
*      EXPORTING
*        I_BUFFER_ACTIVE               =
*        I_BYPASSING_BUFFER            =
*        I_CONSISTENCY_CHECK           =
*        I_STRUCTURE_NAME              =
*        IS_VARIANT                    =
*        I_SAVE                        =
*        I_DEFAULT                     = 'X'
*        IS_LAYOUT                     = GS_LAYOUT
*        IS_PRINT                      =
*        IT_SPECIAL_GROUPS             =
*        IT_TOOLBAR_EXCLUDING          =
*        IT_HYPERLINK                  =
*        IT_ALV_GRAPHICS               =
*        IT_EXCEPT_QINFO               =
*        IR_SALV_ADAPTER               =
      CHANGING
        IT_OUTTAB                     = GT_SUPPLIER
        IT_FIELDCATALOG               = GT_FIELDCAT_COMPANY
*        IT_SORT                       =
*        IT_FILTER                     =
*      EXCEPTIONS
*        INVALID_PARAMETER_COMBINATION = 1
*        PROGRAM_ERROR                 = 2
*        TOO_MANY_LINES                = 3
*        others                        = 4
    .


  ENDIF .

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
FORM FIELD_CATALOG_PERSON .

  CLEAR : GS_FIELDCAT_PERSON , GT_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 1.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFA1_NAME' .
  GS_FIELDCAT_PERSON-COLTEXT = '구매처명' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON  .
  GS_FIELDCAT_PERSON-COL_POS = 2.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFA1_STCD1' .
  GS_FIELDCAT_PERSON-COLTEXT = '개인번호' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 3.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFA1_STARS' .
  GS_FIELDCAT_PERSON-COLTEXT = '주소' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 4.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFB1_AKNOT' .
  GS_FIELDCAT_PERSON-COLTEXT = '조정계정' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 5.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFB1_ZTERM' .
  GS_FIELDCAT_PERSON-COLTEXT = '지급조건' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 6.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFM1_EKORG' .
  GS_FIELDCAT_PERSON-COLTEXT = '구매조직' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 7.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFM1_EKGRP' .
  GS_FIELDCAT_PERSON-COLTEXT = '구매그룹' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 8.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFM1_WAERS' .
  GS_FIELDCAT_PERSON-COLTEXT = '통화' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 7.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFM1_MWSKZ' .
  GS_FIELDCAT_PERSON-COLTEXT = '세금코드' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

ENDFORM.

FORM FIELD_CATALOG_PERSON_DISPLAY .

  CLEAR : GS_FIELDCAT_PERSON , GT_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 1.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFA1_NAME' .
  GS_FIELDCAT_PERSON-COLTEXT = '구매처명' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON  .
  GS_FIELDCAT_PERSON-COL_POS = 2.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFA1_STCD1' .
  GS_FIELDCAT_PERSON-COLTEXT = '개인번호' .
  GS_FIELDCAT_PERSON-EDIT = 'X' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 3.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFA1_STARS' .
  GS_FIELDCAT_PERSON-COLTEXT = '주소' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 4.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFB1_AKNOT' .
  GS_FIELDCAT_PERSON-COLTEXT = '조정계정' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 5.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFB1_ZTERM' .
  GS_FIELDCAT_PERSON-COLTEXT = '지급조건' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 6.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFM1_EKORG' .
  GS_FIELDCAT_PERSON-COLTEXT = '구매조직' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 7.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFM1_EKGRP' .
  GS_FIELDCAT_PERSON-COLTEXT = '구매그룹' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 8.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFM1_WAERS' .
  GS_FIELDCAT_PERSON-COLTEXT = '통화' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

  CLEAR : GS_FIELDCAT_PERSON .
  GS_FIELDCAT_PERSON-COL_POS = 7.
  GS_FIELDCAT_PERSON-FIELDNAME = 'ZLFM1_MWSKZ' .
  GS_FIELDCAT_PERSON-COLTEXT = '세금코드' .
  APPEND GS_FIELDCAT_PERSON TO GT_FIELDCAT_PERSON .

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  FIELD_CATALOG_COMPANY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FIELD_CATALOG_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY , GT_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 1.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFA1_NAME' .
  GS_FIELDCAT_COMPANY-COLTEXT = '구매처명' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY  .
  GS_FIELDCAT_COMPANY-COL_POS = 2.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFA1_STCD2' .
  GS_FIELDCAT_COMPANY-COLTEXT = '사업자번호' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 3.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFA1_STARS' .
  GS_FIELDCAT_COMPANY-COLTEXT = '주소' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 4.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFB1_AKNOT' .
  GS_FIELDCAT_COMPANY-COLTEXT = '조정계정' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 5.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFB1_ZTERM' .
  GS_FIELDCAT_COMPANY-COLTEXT = '지급조건' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 6.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFM1_EKORG' .
  GS_FIELDCAT_COMPANY-COLTEXT = '구매조직' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 7.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFM1_EKGRP' .
  GS_FIELDCAT_COMPANY-COLTEXT = '구매그룹' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 8.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFM1_WAERS' .
  GS_FIELDCAT_COMPANY-COLTEXT = '통화' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 7.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFM1_MWSKZ' .
  GS_FIELDCAT_COMPANY-COLTEXT = '세금코드' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

ENDFORM.


FORM FIELD_CATALOG_COMPANY_DISPLAY .

  CLEAR : GS_FIELDCAT_COMPANY , GT_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 1.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFA1_NAME' .
  GS_FIELDCAT_COMPANY-COLTEXT = '구매처명' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY  .
  GS_FIELDCAT_COMPANY-COL_POS = 2.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFA1_STCD2' .
  GS_FIELDCAT_COMPANY-COLTEXT = '사업자번호' .
  GS_FIELDCAT_COMPANY-EDIT = 'X' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 3.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFA1_STARS' .
  GS_FIELDCAT_COMPANY-COLTEXT = '주소' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 4.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFB1_AKNOT' .
  GS_FIELDCAT_COMPANY-COLTEXT = '조정계정' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 5.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFB1_ZTERM' .
  GS_FIELDCAT_COMPANY-COLTEXT = '지급조건' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 6.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFM1_EKORG' .
  GS_FIELDCAT_COMPANY-COLTEXT = '구매조직' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 7.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFM1_EKGRP' .
  GS_FIELDCAT_COMPANY-COLTEXT = '구매그룹' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 8.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFM1_WAERS' .
  GS_FIELDCAT_COMPANY-COLTEXT = '통화' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

  CLEAR : GS_FIELDCAT_COMPANY .
  GS_FIELDCAT_COMPANY-COL_POS = 7.
  GS_FIELDCAT_COMPANY-FIELDNAME = 'ZLFM1_MWSKZ' .
  GS_FIELDCAT_COMPANY-COLTEXT = '세금코드' .
  APPEND GS_FIELDCAT_COMPANY TO GT_FIELDCAT_COMPANY .

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
*&      Form  ALV_HANDLER_DATA_CHANGED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ER_DATA_CHANGED  text
*      -->P_E_ONF4  text
*      -->P_E_ONF4_BEFORE  text
*      -->P_E_ONF4_AFTER  text
*      -->P_E_UCOMM  text
*----------------------------------------------------------------------*
FORM ALV_HANDLER_DATA_CHANGED  USING    P_DATA_CHANGED TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                        P_E_ONF4
                                        P_E_ONF4_BEFORE
                                        P_E_ONF4_AFTER
                                        P_E_UCOMM.

  DATA : LS_MODI TYPE LVC_S_MODI .
  CLEAR : LS_MODI .
  LOOP AT P_DATA_CHANGED->MT_GOOD_CELLS INTO LS_MODI.
    " 해당 행을 GS_SUPPLIER로 읽어오기
    READ TABLE GT_SUPPLIER INTO GS_SUPPLIER INDEX LS_MODI-ROW_ID.
    IF SY-SUBRC = 0.
      " 변경된 필드에 따라 GS_SUPPLIER 업데이트
      CASE LS_MODI-FIELDNAME.
        WHEN 'ZLFA1_NAME'.
          GS_SUPPLIER-ZLFA1_NAME = LS_MODI-VALUE.
        WHEN 'ZLFA1_STCD1'.
          GS_SUPPLIER-ZLFA1_STCD1 = LS_MODI-VALUE.
        WHEN 'ZLFA1_STARS'.
          GS_SUPPLIER-ZLFA1_STARS = LS_MODI-VALUE.
        WHEN 'ZLFA1_STCD2'.
          GS_SUPPLIER-ZLFA1_STCD2 = LS_MODI-VALUE.
        WHEN 'ZLFB1_AKNOT'.
          GS_SUPPLIER-ZLFB1_AKNOT = LS_MODI-VALUE.
        WHEN 'ZLFB1_ZTERM'.
          GS_SUPPLIER-ZLFB1_ZTERM = LS_MODI-VALUE.
      ENDCASE.
      " 수정된 GS_SUPPLIER를 GT_SUPPLIER에 반영
      MODIFY GT_SUPPLIER FROM GS_SUPPLIER INDEX LS_MODI-ROW_ID.
    ENDIF.
  ENDLOOP.

  PERFORM REFRESH.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_DATA_CHANGED_FINISHED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_DATA_CHANGED_FINISHED USING P_MODIFIED PT_GOOD_CELLS TYPE LVC_T_MODI .


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
    SET HANDLER GO_EVENT->HANDLER_DATA_CHANGED FOR GC_GRID .
  ELSE .
     CREATE OBJECT GO_EVENT2 .
     SET HANDLER GO_EVENT2->HANDLER_DATA_CHANGED2 FOR GC_GRID .
  ENDIF .

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  ALV_HANDLER_DATA_CHANGED2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ER_DATA_CHANGED  text
*      -->P_E_ONF4  text
*      -->P_E_ONF4_BEFORE  text
*      -->P_E_ONF4_AFTER  text
*      -->P_E_UCOMM  text
*----------------------------------------------------------------------*
FORM ALV_HANDLER_DATA_CHANGED2  USING   P_DATA_CHANGED TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                        P_E_ONF4
                                        P_E_ONF4_BEFORE
                                        P_E_ONF4_AFTER
                                        P_E_UCOMM.

  DATA : LS_MODI TYPE LVC_S_MODI .
  CLEAR : LS_MODI .
  LOOP AT P_DATA_CHANGED->MT_GOOD_CELLS INTO LS_MODI.
    IF LS_MODI-FIELDNAME = 'ZLFA1_STCD1' .
      READ TABLE GT_SUPPLIER INTO GS_SUPPLIER INDEX LS_MODI-ROW_ID.
      MODIFY GT_SUPPLIER FROM GS_SUPPLIER INDEX LS_MODI-ROW_ID.
    ELSEIF LS_MODI-FIELDNAME = 'ZLFA1_STCD2' .
      READ TABLE GT_SUPPLIER INTO GS_SUPPLIER INDEX LS_MODI-ROW_ID.
      MODIFY GT_SUPPLIER FROM GS_SUPPLIER INDEX LS_MODI-ROW_ID.
    ENDIF .
  ENDLOOP.

  PERFORM REFRESH.


ENDFORM.