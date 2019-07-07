CREATE PROCEDURE [dbo].[spSearchGet]
	@SearchItem VARCHAR(120) 
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	declare @RowCount as int = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = '';

	select s.SalesID as 'Go To'
		,s.SalesNo as 'Sales No'
		,w.WorkOrderID as 'Work Order'
		,s.TrackingNo as 'Tracking No'
		,w.DateAdded as 'Date Added'
		,client.CompanyName as 'Client'
		,bill.CompanyName as 'Billing Client'
	from WorkOrder as w
		inner join Sales as s on w.SalesID = s.SalesID
		inner join CompanyLocations as cl on s.CompanyLocationsID = cl.CompanyLocationsID
		inner join Company as bill on s.BillingCompanyID = bill.CompanyID
		inner join Company as client on cl.CompanyID = client.CompanyID
	where len(trim(@SearchItem)) > 0
		and (w.WorkOrderID = try_cast(@SearchItem as int)
			or s.SalesNo = @SearchItem 
			or s.TrackingNo = @SearchItem 
			or bill.CompanyName like '%' +  @SearchItem + '%'
			or client.CompanyName like '%' +  @SearchItem + '%')
	order by s.SalesNo desc;
		
	set @RowCount = @@ROWCOUNT;		

ExitProc:
	set @ErrorMsg = (case when @RowCount = 0 then 'No Records Found' else '' end);
	
END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[spSearchGet] :: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH