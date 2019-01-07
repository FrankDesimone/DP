CREATE PROCEDURE [dbo].[spQASave]
	@WorkOrderID as int
    ,@QASootOnFaceID as int = null
    ,@QAAshOnFaceID as int = null
	,@QAAshColorID as int = null
    ,@QASubstrateID as int = null
    ,@QACoolantID as int = null
    ,@ProcessID_0 as int = null
    ,@ECDMass_0 as real = null
    ,@InletCell12_0 as real = null
    ,@InletCell03_0 as real = null
    ,@InletCell06_0 as real = null
    ,@InletCell09_0 as real = null
    ,@InletCellCenter_0 as real = null
    ,@ProcessID_1 as int = null
    ,@ECDMass_1 as real = null
    ,@InletCell12_1 as real = null
    ,@InletCell03_1 as real = null
    ,@InletCell06_1 as real = null
    ,@InletCell09_1 as real = null
    ,@InletCellCenter_1 as real = null
	,@ProcessID_2 as int = null
    ,@ECDMass_2 as real = null
    ,@InletCell12_2 as real = null
    ,@InletCell03_2 as real = null
    ,@InletCell06_2 as real = null
    ,@InletCell09_2 as real = null
    ,@InletCellCenter_2 as real = null
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
BEGIN TRAN
	declare @QualityControlID as int = null;

	set @ErrorCode = 0;
	set @ErrorMsg = '';

	update qa set @QASootOnFaceID = @QASootOnFaceID
		,@QAAshOnFaceID = @QAAshOnFaceID
		,@QAAshColorID = @QAAshColorID
		,@QASubstrateID = @QASubstrateID
		,@QACoolantID = @QACoolantID
	from QualityControl as qa
	where qa.WorkOrderID = @WorkOrderID;

	if @@ROWCOUNT = 0
	begin
		insert into QualityControl (WorkOrderID, QASootOnFaceID, QAAshOnFaceID, QAAshColorID, QASubstrateID, QACoolantID)
		values (@WorkOrderID, @QASootOnFaceID, @QAAshOnFaceID, @QAAshColorID, @QASubstrateID, @QACoolantID);
	end

	select @QualityControlID = qc.QualityControlID
	from QualityControl as qc
	where qc.WorkOrderID = @WorkOrderID;

	exec spQAProcessSave
		@QualityControlID = @QualityControlID
		,@ProcessID = @ProcessID_0
		,@ECDMass = @ECDMass_0
		,@InletCell12 = @InletCell12_0
		,@InletCell03 = @InletCell03_0
		,@InletCell06 = @InletCell06_0
		,@InletCell09 = @InletCell09_0
		,@InletCellCenter = @InletCellCenter_0;

	exec spQAProcessSave
		@QualityControlID = @QualityControlID
		,@ProcessID = @ProcessID_1
		,@ECDMass = @ECDMass_1
		,@InletCell12 = @InletCell12_1
		,@InletCell03 = @InletCell03_1
		,@InletCell06 = @InletCell06_1
		,@InletCell09 = @InletCell09_1
		,@InletCellCenter = @InletCellCenter_1;

	exec spQAProcessSave
		@QualityControlID = @QualityControlID
		,@ProcessID = @ProcessID_2
		,@ECDMass = @ECDMass_2
		,@InletCell12 = @InletCell12_2
		,@InletCell03 = @InletCell03_2
		,@InletCell06 = @InletCell06_2
		,@InletCell09 = @InletCell09_2
		,@InletCellCenter = @InletCellCenter_2;

COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;

	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = 'spQAGet:: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH