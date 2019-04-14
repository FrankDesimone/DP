CREATE PROCEDURE [dbo].[spECDGet]
	@ECDID INT  = null
	,@CompanyID as int = null
	,@PartNumber as nvarchar(100) = null
	,@SerialNumber as NVARCHAR (100) = null
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	declare @SerialNull as bit = @False;

	set @ErrorCode = 0;
	set @ErrorMsg = '';

	if @ECDID is null
		and len(coalesce(@SerialNumber, '')) > 1
	begin
		select @ECDID = ecd.ECDID
		FROM [dbo].[ECD] as ecd
		where @CompanyID = ecd.CompanyID
			and @SerialNumber = ecd.SerialNumber;
	end

	if @ECDID is null
		and len(coalesce(@PartNumber, '')) > 1
	begin
		select top 1 @ECDID = ecd.ECDID
			,@SerialNull = @True
		FROM [dbo].[ECD] as ecd
		where @CompanyID = ecd.CompanyID
			and @PartNumber = ecd.PartNumber
		order by ecd.DateAdded desc;
	end

	SELECT  ecd.[ECDID]
		  ,ecd.[CompanyID]
		  ,ecd.[SubstrateTypeID]
		  ,st.SubstrateType
		  ,ecd.ManufacturerID
		  ,m.Manufacturer
		  ,ecd.[DeviceTypeID]
		  ,dt.DeviceType
		  ,ecd.[TimesCleaned]
		  ,ecd.[PartNumber]
		  ,(case when @SerialNull = @False then ecd.[SerialNumber] else '' end) as [SerialNumber]
		  ,(case when @SerialNull = @False then ecd.[OtherNumber] else '' end) as [OtherNumber]
		  ,ecd.[OuterDiameter]
		  ,ecd.[SubstrateDiameter]
		  ,ecd.[OuterLength]
		  ,ecd.[SubstrateLength]
	  FROM [dbo].[ECD] as ecd
	  inner join [Manufacturer] as m on ecd.ManufacturerID = m.ManufacturerID
	  inner join SubstrateType st on ecd.SubstrateTypeID = st.SubstrateTypeID
	  inner join DeviceType as dt on ecd.DeviceTypeID = dt.DeviceTypeID
	  where ecd.ECDID = @ECDID;

	  if @@ROWCOUNT = 0
	  begin
		set @ErrorCode = 1;
		set @ErrorMsg = 'Part not found';
	  end

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[[spECDGet]]:: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH
