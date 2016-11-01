/*
connect to FILEUSER on remote database
*/
CREATE TABLE FILES_TB
(
  ID            NUMBER                          NOT NULL,
  MIME_TYPE     VARCHAR2(200 CHAR)              NOT NULL,
  FILE_NAME     VARCHAR2(100 CHAR)              NOT NULL,
  FILE_SIZE     NUMBER,
  FILE_CONTENT  BLOB                            NOT NULL,
  TABLE_NAME    VARCHAR2(30 CHAR)               NOT NULL,
  TABLE_ID      NUMBER                          NOT NULL

)
/

CREATE SEQUENCE FILES_TB_SEQ
  START WITH 1
  MAXVALUE 999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;
/

CREATE OR REPLACE TRIGGER FILES_TB_BIU
 BEFORE INSERT OR UPDATE
 ON FILES_TB
 FOR EACH ROW
DECLARE
  l_ext VARCHAR2(10);
BEGIN
 
  IF INSERTING THEN
     :NEW.ID := FILES_TB_SEQ.NEXTVAL;
  END IF;

  l_ext := Substr(:NEW.FILE_NAME,Instr(:NEW.FILE_NAME,'.',-1));
  
  Select  MIME_TYPE
  Into   :NEW.MIME_TYPE
  From    FILES_MIMETYPE_TB
  Where   FILE_EXTENSION = Lower(l_ext);

END;
/

