*&---------------------------------------------------------------------*
*& Report ZPROJECT13_PO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPROJECT13_PO.

INCLUDE ZPROJECT13_PO_CLS .
INCLUDE ZPROJECT13_PO_TOP .
INCLUDE ZPROJECT13_PO_SCR .
INCLUDE ZPROJECT13_PO_F01 .
INCLUDE ZPROJECT13_PO_PB0 .
INCLUDE ZPROJECT13_PO_PAI .

INITIALIZATION  .
  PERFORM SET_INIT .

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN .
    " 생성 시
    IF SCREEN-GROUP1 = 'M1' .
      IF P_CREATE = 'X' .
        SCREEN-ACTIVE = '1'.
      ELSE .
        SCREEN-ACTIVE = '0' .
      ENDIF .
      MODIFY SCREEN.
    ENDIF.
    "조회 시
    IF SCREEN-GROUP1 = 'M2' .
      IF P_LOOKUP = 'X' .
        SCREEN-ACTIVE = '1'.
       ELSE .
        SCREEN-ACTIVE = '0' .
      ENDIF .
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION .
  IF P_CREATE = 'X' .
    PERFORM PARAM_CHECK .
    IF GV_FOUND = 'Y' .
      CALL SCREEN 100 .
    ELSE .
      MESSAGE '해당 값이 테이블에 존재하지 않습니다.' TYPE 'E'.
    ENDIF .
  ELSEIF P_LOOKUP = 'X' .
*    PERFORM GET_DATA .
    CALL SCREEN 200 .
  ENDIF .