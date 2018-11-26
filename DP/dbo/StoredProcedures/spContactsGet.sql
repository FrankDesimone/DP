CREATE PROCEDURE [dbo].[spContactsGet]
@ContactsID     INT  
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = '';

SELECT con.[ContactsID]
      ,con.[CompanyID]
      ,con.[Address1]
      ,con.[Address2]
      ,con.[City]
      ,con.[Zip]
      ,con.[FirstName]
      ,con.[LastName]
      ,con.[Phone]
      ,con.[Email]
      ,con.[Active]
      ,con.[StateID]
  FROM [dbo].[Contacts] as con
  where con.ContactsID = @ContactsID;

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[spCompanyLocationGet] :: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH