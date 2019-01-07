CREATE PROCEDURE [dbo].[spQAProcessSave]
	@QualityControlID as int
    ,@ProcessID as int 
    ,@ECDMass as real = null
    ,@InletCell12 as real = null
    ,@InletCell03 as real = null
    ,@InletCell06 as real = null
    ,@InletCell09 as real = null
    ,@InletCellCenter as real = null
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
BEGIN TRAN
	set @ErrorCode = 0;
	set @ErrorMsg = '';

	if @QualityControlID is null or @ProcessID is null goto ExitProc;

	update qap set qap.ECDMass = @ECDMass
		,qap.InletCell12 = @InletCell12
		,qap.InletCell03 = @InletCell03
		,qap.InletCell06 = @InletCell06
		,qap.InletCell09 = @InletCell09
	from QualityControlProcess as qap
	where qap.QualityControlID = qap.QualityControlID
		and qap.ProcessID = @ProcessID;

	if SCOPE_IDENTITY() = 0
	begin
		insert into QualityControlProcess (QualityControlID, ProcessID, ECDMass, InletCell12, InletCell03, InletCell06, InletCell09, InletCellCenter)
		values (@QualityControlID, @ProcessID, @ECDMass, @InletCell12, @InletCell03, @InletCell06, @InletCell09, @InletCellCenter);
	end
	
ExitProc:

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