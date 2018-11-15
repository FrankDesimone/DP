CREATE PROCEDURE [dbo].[spCompanyLocationUpsert]
	@CompanyID      INT          
	,@CompanyLocationsID INT = NULL	
    ,@Location    NVARCHAR (100) 
    ,@Address1 NVARCHAR (100) 
    ,@Address2 NVARCHAR (100)
	,@City     NVARCHAR (100) 
    ,@Zip     NVARCHAR (20) 
	,@StateID		INT
	,@NewCompanyLocationsID      INT          = NULL OUTPUT
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = ''
	set @NewCompanyLocationsID = NULL;

	UPDATE cl
	set 
	 cl.CompanyID   = @CompanyID      
    ,cl.Location    = @Location    
    ,cl.Address1 =  @Address1  
    ,cl.Address2 =  @Address2  
	,cl.City     =	  @City      
    ,cl.Zip    =	  @Zip      
	,cl.StateID		= @StateID		
	from CompanyLocations cl
	WHERE cl.CompanyLocationsID = @CompanyLocationsID;

	if @@ROWCOUNT = 0
	begin
	INSERT INTO [dbo].[CompanyLocations]
				([CompanyID]
				,[Location]
				,[Address1]
				,[Address2]
				,[City]
				,[Zip]
				,[StateID])
			VALUES
				(@CompanyID
				,@Location
				,@Address1
				,@Address2
				,@City
				,@Zip
				,@StateID)
	
		SET @CompanyLocationsID	=  SCOPE_IDENTITY();
	END

	set @NewCompanyLocationsID = @CompanyLocationsID;

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[spCompanyLocationUpsert] :: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH