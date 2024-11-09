*&---------------------------------------------------------------------*
*& Report ZEDR13_HW001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR13_HW001 MESSAGE-ID ZMED13_100.
* [실행조건] 10. INCLUDE TOP, SCR, F01, PBO, PAI반드시 사용
INCLUDE ZEDR13_HW001_TOP .
INCLUDE ZEDR13_HW001_SCR .
INCLUDE ZEDR13_HW001_F01 .
INCLUDE ZEDR13_HW001_PB0 .
INCLUDE ZEDT13_HW001_PAI .


"[실행조건] 5. intial 사용
INITIALIZATION  .
  PERFORM SET_INIT .

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN .
    " [SCREEN] #1. 주문내역, 배송내역 라디오버튼 클릭마다 주문일자 , 배송날짜 다르게 표기하게
    IF SCREEN-GROUP1 = 'M1' .
      IF P_RORD = 'X' .
        SCREEN-ACTIVE = '1'.
        IF S_ZJDATE[] IS INITIAL.
          S_ZJDATE-SIGN = 'I'.
          S_ZJDATE-OPTION = 'BT'.
          S_ZJDATE-HIGH = LV_DATUM_HIGH.
          S_ZJDATE-LOW = LV_JAN_FIRST.
          APPEND S_ZJDATE.
       ENDIF .
      ELSE .
        SCREEN-ACTIVE = '0' .
      ENDIF .
      MODIFY SCREEN.
    ENDIF.
    IF SCREEN-GROUP1 = 'M2' .
      IF P_RDELV = 'X' .
        SCREEN-ACTIVE = '1'.
        IF S_ZDDATE[] IS INITIAL.
          S_ZDDATE-SIGN = 'I'.
          S_ZDDATE-OPTION = 'BT'.
          S_ZDDATE-HIGH = LV_DATUM_HIGH.
          S_ZDDATE-LOW = LV_JAN_FIRST.
          APPEND S_ZDDATE.
        ENDIF .
       ELSE .
        SCREEN-ACTIVE = '0' .
      ENDIF .
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.


" [조건] 5. START-OF-SELEC~ 사용
START-OF-SELECTION .
  " [SCREEN] 4. 주문번호 또는 회원 ID가 필수적으로 입력되어야 한다. 둘다 입력이 되지 않으면 ERROR를 뿌리며 레포트가 실행되지 않는다
  " [SCREEN] 5. 주문번호 입력 시에는 주문일자 입력하지 않아도 되지만 회원ID  입력시에는 주문일자 반드시 입력
  IF ( P_ZID IS NOT INITIAL ) AND ( S_ZORDNO IS INITIAL )  AND ( S_ZJDATE IS INITIAL ) .
    MESSAGE E001 .
  ENDIF .
  IF ( S_ZORDNO IS INITIAL ) AND  ( P_ZID IS INITIAL ) .
    MESSAGE E000 .
  ENDIF .

  IF P_RORD = 'X' .
    PERFORM GET_DATA_ORDER .
    PERFORM MODIFY_DATA .
    CALL SCREEN 100 .
  ENDIF.
  IF P_RDELV = 'X' .
    PERFORM GET_DATA_DELIVERY .
    PERFORM MODIFY_DATA .
    CALL SCREEN 200 .
  ENDIF.