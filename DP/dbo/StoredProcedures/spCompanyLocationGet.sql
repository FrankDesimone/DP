CREATE PROCEDURE [dbo].[spCompanyLocationGet]
		@CompanyLocationsID     INT  
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = '';

SELECT  cl.[CompanyLocationsID]
      ,cl.[CompanyID]
      ,cl.[Location]
      ,cl.[Address1]
      ,cl.[Address2]
      ,cl.[City]
      ,cl.[Zip]
      ,cl.[StateID]
	  ,s.[State]
  FROM [dbo].[CompanyLocations] as cl
    inner join [State] as s on cl.StateID = s.StateID

  where cl.CompanyLocationsID = @CompanyLocationsID;

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[spCompanyLocationGet] :: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH