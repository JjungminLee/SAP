*&---------------------------------------------------------------------*
*&  Include           ZPROJECT13_GR_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CASE OK_CODE .
    WHEN 'GR_BTN'.
      " [GR헤더] 삽입 로직
      " LT_PURCHASE_SAVE에 데이터가 1개이상이면 전표가 생성된다.
      " 입고문서번호는 자동채번 (5000000000부터 시작)
      "회계연도는 전기일의 연도
      "증빙일,전기일 같이 가져감
      " 전표유형은 WE고정
      CALL METHOD gc_grid->CHECK_CHANGED_DATA.
      IF sy-subrc <> 0.
          MESSAGE '변경된 데이터를 확인할 수 없습니다.' TYPE 'E'.
          RETURN.
      ENDIF.


      DATA : LV_SIZE TYPE I .
      DESCRIBE TABLE GT_PURCHASE_SELECT LINES LV_SIZE .

      IF LV_SIZE > 0 .
        "입고문서번호
        DATA: lv_last_value TYPE ZEDT13_207-zmseg_mblnr, " ZMKPF_MBLNR의 데이터 타입 (CHAR 타입)
          lv_next_value TYPE ZEDT13_207-zmseg_mblnr, " 결과값 저장
          lv_last_value_num TYPE P ,        " 숫자로 변환된 값
          lv_next_value_num TYPE P .        " 다음 값을 계산하기 위한 숫자 값

        " 테이블에서 마지막 값을 가져오기
        SELECT MAX( zmseg_mblnr )
          INTO lv_last_value
          FROM zedt13_207.

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

        GS_HEADER-ZMKPF_MBLNR = lv_next_value.
        GS_HEADER-ZMSEG_MJAHR = lv_year .
        GS_HEADER-ZMKPF_BLART = 'WE' .
        GS_HEADER-ZMKPF_BLDAT = lv_date .
        GS_HEADER-ZMKPF_BUDAT = lv_date .
        INSERT ZEDT13_206 FROM GS_HEADER .
        "차대변을 같이 넣어야함

        " [GR아이템] 삽입 로직
        "GT_PURCHASE_SELECT 내의 데이터를 207번 테이블에 넣는다
        LOOP AT GT_PURCHASE_SELECT INTO GS_PURCHASE .

          PERFORM INSERT_DEBIT USING LV_YEAR LV_NEXT_VALUE SY-TABIX . "차변
          PERFORM INSERT_CREDIT USING LV_YEAR LV_NEXT_VALUE SY-TABIX . "대변

        ENDLOOP .

        INSERT ZEDT13_207 FROM TABLE GT_ITEM .
        IF SY-SUBRC = 0 .
          MESSAGE '입고처리 성공' TYPE 'I' .
        ELSE .
          MESSAGE '입고처리 실패' TYPE 'I' .
        ENDIF .


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

     "선택된 행들이 모인 인터널테이블을 zedt13_207에서 삭제
     loop at gt_item_del into gs_item .
       DATA : LV_BELNR_L TYPE P .
       LV_BELNR_L = gs_item-ZMSEG_BELNR - 1 .
       DATA : LV_BELNR_L_TO_C TYPE ZEDT13_207-ZMSEG_BELNR .
       LV_BELNR_L_TO_C = LV_BELNR_L .
       delete from zedt13_207 where ZMSEG_BELNR = gs_item-ZMSEG_BELNR .
       delete from zedt13_207 where ZMSEG_BELNR = LV_BELNR_L_TO_C .
     endloop .
     if sy-subrc = 0 .
       message '입고취소 성공' type 'I' .
     endif .


  ENDCASE .

ENDMODULE.