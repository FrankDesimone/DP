CREATE PROCEDURE [dbo].[spEngineUpsert]
	@CompanyID INT	= null	
	,@EngineID INT = NULL 	
	,@ManufacturerID INT
	,@SerialNumber NVARCHAR (100) = null      
	,@Model NVARCHAR (100) = null
	,@Year INT = null
	,@NewEngineID INT = NULL OUTPUT
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = ''
	set @NewEngineID = NULL;

	declare @Message as varchar(8000) = ''
		,@Fail as bit = @False;

	set @ErrorCode = 1;
	set @ErrorMsg = 'Unable to update engine';

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

	UPDATE e
	set 
		e.[CompanyID]=@CompanyID
	  ,e.[SerialNumber]=@SerialNumber
	  ,e.[ManufacturerID] = @ManufacturerID
	  ,e.[Model] = @Model
	  ,e.[Year]	= @Year
	from Engine  e
	WHERE e.EngineID = @EngineID;

	if @@ROWCOUNT = 0
	begin


	INSERT INTO [dbo].[Engine]
		   ([CompanyID]
		   ,[SerialNumber]
		   ,[ManufacturerID]
		   ,[Model]
		   ,[Year])
	 VALUES
			(@CompanyID
			,@SerialNumber
		   ,@ManufacturerID
		   ,@Model
		   ,@Year);
	
		SET @EngineID	=  SCOPE_IDENTITY();
	END

	set @NewEngineID = @EngineID;

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
		
	SELECT @ErrorMessage = '[spEngineUpsert] :: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH