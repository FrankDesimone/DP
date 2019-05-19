CREATE PROCEDURE [dbo].[spECDUpsert]
	@CompanyID INT		
	,@ECDID	INT	    
	,@WorkOrderID int = null
    ,@SubstrateTypeID INT         
    ,@ManfacturerID INT         
    ,@DeviceTypeID INT                  
    ,@PartNumber nvarchar(100)	
    ,@SerialNumber NVARCHAR (100)
    ,@OtherNumber NVARCHAR (100) 
	,@OuterDiameter FLOAT (53)  
    ,@SubstrateDiameter FLOAT (53)  
    ,@OuterLength FLOAT (53)  
    ,@SubstrateLength FLOAT (53)  
	,@NewECDID INT = NULL OUTPUT
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	declare @NewRec as bit = @False;

	set @ErrorCode = 0;
	set @ErrorMsg = ''
	set @NewECDID = NULL;

	UPDATE ecd
	set 
		ecd.WorkOrderID = @WorkOrderID
	   ,ecd.[CompanyID]	= @CompanyID 
      ,ecd.[SubstrateTypeID] = @SubstrateTypeID
      ,ecd.ManufacturerID = @ManfacturerID
      ,ecd.[DeviceTypeID] = @DeviceTypeID
      ,ecd.[PartNumber]	= @PartNumber
      ,ecd.[SerialNumber] = @SerialNumber
      ,ecd.[OtherNumber] = @OtherNumber
      ,ecd.[OuterDiameter] = @OuterDiameter
      ,ecd.[SubstrateDiameter] = @SubstrateDiameter
      ,ecd.[OuterLength] = @OuterLength
      ,ecd.[SubstrateLength] = @SubstrateLength
	FROM [dbo].[ECD] as ecd
	where ecd.ECDID = @ECDID;

	if @@ROWCOUNT = 0
	begin
		INSERT INTO [dbo].[ECD]
			   ([WorkOrderID]
				,[CompanyID]
			   ,[SubstrateTypeID]
			   ,ManufacturerID
			   ,[DeviceTypeID]
			   ,[PartNumber]
			   ,[SerialNumber]
			   ,[OtherNumber]
			   ,[OuterDiameter]
			   ,[SubstrateDiameter]
			   ,[OuterLength]
			   ,[SubstrateLength])
		 VALUES
			   (@WorkOrderID
			   ,@CompanyID
			   ,@SubstrateTypeID
			   ,@ManfacturerID
			   ,@DeviceTypeID
			   ,@PartNumber
			   ,@SerialNumber
			   ,@OtherNumber
			   ,@OuterDiameter
			   ,@SubstrateDiameter
			   ,@OuterLength
			   ,@SubstrateLength)
	
			SET @ECDID	=  SCOPE_IDENTITY();
			set @NewRec = @True;
	END

	set @NewECDID = @ECDID;

	set @ErrorMsg = (case when @NewRec = @True then 'New ECD created' else 'ECD updated' end);

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[[spECDUpsert]] :: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH