*&---------------------------------------------------------------------*
*& Report ZPROJECT13_BP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPROJECT13_BP MESSAGE-ID ZMED13_100 .
INCLUDE ZPROJECT_13_BP_CLS .
INCLUDE ZPROJECT13_BP_TOP .
INCLUDE ZPROJECT13_BP_SCR .
INCLUDE ZPROJECT13_BP_F01 .
INCLUDE ZPROJECT13_BP_PB0 .
INCLUDE ZPROJECT13_BP_PAI .

" @TODO
" 지급조건 잘리는문제
" 저장후 인터널테이블 전부 삭제하기 (생성용 인터널 테이블)
" SEARCH HELP랑 POSSIBLE ENTRY 만들기
" 조회부분 진행하기

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
    CALL SCREEN 100 .
  ENDIF .