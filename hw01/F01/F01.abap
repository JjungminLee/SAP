*&---------------------------------------------------------------------*
*&  Include           ZEDR13_HW001_F01
*&---------------------------------------------------------------------*




FORM GET_DATA .
  LV_ORDNO_LOW = S_ZORDNO-LOW .
  LV_ORDNO_HIGH = S_ZORDNO-HIGH .
  DATA : LV_MATNR_LOW  TYPE C LENGTH 10 .
  DATA : LV_MATNR_HIGH  TYPE C LENGTH 10 .
  LV_MATNR_LOW = S_ZMATNR-LOW .
  LV_MATNR_HIGH = S_ZMATNR-HIGH .

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      INPUT         = LV_ORDNO_LOW
    IMPORTING
      OUTPUT        = LV_ORDNO_LOW .
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      INPUT         = LV_ORDNO_HIGH
    IMPORTING
      OUTPUT        = LV_ORDNO_HIGH .

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      INPUT         = LV_MATNR_LOW
    IMPORTING
      OUTPUT        = LV_MATNR_LOW .
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      INPUT         = LV_MATNR_HIGH
    IMPORTING
      OUTPUT        = LV_MATNR_HIGH .

  RANGES : GR_ORDNO FOR ZEDT13_100-ZORDNO .
  CLEAR GR_ORDNO .
  GR_ORDNO-SIGN = 'I' .
  GR_ORDNO-OPTION = 'BT' .
  GR_ORDNO-LOW = LV_ORDNO_LOW .
  GR_ORDNO-HIGH = LV_ORDNO_HIGH .
  APPEND GR_ORDNO .

  RANGES : GR_JDATE FOR ZEDT13_100-ZJDATE .
  CLEAR GR_JDATE .
  GR_JDATE-SIGN = 'I' .
  GR_JDATE-OPTION = 'BT' .
  GR_JDATE-LOW = S_ZJDATE-LOW .
  GR_JDATE-HIGH = S_ZJDATE-HIGH .
  APPEND GR_JDATE .

  RANGES : GR_MATNR FOR ZEDT13_100-ZMATNR .
  CLEAR GR_MATNR .
  GR_MATNR-SIGN = 'I' .
  GR_MATNR-OPTION = 'BT' .
  GR_MATNR-LOW = LV_MATNR_LOW .
  GR_MATNR-HIGH = LV_MATNR_HIGH .
  APPEND GR_MATNR .

  " 동적 SQL은 인터널 테이블로 사용
  DATA: LS_WHERE TYPE STRING ,
        LT_WHERE LIKE TABLE OF LS_WHERE .
  CLEAR LS_WHERE .
  IF LV_MATNR_LOW IS NOT INITIAL AND LV_MATNR_HIGH IS NOT INITIAL.
    LS_WHERE = `ZMATNR IN GR_MATNR`.
    APPEND LS_WHERE TO LT_WHERE .
    CLEAR LS_WHERE .
    LS_WHERE = 'AND' .
    APPEND LS_WHERE TO LT_WHERE .
  ENDIF.
  CLEAR LS_WHERE .
  IF S_ZJDATE-LOW IS NOT INITIAL AND S_ZJDATE-HIGH IS NOT INITIAL.
    LS_WHERE = `ZJDATE IN GR_JDATE`.
    APPEND LS_WHERE TO LT_WHERE .
    CLEAR LS_WHERE .
    LS_WHERE = 'AND' .
    APPEND LS_WHERE TO LT_WHERE .
  ENDIF.
  CLEAR LS_WHERE .
  IF LV_ORDNO_LOW IS NOT INITIAL AND LV_ORDNO_HIGH IS NOT INITIAL.
    LS_WHERE = `ZORDNO IN GR_ORDNO`.
    APPEND LS_WHERE TO LT_WHERE .
    CLEAR LS_WHERE .
    LS_WHERE = 'AND' .
    APPEND LS_WHERE TO LT_WHERE .
  ENDIF.
  CLEAR LS_WHERE .
  IF P_ZID IS NOT INITIAL.
    LS_WHERE = |ZIDCODE = '{ P_ZID }'|.
    APPEND LS_WHERE TO LT_WHERE .
    CLEAR LS_WHERE .
    LS_WHERE = 'AND' .
    APPEND LS_WHERE TO LT_WHERE .
  ENDIF.
  " [SCREEN] 6. 반품 내역 체크 풀면 반품 내역 안보여야 . ABAP OPEN SQL의 IS NULL은 = SPACE임
  IF Z_RETCH <> 'X' .
    LS_WHERE = |ZRET_FG = SPACE|.
    APPEND LS_WHERE TO LT_WHERE .
  ENDIF .

  " 마지막 요소가 'AND'라면 제거
  IF LT_WHERE[ lines( LT_WHERE ) ] = 'AND'.
    DELETE LT_WHERE INDEX lines( LT_WHERE ).
  ENDIF.

  IF LT_WHERE[] IS NOT INITIAL.
     SELECT * FROM ZEDT13_100
      INTO CORRESPONDING FIELDS OF TABLE GT_ORDER
      WHERE (LT_WHERE).
  ENDIF.


