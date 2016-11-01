/*
connect to own user on PROD database  and grant to other schemas
*/
CREATE GLOBAL TEMPORARY TABLE BLOB_TEMP
(
  FILE_CONTENT  BLOB
)
ON COMMIT PRESERVE ROWS
RESULT_CACHE (MODE DEFAULT)
NOCACHE;
