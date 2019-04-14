﻿CREATE PROCEDURE [dbo].[spEngineGet]
	@EngineID INT = null
	,@CompanyID as int = null
	,@SerialNumber as nvarchar(50) = null
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = '';

	if @EngineID is null
		and len(coalesce(@SerialNumber, '')) > 1
	begin
		select @EngineID = e.EngineID
		FROM Engine as e
		where @CompanyID = e.CompanyID
			and @SerialNumber = e.SerialNumber;
	end	

	SELECT e.[EngineID]
	  ,e.[CompanyID]
	  ,e.[ManufacturerID]
	  ,m.[Manufacturer]
	  ,e.[SerialNumber]
	  ,e.[Model]
	  ,e.[Year]
	FROM [dbo].[Engine] as e
		inner join [Manufacturer] as m on e.ManufacturerID = m.ManufacturerID
	where e.EngineID = @EngineID;

	if @@ROWCOUNT = 0
	begin
		set @ErrorCode = 1;
		set @ErrorMsg = 'Engine not found';
	end
	
END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[[spEngineGet]]:: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH
