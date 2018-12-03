CREATE PROCEDURE [dbo].[spContactsUpsert]
	@CompanyID      INT          
	,@ContactsID INT = NULL	
	,@FirstName NVARCHAR (100) 
	,@LastName NVARCHAR (100) 
	,@Address1 NVARCHAR (100) 
	,@Address2 NVARCHAR (100)
	,@City     NVARCHAR (100) 
	,@Zip     NVARCHAR (20) 
	,@StateID		INT
	,@Active         BIT          = 1 
	,@Phone NVARCHAR (15) 
	,@Email NVARCHAR (100) 
	,@NewContactsID      INT = NULL OUTPUT
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = ''
	set @NewContactsID = NULL;

	UPDATE con
	set 
		 con.CompanyID   = @CompanyID      
		,con.FirstName = @FirstName 
		,con.LastName = @LastName 
		,con.Address1 =  @Address1  
		,con.Address2 =  @Address2  
		,con.City     =	  @City      
		,con.Zip    =	  @Zip      
		,con.StateID	= @StateID
		,con.[Phone] = @Phone
		,con.[Email] = @Email
		,con.Active = @Active
	from Contacts con
	WHERE con.ContactsID = @ContactsID;

	if @@ROWCOUNT = 0
	begin
	INSERT INTO [dbo].[Contacts]
        ([CompanyID]
        ,[Address1]
        ,[Address2]
        ,[City]
        ,[Zip]
        ,[FirstName]
        ,[LastName]
        ,[Phone]
        ,[Email]
        ,[Active]
        ,[StateID])
     VALUES
        (@CompanyID
        ,@Address1 
        ,@Address2 
        ,@City 
        ,@Zip
        ,@FirstName 
        ,@LastName 
        ,@Phone
        ,@Email
        ,@Active
        ,@StateID);
	
		SET @ContactsID	=  SCOPE_IDENTITY();
	END

	set @NewContactsID = @ContactsID;

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[spContactsUpsert] :: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH