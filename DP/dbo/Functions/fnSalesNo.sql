CREATE FUNCTION [dbo].[fnSalesNo]
(
	@WorkOrderID as int
)
RETURNS varchar(50)
AS
BEGIN
	declare @SalesNo as varchar(50) = '';

	select @SalesNo = c.CompanyInitials + '-' + cast(s.SalesID as varchar(12)) + '-' + cast(w.WorkOrderID as varchar(12))
	from WorkOrder as w
		inner join Sales as s on w.SalesID = s.SalesID
		inner join Company as c on s.BillingCompanyID = c.CompanyID
	where w.WorkOrderID = @WorkOrderID;

	RETURN @SalesNo;
END