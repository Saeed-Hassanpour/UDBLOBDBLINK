/*
connect to own user on PROD database  and grant to other schemas
*/
CREATE OR REPLACE FUNCTION GETBLOB_VIA_DBLINK
(P_DBLINK IN VARCHAR2
,P_TABLE  IN VARCHAR2
,P_COL    IN VARCHAR2
,P_ROWID  IN UROWID
,P_WHERE  IN VARCHAR2 DEFAULT NULL
)

RETURN BLOB
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  l_return_blob BLOB;
  l_sql VARCHAR2(1000);
  l_where VARCHAR2(1000);
  
BEGIN
 
 IF P_WHERE IS NOT NULL THEN
    l_where :=' And '||P_WHERE;
 ELSE
    l_where :=' And 1=1';   
 END IF;
  
  
  l_sql := 'Insert /*+ NOLOGGING */ into BLOB_TEMP select '||P_COL||' from '||P_TABLE||'@'||P_DBLINK||' where rowid=:P_ROWID'||l_where;
  EXECUTE IMMEDIATE l_sql USING P_ROWID;
  
  SELECT FILE_CONTENT INTO l_return_blob FROM BLOB_TEMP;
  DELETE /*+ NOLOGGING */ FROM BLOB_TEMP;
  COMMIT;
  
  RETURN l_return_blob;
  
END GETBLOB_VIA_DBLINK;
/