ENDFORM .


FORM CALL_ALV  .

IF P_RORD = 'X' .
    CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
*        I_BUFFER_ACTIVE               =
*        I_BYPASSING_BUFFER            =
*        I_CONSISTENCY_CHECK           =
*        I_STRUCTURE_NAME              =
*        IS_VARIANT                    =
*        I_SAVE                        =
*        I_DEFAULT                     = 'X'
        IS_LAYOUT                     = GS_LAYOUT
*        IS_PRINT                      =
*        IT_SPECIAL_GROUPS             =
*        IT_TOOLBAR_EXCLUDING          =
*        IT_HYPERLINK                  =
*        IT_ALV_GRAPHICS               =
*        IT_EXCEPT_QINFO               =
*        IR_SALV_ADAPTER               =
      CHANGING
        IT_OUTTAB                     = GT_ORDER_PRINT
        IT_FIELDCATALOG               = GT_FIELDCAT
        IT_SORT                       = GT_SORT
*        IT_FILTER                     =
*      EXCEPTIONS
*        INVALID_PARAMETER_COMBINATION = 1
*        PROGRAM_ERROR                 = 2
*        TOO_MANY_LINES                = 3
*        others                        = 4
            .
    IF SY-SUBRC <> 0.
*     Implement suitable error handling here
    ENDIF.

ELSEIF P_RDELV = 'X' .

  CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
*    EXPORTING
*      I_BUFFER_ACTIVE               =
*      I_BYPASSING_BUFFER            =
*      I_CONSISTENCY_CHECK           =
*      I_STRUCTURE_NAME              =
*      IS_VARIANT                    =
*      I_SAVE                        =
*      I_DEFAULT                     = 'X'
*      IS_LAYOUT                     =
*      IS_PRINT                      =
*      IT_SPECIAL_GROUPS             =
*      IT_TOOLBAR_EXCLUDING          =
*      IT_HYPERLINK                  =
*      IT_ALV_GRAPHICS               =
*      IT_EXCEPT_QINFO               =
*      IR_SALV_ADAPTER               =
    CHANGING
      IT_OUTTAB                     = GT_ORDER_PRINT
      IT_FIELDCATALOG               = GT_FIELDCAT
*      IT_SORT                       =
*      IT_FILTER                     =
*    EXCEPTIONS
*      INVALID_PARAMETER_COMBINATION = 1
*      PROGRAM_ERROR                 = 2
*      TOO_MANY_LINES                = 3
*      others                        = 4
          .
  IF SY-SUBRC <> 0.
*   Implement suitable error handling here
  ENDIF.


ENDIF .


ENDFORM .


