CREATE PROCEDURE [dbo].[spExceptionAdd]
    @ReportingProcedure VARCHAR(250) = ''
    ,@ErrorNumber INT = 0
    ,@ErrorLine INT = 0
    ,@ErrorMessage VARCHAR(500) = ''
    ,@ErrorNote VARCHAR(500) = ''
    ,@ErrorCode AS INT = 0 OUTPUT
AS
SET NOCOUNT ON;

BEGIN

	insert Exceptions (ReportingProcedure, ErrorNumber, ErrorLine, ErrorMessage, ErrorNote)
	values (
		coalesce(@ReportingProcedure,SYSTEM_USER)
		,coalesce(@ErrorNumber, -99)
		,coalesce(@ErrorLine, -99)
		,coalesce(@ErrorMessage, 'N/A')
		,coalesce(@ErrorNote, 'N/A')
		);
end