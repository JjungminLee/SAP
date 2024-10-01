REPORT ZEDR13_PRACTICE002.

DATA : GS_STUDENT LIKE ZEDT13_001.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.
DATA : GS_MAJOR LIKE ZEDT13_002.
DATA : GT_MAJOR LIKE TABLE OF GS_MAJOR.

DATA : BEGIN OF GS_GRADE.
  INCLUDE TYPE ZEDT13_003.
DATA : ZKNAME TYPE ZEDT13_001-ZKNAME,
      ZTEL   TYPE ZEDT13_001-ZTEL,
      ZMOVE  TYPE STRING,
      ZWARN  TYPE STRING,
      END OF GS_GRADE.
DATA : GT_GRADE LIKE TABLE OF GS_GRADE.

DATA : GV_BOYSUM TYPE I. " 남자 등록금 총합
DATA : GV_GIRLSUM TYPE I. "여자 등록금 총합
DATA : GV_MOVE , GV_WARN . " 학사 경고, 전과 여부
DATA : GV_KNAME LIKE ZEDT13_001-ZKNAME . " 출력시 -> 이름 저장용도
DATA : GV_START , GV_END . " ZCODE 시작과 끝 여부

DATA : BEGIN OF GS_LINE ,
  COL1 TYPE C,
  END OF GS_LINE .

DATA : GT_LINE LIKE TABLE OF GS_LINE .
DATA : GV_LINE TYPE I . " 테이블 내 현재 인덱스를 가져오기


SELECT * FROM ZEDT13_001 INTO CORRESPONDING FIELDS OF TABLE GT_STUDENT.
SELECT * FROM ZEDT13_002 INTO CORRESPONDING FIELDS OF TABLE GT_MAJOR.
SELECT * FROM ZEDT13_003 INTO CORRESPONDING FIELDS OF TABLE GT_GRADE.


LOOP AT GT_GRADE INTO GS_GRADE.
 " 성적을 한번도 받지 않은 학생은 삭제하기
  LOOP AT GT_GRADE INTO GS_GRADE WHERE ZGRADE IS INITIAL.
    READ TABLE GT_GRADE WITH KEY ZCODE = GS_GRADE-ZCODE TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      DELETE GT_GRADE INDEX sy-tabix.
    ENDIF.
  ENDLOOP.

  AT NEW ZCODE.
    GV_START = 'X' .
    CLEAR: GV_MOVE, GV_WARN.
  ENDAT.
  IF GV_START = 'X' .
    READ TABLE GT_MAJOR WITH KEY ZCODE = GS_GRADE-ZCODE INTO GS_MAJOR. "전과 여부 확인
    IF SY-SUBRC = 0.
      IF GS_MAJOR-ZMAJOR NE GS_GRADE-ZMAJOR.
        GV_MOVE = 'X'.
      ENDIF.
    ENDIF.
  ENDIF .

  IF GS_GRADE-ZGRADE = 'F' OR GS_GRADE-ZGRADE = 'D'. " 학사 경고 여부 확인
    GV_WARN = 'X'.
  ENDIF.

  AT END OF ZCODE.
    GV_END = 'X' .

  ENDAT.

  IF GV_END = 'X' .
    IF GV_MOVE = 'X'.
      GS_GRADE-ZMOVE = '전과학생'.
    ENDIF.
    IF GV_WARN = 'X'.
      GS_GRADE-ZWARN = '학사경고'.
    ENDIF.
    MODIFY GT_GRADE FROM GS_GRADE INDEX SY-TABIX .

  ENDIF .

ENDLOOP.

* 중복 제거 및 정렬
DELETE ADJACENT DUPLICATES FROM GT_GRADE COMPARING ZCODE  .
BREAK-POINT .

LOOP AT GT_GRADE INTO GS_GRADE .

  MOVE-CORRESPONDING GS_GRADE TO GS_STUDENT .
  READ TABLE GT_STUDENT INTO GS_STUDENT INDEX SY-TABIX .
  IF SY-SUBRC = 0.
    IF GS_STUDENT-ZCODE = GS_GRADE-ZCODE .
      GS_LINE-COL1 = SY-TABIX .
      APPEND GS_LINE TO GT_LINE .
    ENDIF .
  ENDIF.
ENDLOOP .

" 인터널 테이블 내 숫자를 읽어오기
DESCRIBE TABLE GT_LINE LINES GV_LINE .

LOOP AT GT_GRADE INTO GS_GRADE.
  CLEAR GS_STUDENT.
  AT FIRST.
      WRITE :/ '---------------------------------------------------------------------------------'.
      WRITE :/ '|   학생코드   |     이름     | 학사경고대상   |  전화번호     |   적요    |'.
      WRITE :/ '---------------------------------------------------------------------------------'.
  ENDAT.
  MOVE-CORRESPONDING GS_GRADE TO GS_STUDENT .
  READ TABLE GT_STUDENT INTO GS_STUDENT INDEX SY-TABIX .
  IF SY-SUBRC = 0.
    GV_KNAME = GS_STUDENT-ZKNAME.
    GS_GRADE-ZTEL = GS_STUDENT-ZTEL.
    IF GS_STUDENT-ZCODE = GS_GRADE-ZCODE .
      IF GS_GRADE-ZWARN = '학사경고' .
        WRITE :/ '| ', GS_GRADE-ZCODE, ' | ', GV_KNAME, ' | ', GS_GRADE-ZWARN, '    |', GS_GRADE-ZTEL, '| ', GS_GRADE-ZMOVE, ' |'.
        WRITE :/ '---------------------------------------------------------------------------------'.
      ELSE .
        WRITE :/ '| ', GS_GRADE-ZCODE, ' | ', GV_KNAME, ' | ', GS_GRADE-ZWARN, '            | ','               | '  , GS_GRADE-ZMOVE, ' |'.
        WRITE :/ '---------------------------------------------------------------------------------'.
      ENDIF .
    ENDIF .
  ENDIF.
  AT LAST.
    WRITE :/ '--------------------------------------------------------------------------'.
  ENDAT.

ENDLOOP.



" 남자 등록금 총합 및 여자 등록금 총합 출력
GV_BOYSUM = 0.
GV_GIRLSUM = 0.

" DO 구문을 사용해서 GV_LINE 만큼 반복
DO GV_LINE TIMES.

  READ TABLE GT_STUDENT INTO GS_STUDENT INDEX sy-index.
  IF sy-subrc = 0.
    " 성별에 따라 등록금을 합산
    READ TABLE GT_MAJOR WITH KEY ZCODE = GS_STUDENT-ZCODE INTO GS_MAJOR.
    IF sy-subrc = 0.
      IF GS_STUDENT-ZGENDER = 'M'.
        GV_BOYSUM = GV_BOYSUM + GS_MAJOR-ZSUM.
      ELSEIF GS_STUDENT-ZGENDER = 'F'.
        GV_GIRLSUM = GV_GIRLSUM + GS_MAJOR-ZSUM.
      ENDIF.
    ENDIF.
  ENDIF.
ENDDO.
GV_BOYSUM = GV_BOYSUM * 100 .
GV_GIRLSUM = GV_GIRLSUM * 100 .

WRITE :/ '남학생 등록금 총합  ', GV_BOYSUM , ' 원'.
WRITE :/ '여학생 등록금 총합  ', GV_GIRLSUM , ' 원'.