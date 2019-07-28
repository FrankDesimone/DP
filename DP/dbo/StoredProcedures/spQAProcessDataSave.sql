CREATE PROCEDURE [dbo].[spQAProcessDataSave]
	@QAProcessID as int
	,@TestLine as int
    ,@PSI as float

	,@ErrorCode as int = 0
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
BEGIN TRAN
	set @ErrorCode = 0;
	set @ErrorMsg = '';

	update qapd set qapd.PSI = @PSI
	from QAProcessData as qapd
	where qapd.QAProcessID = @QAProcessID
		and qapd.TestLine = @TestLine;

	if @@ROWCOUNT = 0
	begin
		insert into QAProcessData (QAProcessID, TestLine, PSI)
		values (@QAProcessID, @TestLine, @PSI);
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
		
	SELECT @ErrorMessage = '[spQAProcessDataSave]:: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH