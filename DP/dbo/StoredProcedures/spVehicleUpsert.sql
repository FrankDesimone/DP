CREATE PROCEDURE [dbo].[spVehicleUpsert]
	@CompanyID INT		
	,@VehicleID INT = NULL 	
	,@VehicleTypeID INT
	,@SerialNumber NVARCHAR (100) 
	,@AssetNumber NVARCHAR (100)  = NULL
	,@ManufacturerID INT          
	,@Model  NVARCHAR (100) 
	,@Year INT 
	,@InitialCleaning FLOAT = NULL 
	,@NewVehicleID INT = NULL OUTPUT
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = ''
	set @NewVehicleID = NULL;

	declare @Message as varchar(8000) = ''
		,@Fail as bit = @False;

	set @ErrorCode = 1;
	set @ErrorMsg = 'Unable to update vehicle';

	if @CompanyID is null
	begin
		set @Fail = @True;
		set @Message = 'Company must be selected';

		goto ExitProc;
	end

	if @ManufacturerID is null
	begin
		set @Fail = @True;
		set @Message = 'Make must be selected';

		goto ExitProc;
	end

	if @VehicleTypeID = 1
		and len(coalesce(@SerialNumber , '')) <> 17
	begin
		set @Fail = @True;
		set @Message = 'Invalid VIN';

		goto ExitProc;
	end

	if exists (Select 1 
		from Vehicle as v
		where v.VehicleID = @VehicleID
			and v.SerialNumber <> @SerialNumber)
	begin
		set @Fail = @True;
		set @Message = 'Serial Number cannot be changed';

		goto ExitProc;
	end


	if not (coalesce(@Year, year(getdate())) between 1900 and 2100)
	begin
		set @Fail = @True;
		set @Message = 'Enter 4 digit year';

		goto ExitProc;		
	end

	UPDATE v
	set 
		v.[CompanyID]=@CompanyID
		,v.[SerialNumber]=@SerialNumber
		,v.[AssetNumber] = @AssetNumber
		,v.[ManufacturerID] = @ManufacturerID
		,v.[Model] = @Model
		,v.[Year]	= @Year
		,v.VehicleTypeID =  @VehicleTypeID
		,v.InitialCleaning = @InitialCleaning 
	from Vehicle  v
	WHERE v.VehicleID = @VehicleID;

	if @@ROWCOUNT = 0
	begin


	INSERT INTO [dbo].[Vehicle]
		   ([CompanyID]
		   ,[SerialNumber]
		   ,[AssetNumber]
		   ,[ManufacturerID]
		   ,[Model]
		   ,[Year]
		   ,VehicleTypeID 
		   ,InitialCleaning )
	 VALUES
			(@CompanyID
			,@SerialNumber
		   ,@AssetNumber
		   ,@ManufacturerID
		   ,@Model
		   ,@Year
		   ,@VehicleTypeID
		   ,@InitialCleaning		   );
	
		SET @VehicleID	=  SCOPE_IDENTITY();
	END

	set @NewVehicleID = @VehicleID;

ExitProc:
	set @ErrorMsg = (case when @Fail = @False then 'Record Saved' else @Message end);
	set @ErrorCode = @Fail;

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[spVehicleUpsert] :: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH