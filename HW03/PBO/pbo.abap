*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.
  SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SET_ALV  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE SET_ALV OUTPUT.
" [실행조건] 11 . CREATE OBJECT, CALL_ALV는 하나의 퍼폼만 사용, SCREEN 100,200 재사용
  PERFORM CREATE_OBJECT .
   IF P_RORD = 'X' .
    PERFORM FIELD_CATALOG_ORDER .
   ELSE .
     PERFORM FIELD_CATALOG_DELIVERY .
   ENDIF .
   PERFORM ALV_SORT .
   PERFORM ALV_LAYOUT .
   PERFORM SET_DOMAIN_VALUE .
  PERFORM CALL_ALV .
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0200 OUTPUT.
  SET PF-STATUS 'STAUS_0200'.
  SET TITLEBAR 'T200'.
ENDMODULE.