CREATE PROCEDURE [dbo].[spSelectorsGet]
	@Selector VARCHAR(50) 
	,@Filter as varchar(500) = null
	,@IsFilter as bit = 1
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = '';


	IF @Selector ='company' 
	BEGIN

		select Null as CompanyID
			,'Please Select' as CompanyName
			,1 as Sortkey
		union all
		select c.CompanyID
			,c.CompanyName
			,1 as SortKey
		from Company as c
		where c.Active=1
		

		goto ExitProc;
	END

	IF @Selector = 'servicelocation' 
	BEGIN

		select Null as [ServiceLocationID]
			,'Please Select' as [Location]
			,0 as Sortkey
		union all
		select sl.CompanyLocationsID
			,sl.Location
			,1 as SortKey
		from CompanyLocations as sl
		where sl.CompanyID = try_cast(@Filter as int)
		order by SortKey;

		goto ExitProc;
	END

	IF @Selector = 'contacts' 
	BEGIN

		select Null as ContactsID
			,'Please Select' as Contact
			,0 as Sortkey
		union all
		select c.ContactsID
			,c.FirstName + ' ' + c.LastName as Contact
			,1 as SortKey
		from [Contacts] as c
		where c.CompanyID = try_cast(@Filter as int)
		order by SortKey;

		goto ExitProc;
	END
	
	IF @Selector = 'state' 
	BEGIN

		select Null as StateID
			,'Please Select' as StateName
			,0 as Sortkey
		union all
		select s.StateID
			,s.StateName
			,1 as SortKey
		from [State] as s
		order by SortKey;

		goto ExitProc;
	END

ExitProc:

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[spSelectorsGet] :: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH