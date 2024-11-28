*&---------------------------------------------------------------------*
*&  Include           ZPROJECT13_BP_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE OK_CODE .
    WHEN 'ADD' .
      CLEAR GS_SUPPLIER .
      APPEND GS_SUPPLIER TO GT_SUPPLIER .
    WHEN 'SAVE' .
      LOOP AT GT_SUPPLIER INTO GS_SUPPLIER .

        MOVE-CORRESPONDING GS_SUPPLIER  TO GS_SUPPLIER_SAVE .
        MOVE-CORRESPONDING GS_SUPPLIER  TO GS_COUNTRY_CODE_SAVE .

        "유저가 입력한 회사코드 그대로
        GS_COUNTRY_CODE_SAVE-ZLFB1_BUKRS = P_BUKRS .
        GS_SUPPLIER_SAVE-ZLFA1_KTOKK = P_KTOKK .

        "자동채번
        DATA : LV_ZLFA1_LIFNR TYPE ZEDT13_201-ZLFA1_LIFNR .
        DATA : LV_ZLFA1_NUM TYPE P LENGTH 11 .
        DATA : LV_MAX_ZLFA1_LIFNR TYPE ZEDT13_201-ZLFA1_LIFNR .

        DATA : LV_ZLFB1_LIFNR TYPE ZEDT13_202-ZLFB1_LIFNR .
        DATA : LV_MAX_ZLFB1_LIFNR TYPE ZEDT13_202-ZLFB1_LIFNR .
        DATA : LV_ZLFB1_NUM TYPE P LENGTH 11 .

        SELECT MAX( ZLFA1_LIFNR ) INTO LV_MAX_ZLFA1_LIFNR FROM ZEDT13_201.
        SELECT MAX( ZLFB1_LIFNR ) INTO LV_MAX_ZLFB1_LIFNR FROM ZEDT13_202.

        IF LV_MAX_ZLFA1_LIFNR IS INITIAL .
          LV_MAX_ZLFA1_LIFNR = '0000000000'.
        ENDIF .

        IF LV_MAX_ZLFB1_LIFNR IS INITIAL .
          LV_MAX_ZLFB1_LIFNR = '0000000000'.
        ENDIF .

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = LV_MAX_ZLFA1_LIFNR
        IMPORTING
          output = LV_MAX_ZLFA1_LIFNR.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = LV_MAX_ZLFB1_LIFNR
        IMPORTING
          output = LV_MAX_ZLFB1_LIFNR .

        "문자열을 정수로 변환
        LV_ZLFA1_NUM = LV_MAX_ZLFA1_LIFNR .
        LV_ZLFB1_NUM = LV_MAX_ZLFB1_LIFNR .

        "숫자 1증가
        LV_ZLFA1_NUM = LV_ZLFA1_NUM + 1 .
        LV_ZLFB1_NUM = LV_ZLFB1_NUM + 1 .

        "문자열로 변환
        LV_ZLFA1_LIFNR = LV_ZLFA1_NUM .
        LV_ZLFB1_LIFNR = LV_ZLFB1_NUM .


        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = LV_ZLFA1_LIFNR
        IMPORTING
          output = LV_ZLFA1_LIFNR.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = LV_ZLFB1_LIFNR
        IMPORTING
          output = LV_ZLFB1_LIFNR .

        GS_SUPPLIER_SAVE-ZLFA1_LIFNR  =  LV_ZLFA1_LIFNR  .
        GS_COUNTRY_CODE_SAVE-ZLFB1_LIFNR = LV_ZLFB1_LIFNR .

        APPEND GS_SUPPLIER_SAVE TO GT_SUPPLIER_SAVE .
        APPEND GS_COUNTRY_CODE_SAVE TO GT_COUNTRY_CODE_SAVE .

      ENDLOOP .

      MODIFY ZEDT13_201 FROM TABLE GT_SUPPLIER_SAVE .
      MODIFY ZEDT13_202 FROM TABLE GT_COUNTRY_CODE_SAVE .

      IF SY-SUBRC = 0 .
        MESSAGE '저장성공' TYPE 'I' .
      ELSE .
        MESSAGE '저장실패' TYPE 'I' .
      ENDIF .

  ENDCASE .

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0200 INPUT.

ENDMODULE.

MODULE EXIT_COMMAND INPUT.
  CASE OK_CODE .
    WHEN 'BACK' OR 'CANC' .
      LEAVE TO SCREEN 0 .
    WHEN 'EXIT' .
      LEAVE PROGRAM .
    ENDCASE .

ENDMODULE.