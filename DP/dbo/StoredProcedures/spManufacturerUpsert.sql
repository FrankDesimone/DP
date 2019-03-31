﻿CREATE PROCEDURE [dbo].[spManufacturerUpsert]
	@ManufacturerID  INT          = NULL 
	,@Manufacturer  NVARCHAR (50) = null
	,@NewManufacturerID  INT = NULL OUTPUT
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = ''
	set @NewManufacturerID = NULL;

	declare @Message as varchar(8000) = ''
		,@Fail as bit = @False;

	set @ErrorCode = 1;
	set @ErrorMsg = 'Unable to update manufacturer';

	if len(coalesce(@Manufacturer, '')) = 0
	begin
		set @Fail = @True;
		set @Message = 'Manufacturer must be entered';

		goto ExitProc;
	end


	UPDATE m
	set m.Manufacturer =@Manufacturer
	from Manufacturer m
	WHERE m.ManufacturerID = @ManufacturerID;

	if @@ROWCOUNT = 0
	begin
		INSERT INTO [dbo].[Manufacturer]
		   ([Manufacturer])
		VALUES
		   (@Manufacturer);
	
		SET @ManufacturerID	=  SCOPE_IDENTITY();
	END

	set @NewManufacturerID = @ManufacturerID;

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
		
	SELECT @ErrorMessage = '[spManufacturerUpsert] :: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH