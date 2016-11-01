/*
connect to own user on PROD database
*/
CREATE OR REPLACE FORCE VIEW MYTABLEBLOB
AS
SELECT      ID
           ,MIME_TYPE
           ,FILE_NAME
           ,dbms_lob.getlength(FILE_CONTENT) FILE_SIZE
           ,TABLE_NAME
           ,TABLE_ID
           ,FILE_CONTENT
FROM(
    SELECT  ID
           ,MIME_TYPE
           ,FILE_NAME
           ,TABLE_NAME
           ,TABLE_ID
           ,GETBLOB_VIA_DBLINK('UDFILES_DBLINK','FILEUSER.FILES_TB','file_content',rowid,q'[TABLE_NAME = 'MYTABLE']') FILE_CONTENT
    FROM    FILEUSER.FILES_TB@UDFILES.SAIPA.IR
    Where  TABLE_NAME = 'MYTABLE'
    )
/