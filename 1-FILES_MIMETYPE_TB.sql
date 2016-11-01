/*
connect to FILEUSER on remote database
*/
CREATE TABLE FILES_MIMETYPE_TB
(
  ID              NUMBER(10)                    NOT NULL,
  NAME            VARCHAR2(200 CHAR)            NOT NULL,
  MIME_TYPE       VARCHAR2(200 CHAR)            NOT NULL,
  FILE_EXTENSION  VARCHAR2(30 CHAR)             NOT NULL,
  MORE_DETAILES   VARCHAR2(200 CHAR)
)
/
