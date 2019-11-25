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
		,s.[SalesStatusID]
		,s.[BillingCompanyID] 
		,cb.[CompanyName]
		,cb.[CompanyInitials]
		,cb.[BillingAddress1]
		,cb.[BillingAddress2]
		,cb.[BillingCity]
		,cb.[BillingZip]
		,cb.[StateID]
		,st.[State]
		,cb.[ContactsID]
		,cb.[Active]
		,s.CompanyID
		,cl.CompanyLocationsID
		,cl.Location
		,cl.Address1
		,cl.Address2
		,cl.City
		,sto.State
		,cl.Zip
		,s.Contact
		,s.TrackingNo
		,s.LegacyJobID
		,s.CleaningLocationID
	FROM [dbo].[Sales] as s
		inner join [Company] as cb on cb.CompanyID = s.[BillingCompanyID]
		inner join [State] as st on cb.StateID = st.StateID
		inner join CompanyLocations as cl on s.CompanyLocationsID = cl.CompanyLocationsID
		inner join Company as co on s.CompanyID = co.CompanyID
		inner join [State] as sto on cl.StateID = sto.StateID
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