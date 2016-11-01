/*
connect to own user on PROD database and grant to other schemas
*/
CREATE OR REPLACE PROCEDURE DML_BLOB_VIA_DBLINK(p_request VARCHAR2,p_item_name VARCHAR2, p_table_name VARCHAR2,
                                                p_table_id NUMBER)

IS
  l_id  NUMBER;
  l_file_id NUMBER;
  l_filecontent BLOB;
  l_filename VARCHAR2(400);
  l_mimetype VARCHAR2(500);
  l_session  NUMBER;
  
BEGIN
    
    --Insert temp table  
    If p_request IN ('CREATE','SAVE') THEN
        
        
        Select ID, FILENAME, BLOB_CONTENT,nv ('SESSION'), MIME_TYPE
        Into   l_file_id, l_filename, l_filecontent, l_session, l_mimetype
        From   apex_application_temp_files
        Where  NAME = p_item_name;
       
        /*
        Why do we have to insert into temp table on PROD databse before insert into remote table?
        If wants to insert to remote blob table directly from apex_application_temp_files that will occur below error:
        ORA-02069: global_names parameter must be set to TRUE for this operation

        In this situation you must change the oracle parameter but
        sometimes the DBA don’t want to change this parameter for any reason 
        and we must insert into temp table before insert into remote table
        */ 
        
        Insert Into TEMPMBLOB(FILE_ID, FILENAME, BLOB_CONTENT, SESSION_ID)
            Values(l_file_id, l_filename, l_filecontent, l_session) Returning ID Into l_id;
         
    End If;          
  
    If p_request = 'DELETE' Then
        
        Delete FILEUSER.FILES_TB@UDFILES_DBLINK
        Where  TABLE_NAME = p_table_name
        And    TABLE_ID = p_table_id;
        
    
    ElsIf p_request = 'CREATE' Then
    
      Insert Into FILEUSER.FILES_TB@UDFILES_DBLINK(FILE_NAME, FILE_CONTENT, TABLE_NAME, TABLE_ID)
          Select FILENAME, BLOB_CONTENT, P_TABLE_NAME, P_TABLE_ID
          From   TEMPMBLOB
          Where  ID = l_id  
          And    FILE_ID = l_file_id
          And    SESSION_ID = l_session; 
            
        
    ElsIf p_request = 'SAVE' Then

        Update FILEUSER.FILES_TB@UDFILES_DBLINK Set 
                                                      FILE_CONTENT = (Select BLOB_CONTENT 
                                                                      From   TEMPMBLOB
                                                                      Where  ID = l_id  
                                                                      And    FILE_ID = l_file_id
                                                                      And    SESSION_ID = l_session),
                                                      FILE_NAME = l_filename
        Where  TABLE_NAME = p_table_name
        And    TABLE_ID = p_table_id;
    
    End If;
    
    --Delete temp table
    If p_request IN ('CREATE','SAVE') THEN
        Delete TEMPMBLOB
        Where  ID = l_id  
        And    FILE_ID = l_file_id
        And    SESSION_ID = l_session;
    End If;
    
    Commit;
    
END DML_BLOB_VIA_DBLINK;
/