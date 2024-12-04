*&---------------------------------------------------------------------*
*&  Include           ZPROJECT13_BP_PB0
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
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0200 OUTPUT.
  SET PF-STATUS 'STATUS_0200'.
  SET TITLEBAR 'T200'.
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
    IF P_KTOKK = '3000'  .
       PERFORM FIELD_CATALOG_PERSON .
    ELSE .
      PERFORM FIELD_CATALOG_COMPANY .
    ENDIF .
    IF P_KTOKK2 = '3000'.
      PERFORM FIELD_CATALOG_PERSON_DISPLAY .
    ELSE .
      PERFORM FIELD_CATALOG_COMPANY_DISPLAY .
    ENDIF .
    PERFORM ALV_LAYOUT .
    PERFORM CALL_ALV .
  ELSE .
    PERFORM REFRESH .
  ENDIF .
ENDMODULE.