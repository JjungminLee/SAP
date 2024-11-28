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


IF P_KTOKK = '3000' .
  CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
  EXPORTING
*    I_BUFFER_ACTIVE               =
*    I_BYPASSING_BUFFER            =
*    I_CONSISTENCY_CHECK           =
*    I_STRUCTURE_NAME              =
*    IS_VARIANT                    =
*    I_SAVE                        =
*    I_DEFAULT                     = 'X'
    IS_LAYOUT                     = GS_LAYOUT
*    IS_PRINT                      =
*    IT_SPECIAL_GROUPS             =
*    IT_TOOLBAR_EXCLUDING          =
*    IT_HYPERLINK                  =
*    IT_ALV_GRAPHICS               =
*    IT_EXCEPT_QINFO               =
*    IR_SALV_ADAPTER               =
  CHANGING
    IT_OUTTAB                     = GT_SUPPLIER
    IT_FIELDCATALOG               = GT_FIELDCAT_PERSON
*    IT_SORT                       =
*    IT_FILTER                     =
*  EXCEPTIONS
*    INVALID_PARAMETER_COMBINATION = 1
*    PROGRAM_ERROR                 = 2
*    TOO_MANY_LINES                = 3
*    others                        = 4
.

ELSE .

   CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
  EXPORTING
*    I_BUFFER_ACTIVE               =
*    I_BYPASSING_BUFFER            =
*    I_CONSISTENCY_CHECK           =
*    I_STRUCTURE_NAME              =
*    IS_VARIANT                    =
*    I_SAVE                        =
*    I_DEFAULT                     = 'X'
    IS_LAYOUT                     = GS_LAYOUT
*    IS_PRINT                      =
*    IT_SPECIAL_GROUPS             =
*    IT_TOOLBAR_EXCLUDING          =
*    IT_HYPERLINK                  =
*    IT_ALV_GRAPHICS               =
*    IT_EXCEPT_QINFO               =
*    IR_SALV_ADAPTER               =
  CHANGING
    IT_OUTTAB                     = GT_SUPPLIER
    IT_FIELDCATALOG               = GT_FIELDCAT_COMPANY
*    IT_SORT                       =
*    IT_FILTER                     =
*  EXCEPTIONS
*    INVALID_PARAMETER_COMBINATION = 1
*    PROGRAM_ERROR                 = 2
*    TOO_MANY_LINES                = 3
*    others                        = 4
.


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

  GS_LAYOUT-EDIT = 'X'.

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
FORM ALV_HANDLER_DATA_CHANGED  USING    P_ER_DATA_CHANGED
                                        P_E_ONF4
                                        P_E_ONF4_BEFORE
                                        P_E_ONF4_AFTER
                                        P_E_UCOMM.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_DATA_CHANGED_FINISHED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_DATA_CHANGED_FINISHED .

ENDFORM.