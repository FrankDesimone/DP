CREATE PROCEDURE [dbo].[spCompanyGet]
	@CompanyID      INT  
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = '';




		SELECT c.[CompanyID]
		,c.[CompanyName]
		,c.[BillingAddress1]
		,c.[BillingAddress2]
		,c.[BillingCity]
		,c.[BillingZip]
		,c.[StateID]
		,c.[ContactsID]
		,c.[Active]     

  FROM [Company] as c
  where c.CompanyID =@CompanyID
		


ExitProc:

END TRY

BEGIN CATCH

END CATCH
