CREATE PROCEDURE [dbo].[spVehicleGet]
	@VehicleID as INT = null
	,@CompanyID as int 
	,@SerialNumber as NVARCHAR (50)  = null
	,@AssetNumber as NVARCHAR (50) = NULL
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = '';

	set @SerialNumber = ltrim(rtrim(coalesce(@SerialNumber, '')));
	set @AssetNumber = ltrim(rtrim(coalesce(@AssetNumber, '')));

	if @VehicleID is null
		and len(@SerialNumber) > 1
	begin
		select top 1 @VehicleID = v.VehicleID
		FROM [dbo].[Vehicle] as v
		where @CompanyID = v.CompanyID
			and @SerialNumber = v.SerialNumber
		order by v.DateAdded desc;
	end

	if @VehicleID is null
		and len(@AssetNumber) > 1
	begin
		select top 1 @VehicleID = v.VehicleID
		FROM [dbo].[Vehicle] as v
		where @CompanyID = v.CompanyID
			and @AssetNumber = v.AssetNumber
		order by v.DateAdded desc;
	end

	SELECT  
		  v.[VehicleID]
		,v.[CompanyID]
		  ,v.[SerialNumber]
		  ,v.[AssetNumber]
		  ,v.[ManufacturerID]
		  ,m.Manufacturer
		  ,v.[Model]
		  ,v.[Year]
		  ,v.[MileageInitialCleaning]
		  ,v.[HoursInitialCleaning]
	  FROM [dbo].[Vehicle] as v
		inner join [Manufacturer] as m on v.ManufacturerID = m.ManufacturerID
	  where v.VehicleID = @VehicleID;

	if @@ROWCOUNT = 0
	begin
		set @ErrorCode = 1;
		set @ErrorMsg = 'Vehicle not found';
	end

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[spVehicleGet]:: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH