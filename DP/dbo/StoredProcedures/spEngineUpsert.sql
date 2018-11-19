CREATE PROCEDURE [dbo].[spEngineUpsert]
	@CompanyID      INT		
	,@EngineID INT = NULL 	
	,@ManufacturerID INT
	,@SerialNumber  NVARCHAR (100)       
    ,@Model         NVARCHAR (100) 
	,@Year INT 
	,@NewEngineID      INT          = NULL OUTPUT
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