*&---------------------------------------------------------------------*
*&      Form  FIELD_CATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FIELD_CATALOG_ORDER .
  " 신호등 정의
  " 주문관리 -> 매출구분에 매출일 경우 그린, 반품일 경우 레드
  CLEAR GS_ORDER .
  LOOP AT GT_ORDER INTO GS_ORDER .
    IF GS_ORDER-ZSALE_FG = '1' .
      GS_ORDER-ZCOLOR = '@08@' .
    ELSEIF GS_ORDER-ZSALE_FG = '2' .
      GS_ORDER-ZCOLOR = '@0A@' .
    ENDIF .
    MODIFY GT_ORDER FROM GS_ORDER INDEX SY-TABIX .
  ENDLOOP .

  CLEAR : GS_FIELDCAT , GT_FIELDCAT .
  GS_FIELDCAT-COL_POS = 1.
  GS_FIELDCAT-FIELDNAME = 'ZCOLOR' .
  GS_FIELDCAT-COLTEXT = '표기' .
  GS_FIELDCAT-ICON = 'X' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 2.
  GS_FIELDCAT-FIELDNAME = 'ZORDNO' .
  GS_FIELDCAT-COLTEXT = '주문번호' .
  GS_FIELDCAT-JUST = 'C' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 3.
  GS_FIELDCAT-FIELDNAME = 'ZIDCODE' .
  GS_FIELDCAT-COLTEXT = '회원ID' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 4 .
  GS_FIELDCAT-FIELDNAME = 'ZIDCODE' .
  GS_FIELDCAT-COLTEXT = '제품번호' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 5 .
  GS_FIELDCAT-FIELDNAME = 'ZMTART_T' .
  GS_FIELDCAT-COLTEXT = '제품유형' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 6.
  GS_FIELDCAT-FIELDNAME = 'ZVOLUM' .
  GS_FIELDCAT-COLTEXT = '수량' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 7 .
  GS_FIELDCAT-FIELDNAME = 'VRKME' .
  GS_FIELDCAT-COLTEXT = '단위' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 8 .
  GS_FIELDCAT-FIELDNAME = 'ZNSAMT' .
  GS_FIELDCAT-COLTEXT = '판매금액' .
  GS_FIELDCAT-JUST = 'R' .
  GS_FIELDCAT-CURRENCY = 'KRW' .
  GS_FIELDCAT-DO_SUM = 'X' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 9 .
  GS_FIELDCAT-FIELDNAME = 'ZSLAMT' .
  GS_FIELDCAT-COLTEXT = '매출금액' .
  GS_FIELDCAT-CURRENCY = 'KRW' .
  GS_FIELDCAT-JUST = 'R' .
  GS_FIELDCAT-DO_SUM = 'X' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 10 .
  GS_FIELDCAT-FIELDNAME = 'ZDCAMT' .
  GS_FIELDCAT-COLTEXT = '할인금액' .
  GS_FIELDCAT-CURRENCY = 'KRW' .
  GS_FIELDCAT-JUST = 'R' .
  GS_FIELDCAT-DO_SUM = 'X' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 11.
  GS_FIELDCAT-FIELDNAME = 'ZSALE_T' .
  GS_FIELDCAT-COLTEXT = '매출구분' .
  GS_FIELDCAT-EMPHASIZE = 'X' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 12 .
  GS_FIELDCAT-FIELDNAME = 'ZJDATE' .
  GS_FIELDCAT-COLTEXT = '판매일자' .
  GS_FIELDCAT-OUTPUTLEN = 12 .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 13 .
  GS_FIELDCAT-FIELDNAME = 'ZRET_T' .
  GS_FIELDCAT-COLTEXT = '반품구분' .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

  CLEAR : GS_FIELDCAT .
  GS_FIELDCAT-COL_POS = 14 .
  GS_FIELDCAT-FIELDNAME = 'ZRDATE' .
  GS_FIELDCAT-COLTEXT = '반품일자' .
  GS_FIELDCAT-OUTPUTLEN = 12 .
  APPEND GS_FIELDCAT TO GT_FIELDCAT .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MODIFY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM MODIFY_DATA .
  CALL FUNCTION 'GET_DOMAIN_VALUES'
  EXPORTING
    DOMNAME         = 'ZMTART13'
    TEXT            = 'X'
  TABLES
    VALUES_TAB      = LT_DD07V_MTART
  EXCEPTIONS
    VALUE_NOT_FOUND = 1
    OTHERS          = 2.

CALL FUNCTION 'GET_DOMAIN_VALUES'
  EXPORTING
    DOMNAME         = 'ZSALE_FG13'
    TEXT            = 'X'
  TABLES
    VALUES_TAB      = LT_DD07V_SALE_FG
  EXCEPTIONS
    VALUE_NOT_FOUND = 1
    OTHERS          = 2.


CALL FUNCTION 'GET_DOMAIN_VALUES'
  EXPORTING
    DOMNAME         = 'ZRET_FG13'
    TEXT            = 'X'
  TABLES
    VALUES_TAB      = LT_DD07V_RET_FG
  EXCEPTIONS
    VALUE_NOT_FOUND = 1
    OTHERS          = 2.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_INIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SET_INIT .
 " [SCREEN] 3. 주문일자  OR 배송일자
" 날짜 계산은 스크린 뜨기 전에 미리하기
LV_YEAR = SY-DATUM+0(4).
CONCATENATE LV_YEAR '0101' INTO LV_JAN_FIRST.

" 포맷팅된 문자열을 사용하여 날짜 형식으로 변환
LV_JAN_FMT = LV_JAN_FIRST.
" [조건] 4. range변수 한번 이상
RANGES GR_DATS FOR ZEDT13_100-ZJDATE .
LV_DATUM_HIGH = SY-DATUM.
" 달 마지막일 구하기
CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
  EXPORTING
    DAY_IN            = LV_DATUM_HIGH
  IMPORTING
    LAST_DAY_OF_MONTH = LV_DATUM_HIGH .

GR_DATS-SIGN = 'I' .
GR_DATS-OPTION = 'BT' .
GR_DATS-LOW = LV_DATUM_LOW .
GR_DATS-HIGH = LV_DATUM_HIGH .
APPEND GR_DATS .

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
*      PARENT                      =
      REPID                       = SY-REPID
      DYNNR                       = SY-DYNNR
*      SIDE                        = DOCK_AT_LEFT
      EXTENSION                   = 2000
*      STYLE                       =
*      LIFETIME                    = lifetime_default
*      CAPTION                     =
*      METRIC                      = 0
*      RATIO                       =
*      NO_AUTODEF_PROGID_DYNNR     =
*      NAME                        =
*    EXCEPTIONS
*      CNTL_ERROR                  = 1
*      CNTL_SYSTEM_ERROR           = 2
*      CREATE_ERROR                = 3
*      LIFETIME_ERROR              = 4
*      LIFETIME_DYNPRO_DYNPRO_LINK = 5
*      others                      = 6
      .
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
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
*&      Form  SET_DOMAIN_VALUE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SET_DOMAIN_VALUE .
 "[실행조건] 8. 제품유형명, 반품구분명 , 배송지역 명 한글로 표시하기위한 퍼폼
 IF GT_ORDER IS NOT INITIAL.

  LOOP AT GT_ORDER INTO GS_ORDER .
    READ TABLE LT_DD07V_MTART WITH KEY DOMVALUE_L = GS_ORDER-ZMTART INTO LS_DD07V .
    GS_ORDER-ZMTART_T = LS_DD07V-DDTEXT .
    MODIFY GT_ORDER FROM GS_ORDER TRANSPORTING ZMTART_T WHERE ZORDNO = GS_ORDER-ZORDNO .

  ENDLOOP .

  LOOP AT GT_ORDER INTO GS_ORDER .
    READ TABLE LT_DD07V_SALE_FG  WITH KEY DOMVALUE_L = GS_ORDER-ZSALE_FG INTO LS_DD07V .
    GS_ORDER-ZSALE_T = LS_DD07V-DDTEXT .
    MODIFY GT_ORDER FROM GS_ORDER TRANSPORTING ZSALE_T WHERE ZORDNO = GS_ORDER-ZORDNO .

  ENDLOOP .

  LOOP AT GT_ORDER INTO GS_ORDER .
    READ TABLE LT_DD07V_RET_FG WITH KEY DOMVALUE_L = GS_ORDER-ZRET_FG INTO LS_DD07V .
    GS_ORDER-ZRET_T = LS_DD07V-DDTEXT .
    MODIFY GT_ORDER FROM GS_ORDER TRANSPORTING ZRET_T WHERE ZORDNO = GS_ORDER-ZORDNO .

  ENDLOOP .
  MOVE-CORRESPONDING GT_ORDER TO GT_ORDER_PRINT .

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
  GS_LAYOUT-NO_COLEXPD = 'X' .
  GS_LAYOUT-ZEBRA = 'X' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_SORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_SORT .
  "[실행조건] 7. 회원ID별 합계와 전체금액 표시
  CLEAR GS_SORT .
  GS_SORT-FIELDNAME = 'ZIDCODE' . " ZIDCODE기준으로 소계
  GS_SORT-UP = 'X' . "오름차순
  GS_SORT-SUBTOT = 'X' . "소계
  APPEND GS_SORT TO GT_SORT .

*  CASE GS_SORT-FIELDNAME .
*    WHEN 'ZNSAMT' .
*      GS_SORT-DO_SUM = 'X' .
*    WHEN 'ZSLAMT' .
*      GS_SORT-DO_SUM = 'X' .
*    WHEN 'ZDCAMT' .
*      GS_SORT-DO_SUM = 'X' .
*  ENDCASE .
*  APPEND GS_SORT TO GT_SORT .



ENDFORM.