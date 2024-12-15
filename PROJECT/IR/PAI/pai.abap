*&---------------------------------------------------------------------*
*&  Include           ZPROJECT13_IR_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE OK_CODE .
    WHEN 'CREATE' .
       CALL METHOD gc_grid->CHECK_CHANGED_DATA.
      IF sy-subrc <> 0.
          MESSAGE '변경된 데이터를 확인할 수 없습니다.' TYPE 'E'.
          RETURN.
      ENDIF.

      DATA : LV_SIZE TYPE I .
      LOOP AT GT_PURCHASE INTO GS_PURCHASE .
          IF GS_PURCHASE-L_CHECK = 'X' .
            APPEND GS_PURCHASE TO GT_PURCHASE_SELECT .
          ENDIF .
      ENDLOOP .
      DESCRIBE TABLE GT_PURCHASE_SELECT LINES LV_SIZE .
      "[송장 헤더]

      "송장문서번호 처리
      IF LV_SIZE > 0 .

        DATA: lv_last_value TYPE ZEDT13_208-ZRBKP_BELNR, " ZMKPF_MBLNR의 데이터 타입 (CHAR 타입)
          lv_next_value TYPE ZEDT13_208-ZRBKP_BELNR, " 결과값 저장
          lv_last_value_num TYPE P ,        " 숫자로 변환된 값
          lv_next_value_num TYPE P .        " 다음 값을 계산하기 위한 숫자 값

        " 테이블에서 마지막 값을 가져오기
        SELECT MAX( ZRBKP_BELNR )
          INTO lv_last_value
          FROM zedt13_208 .

        " 조건 처리: 테이블이 비어있거나 5999999999를 초과한 경우
        IF lv_last_value IS INITIAL.
          lv_next_value = '5000000000'.
        ELSE.
          " CHAR -> 숫자로 변환
          lv_last_value_num = lv_last_value.

          " 최대값 제한 확인
          IF lv_last_value_num >= 5999999999.
            WRITE: / '값이 범위를 초과했습니다. 더 이상 추가할 수 없습니다.'.
            EXIT.
          ELSE.
            " 다음 값 계산
            lv_next_value_num = lv_last_value_num + 1.

            " 숫자 -> CHAR로 변환
            lv_next_value = lv_next_value_num.
          ENDIF.
        ENDIF.
         DATA : lv_year TYPE C LENGTH 4 .
        DATA : lv_date TYPE sy-datum.

        " 현재 시스템 날짜 가져오기
        lv_date = sy-datum.

        " 연도만 추출
        lv_year = lv_date+0(4).
        GS_HEADER-ZMSEG_MJAHR = LV_YEAR .
        GS_HEADER-ZRBKP_BELNR = lv_next_value .
        GS_HEADER-ZRBKP_BUDAT = SY-DATUM .
        INSERT ZEDT13_208 FROM GS_HEADER .



        DATA : LV_MWSKZ_CHECK TYPE C .
        LV_MWSKZ_CHECK = 'N' .
        "송장 아이템 전표 자동채번
         DATA : LV_ZBSIK_BELNR TYPE ZEDT13_209-ZBSIK_BELNR .
         DATA : LV_BELNR_NUM TYPE P LENGTH 10 .
         DATA : LV_MAX_ZBSIK_BELNR TYPE ZEDT13_204-ZEKKO_EBELN .

         SELECT MAX( ZBSIK_BELNR ) INTO LV_MAX_ZBSIK_BELNR
                 FROM ZEDT13_209.

         IF LV_MAX_ZBSIK_BELNR IS INITIAL .
                 LV_MAX_ZBSIK_BELNR = '0000000000'.
         ENDIF .

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                 EXPORTING
                  input  = LV_MAX_ZBSIK_BELNR
                 IMPORTING
                  output = LV_MAX_ZBSIK_BELNR .

         "문자열을 정수로
         LV_BELNR_NUM = LV_MAX_ZBSIK_BELNR  .

        "[송장 아이템]
        LOOP AT GT_PURCHASE_SELECT INTO GS_PURCHASE .
           IF GS_PURCHASE-L_CHECK = 'X' .
              IF GS_PURCHASE-ZBSIK_MWSKZ =  'V1' OR GS_PURCHASE-ZBSIK_MWSKZ = 'V2' OR
                  GS_PURCHASE-ZBSIK_MWSKZ = 'V3' OR GS_PURCHASE-ZBSIK_MWSKZ = 'V4' OR
                  GS_PURCHASE-ZBSIK_MWSKZ = 'V5' .
                  LV_MWSKZ_CHECK = 'Y' .
              ENDIF .
              DATA : LV_BUKRS TYPE ZEDT13_204-ZEKKO_BUKRS .
              DATA : LV_EBELN TYPE ZEDT13_205-ZEKKPO_EBELN .
              DATA : LV_LIFNR TYPE ZEDT13_204-ZEKKO_LIFNR .
              LV_BUKRS = GS_PURCHASE-ZEKKO_BUKRS .
              LV_EBELN = GS_PURCHASE-ZEKKPO_EBELN .
              LV_LIFNR = GS_PURCHASE-ZEKKO_LIFNR .

              PERFORM INSERT_DEBIT USING LV_BUKRS LV_EBELN LV_LIFNR
                    lv_next_value
                     LV_BELNR_NUM LV_ZBSIK_BELNR . "차변
              PERFORM INSERT_CREDIT USING LV_BUKRS LV_EBELN LV_LIFNR
                    lv_next_value LV_BELNR_NUM LV_ZBSIK_BELNR . "대변
              PERFORM INSERT_TAX USING LV_BUKRS LV_EBELN LV_LIFNR
                 lv_next_value LV_BELNR_NUM LV_ZBSIK_BELNR . "부가가치세
          ENDIF .
        ENDLOOP .
         IF LV_MWSKZ_CHECK = 'N' .
           MESSAGE '세금코드를 정확히 입력하시오' TYPE 'I' .
         ELSE .
           INSERT ZEDT13_209 FROM TABLE GT_ITEM .

            IF SY-SUBRC = 0 .
                MESSAGE '송장처리 성공' TYPE 'I' .
            ELSE .
                MESSAGE '성징처리 실패' TYPE 'I' .
            ENDIF .
         ENDIF .


         "[지급테이블]


    ENDIF .

  ENDCASE .

ENDMODULE.

MODULE EXIT_COMMAND INPUT.
  CASE OK_CODE .
    WHEN 'BACK' OR 'CANC' .
      LEAVE TO SCREEN 0 .
    WHEN 'EXIT' .
      LEAVE PROGRAM .
    ENDCASE .

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0200 INPUT.
  CASE OK_CODE .
    WHEN 'CANCEL' .

      " 선택된 행 가져오는 코드
     DATA: lt_selected_rows TYPE lvc_t_row,
          ls_selected_row  TYPE lvc_s_row ,
          lv_index         TYPE lvc_index .
     CALL METHOD gc_grid->get_selected_rows
          IMPORTING
            et_index_rows = lt_selected_rows.


     LOOP AT lt_selected_rows INTO ls_selected_row.
       lv_index = ls_selected_row-index .
       CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
       EXPORTING
         input  = lv_index
       IMPORTING
         output = lv_index .

       READ TABLE gt_item INTO gs_item INDEX lv_index.
       append gs_item to gt_item_del .

     ENDLOOP.

     "선택된 행들이 모인 인터널테이블을 zedt13_209에서 삭제
     loop at gt_item_del into gs_item .

       DATA : LV_BELNR_L TYPE P .
       DATA : LV_BELNR_TAX TYPE P .
       DATA : LV_BELNR_H TYPE P .
       LV_BELNR_L = gs_item-ZBSIK_BELNR - 2 .
       LV_BELNR_H = gs_item-ZBSIK_BELNR - 1 .
       LV_BELNR_TAX = gs_item-ZBSIK_BELNR .
       DATA : LV_BELNR_L_TO_C TYPE ZEDT13_209-ZBSIK_BELNR .
       DATA : LV_BELNR_H_TO_C TYPE ZEDT13_209-ZBSIK_BELNR .
       DATA : LV_BELNR_TAX_TO_C TYPE ZEDT13_209-ZBSIK_BELNR .
       LV_BELNR_L_TO_C = LV_BELNR_L .
       LV_BELNR_H_TO_C = LV_BELNR_H .
       LV_BELNR_TAX_TO_C = LV_BELNR_TAX .
       CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = LV_BELNR_L_TO_C
        IMPORTING
          output = LV_BELNR_L_TO_C .

       CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = LV_BELNR_TAX_TO_C
        IMPORTING
          output = LV_BELNR_TAX_TO_C .

       CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  =  LV_BELNR_H_TO_C
        IMPORTING
          output =  LV_BELNR_H_TO_C .



       delete from zedt13_209
       where ZBSIK_BELNR = LV_BELNR_L_TO_C  .

       delete from zedt13_209
       where ZBSIK_BELNR = LV_BELNR_H_TO_C  .

       delete from zedt13_209
       where ZBSIK_BELNR = LV_BELNR_TAX_TO_C  .
     endloop .
     if sy-subrc = 0 .
       message '송장취소  성공' type 'I' .
     endif .


  ENDCASE .

ENDMODULE.