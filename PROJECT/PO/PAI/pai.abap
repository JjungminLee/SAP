*&---------------------------------------------------------------------*
*&  Include           ZPROJECT13_PO_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CASE OK_CODE .
    WHEN 'ADD' .
      CLEAR GS_PURCHASE .
      APPEND GS_PURCHASE TO GT_PURCHASE .
    WHEN 'DELETE' .

        DATA: LT_SELECTED_ROWS TYPE LVC_T_ROW, " 선택된 행을 저장할 표준 테이블
        LV_ROW_ID        TYPE LVC_INDEX,
        LV_LAST_ROW_ID   TYPE I.

        " 선택된 행 가져오기
        CALL METHOD GC_GRID->GET_SELECTED_ROWS
          IMPORTING
            ET_INDEX_ROWS = LT_SELECTED_ROWS.

        " 선택된 행 삭제
        LOOP AT LT_SELECTED_ROWS INTO LV_ROW_ID.
          DELETE GT_PURCHASE INDEX LV_ROW_ID.
        ENDLOOP.

        " 마지막 행 삭제
        DESCRIBE TABLE GT_PURCHASE LINES LV_LAST_ROW_ID.
        IF LV_LAST_ROW_ID > 0.
          DELETE GT_PURCHASE INDEX LV_LAST_ROW_ID.
        ENDIF.

        PERFORM REFRESH.

    WHEN 'CREATE' .
       CALL METHOD gc_grid->CHECK_CHANGED_DATA.
        IF sy-subrc <> 0.
          MESSAGE '변경된 데이터를 확인할 수 없습니다.' TYPE 'E'.
          RETURN.
        ENDIF.
  ENDCASE .

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_COMMAND INPUT.
  CASE OK_CODE .
    WHEN 'BACK' OR 'CANC' .
      LEAVE TO SCREEN 0 .
    WHEN 'EXIT' .
      LEAVE PROGRAM .
    ENDCASE .

ENDMODULE.