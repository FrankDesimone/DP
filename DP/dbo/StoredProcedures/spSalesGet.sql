CREATE PROCEDURE [dbo].[spSalesGet]
	@SalesID      INT  
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = '';


	SELECT
		s.[SalesID]
		,s.[SalesNo]
		,s.[DateAdded]
		,s.[BillingCompanyID] 
		,c.[CompanyName]
		,c.[CompanyInitials]
		,c.[BillingAddress1]
		,c.[BillingAddress2]
		,c.[BillingCity]
		,c.[BillingZip]
		,c.[StateID]
		,st.[State]
		,c.[ContactsID]
		,c.[Active]
	FROM [dbo].[Sales] as s
	inner join [Company] as c on c.CompanyID = s.[BillingCompanyID]
	inner join [State] as st on c.StateID = st.StateID
	where s.[SalesID] = @SalesID;

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[spSalesGet] :: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH