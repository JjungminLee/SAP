*&---------------------------------------------------------------------*
*&  Include           ZPROJECT13_GR_PBO
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
    IF P_CREATE = 'X'.
      PERFORM FIELD_CATALOG .
    ELSE .
      PERFORM FIELD_CATALOG_DISPLAY .
    ENDIF .
    PERFORM ALV_LAYOUT .
    PERFORM CALL_ALV .
  ELSE .
    PERFORM REFRESH .
  ENDIF .
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0200 OUTPUT.
  SET PF-STATUS 'STATUS_0200'.
  SET TITLEBAR 'T200'.
ENDMODULE.