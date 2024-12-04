
*&  Include           ZPROJECT13_PO_PB0
*&---------------------------------------------------------------------*
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
  IF GC_DOCKING IS INITIAL .
    PERFORM CREATE_OBJECT .
    PERFORM CLASS_EVENT .
    PERFORM FIELD_CATALOG .
    PERFORM ALV_LAYOUT .
    PERFORM CALL_ALV .
  ELSE .
    PERFORM REFRESH .
  ENDIF .
ENDMODULE.