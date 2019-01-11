CREATE PROCEDURE [dbo].[spQAFlowProcessSave]
	@WorkOrderID as int
	,@ProcessID  INT
    ,@MaxSpaceVelocity		 as real = null
    ,@MaxHertz		 as real = null        
    ,@AirTemp		 as real = null
    ,@BaroPress		 as real = null
    ,@BackPress		 as real = null
    ,@a				 as real = null
    ,@b				 as real = null
    ,@c				 as real = null
    ,@PSI1        	 as real = null
	,@PSI2        	 as real = null
	,@PSI3			 as real = null        
	,@PSI4        	 as real = null
	,@PSI5        	 as real = null
	,@PSI6			 as real = null
	,@PSI7			 as real = null        
	,@PSI8      	 as real = null  
	,@PSI9			 as real = null
	,@PSI10     	 as real = null   
	,@PSI11			 as real = null
	,@SV1       	 as real = null 
	,@SV2         	 as real = null 
	,@SV3         	 as real = null 
	,@SV4       	 as real = null 
	,@SV5         	 as real = null 
	,@SV6		  	 as real = null
	,@SV7       	 as real = null 
	,@SV8			 as real = null		        
	,@SV9			 as real = null
	,@SV10      	 as real = null  
	,@SV11			 as real = null
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
BEGIN TRAN
	declare @True as bit = 1
		,@False as bit = 0;

	declare @QualityControlID as int = null;

	set @ErrorCode = 0;
	set @ErrorMsg = '';



COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;

	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = 'spQAFlowProcessSave:: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH