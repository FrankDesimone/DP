CREATE PROCEDURE [dbo].[spCompanyUpsert]
	@CompanyID      INT          = NULL 
    ,@CompanyName     NVARCHAR (50) 
    ,@BillingAddress1 NVARCHAR (50) 
    ,@BillingAddress2 NVARCHAR (50)
	,@BillingCity     NVARCHAR (50) 
    ,@BillingZip     NVARCHAR (10) 
	,@StateID		INT
    ,@Active         BIT          = 1 
	,@ContactsID	INT= NULL
	,@NewCompanyID      INT          = NULL OUTPUT
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = ''
	set @NewCompanyID = NULL;


	IF @CompanyID is null 
	BEGIN

		INSERT INTO [dbo].[Company]
           ([CompanyName]
           ,[BillingAddress1]
           ,[BillingCity]
           ,[BillingZip]
           ,[BillingAddress2]
           ,[Active]
           ,[StateID]
           ,[ContactsID])
     VALUES
           (@CompanyName
           ,@BillingAddress1
           ,@BillingCity 
           ,@BillingZip 
           ,@BillingAddress2 
           ,@Active 
           ,@StateID 
           ,@ContactsID);
	
	SET @NewCompanyID	=  SCOPE_IDENTITY();

		goto ExitProc;
	END
	ELSE
	BEGIN
		set @NewCompanyID = @CompanyID; 

		UPDATE c
		set c.CompanyName =@CompanyName
           ,c.BillingAddress1 = @BillingAddress1
           ,c.BillingCity =@BillingCity
           ,c.BillingZip =@BillingZip
           ,c.BillingAddress2 =@BillingAddress2
           ,c.Active =@Active
           ,c.StateID =@StateID
           ,c.ContactsID = @ContactsID
		from Company c
		WHERE c.CompanyID = @CompanyID;

		goto ExitProc;
	END


ExitProc:

END TRY

BEGIN CATCH

END CATCH