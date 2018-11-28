CREATE PROCEDURE [dbo].[spECDGet]
	@ECDID     INT  
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = '';

SELECT  ecd.[ECDID]
      ,ecd.[CompanyID]
      ,ecd.[SubstrateTypeID]
	  ,st.SubstrateType
      ,ecd.[ManfacturerID]
	  ,m.Manufacturer
      ,ecd.[DeviceTypeID]
	  ,dt.DeviceType
      ,ecd.[TimesCleaned]
      ,ecd.[PartNumber]
      ,ecd.[SerialNumber]
      ,ecd.[OtherNumber]
      ,ecd.[OuterDiameter]
      ,ecd.[SubstrateDiameter]
      ,ecd.[OuterLength]
      ,ecd.[SubstrateLength]
  FROM [dbo].[ECD] as ecd
  inner join [Manufacturer] as m on ecd.ManfacturerID = m.ManufacturerID
  inner join SubstrateType st on ecd.SubstrateTypeID = st.SubstrateTypeID
  inner join DeviceType as dt on ecd.DeviceTypeID = dt.DeviceTypeID
  where ecd.ECDID = @ECDID;

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
