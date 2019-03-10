CREATE PROCEDURE [dbo].[spCompanyUpsert]
	@CompanyID      INT          = NULL 
	,@CompanyName     NVARCHAR (50)
	,@CompanyInitials	NVARCHAR(10)
	,@BillingAddress1 NVARCHAR (50) 
	,@BillingAddress2 NVARCHAR (50)
	,@BillingCity     NVARCHAR (50) 
	,@BillingZip     NVARCHAR (10) 
	,@StateID		INT
	,@Active         BIT          = 1 
	,@ContactsID	INT= NULL
	,@NewCompanyID      INT          = NULL OUTPUT
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = ''
	set @NewCompanyID = NULL;
	
	UPDATE c
	set c.CompanyName =@CompanyName
		,c.CompanyInitials =@CompanyInitials
		,c.BillingAddress1 = @BillingAddress1
		,c.BillingCity =@BillingCity
		,c.BillingZip =@BillingZip
		,c.BillingAddress2 =@BillingAddress2
		,c.Active =@Active
		,c.StateID =@StateID
		,c.ContactsID = @ContactsID
	from Company c
	WHERE c.CompanyID = @CompanyID;

	if @@ROWCOUNT = 0
	begin
		INSERT INTO [dbo].[Company]
		   ([CompanyName]
		   ,[CompanyInitials]
		   ,[BillingAddress1]
		   ,[BillingCity]
		   ,[BillingZip]
		   ,[BillingAddress2]
		   ,[Active]
		   ,[StateID]
		   ,[ContactsID])
		VALUES
		   (@CompanyName
		   ,@CompanyInitials
		   ,@BillingAddress1
		   ,@BillingCity 
		   ,@BillingZip 
		   ,@BillingAddress2 
		   ,@Active 
		   ,@StateID 
		   ,@ContactsID);
	
		SET @CompanyID	=  SCOPE_IDENTITY();
	END

	set @NewCompanyID = @CompanyID;

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[spCompanyUpsert] :: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH