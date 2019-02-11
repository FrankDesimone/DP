CREATE PROCEDURE [dbo].[spWorkOrderReportDataGet]
	@WorkOrderID as  INT  
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = '';

	SELECT  
		w.WorkOrderID
		,(con.Firstname + ' ' + con.LastName) as Contact
		,ws.WorkOrderStatus
		,w.PreventMaintAshCleanInter
		,w.HighSootCEL
		,w.EngineFailureFluidsInExhaust
		,clean.CleaningReason
		,w.RoadHighway
		,w.StartStop
		,w.HighIdle
		,drive.DrivingType
		,w.FirstCleaning
		,w.VehicleTotalMileage
		,w.VehicleTotalHours
		,w.DateAdded
		,c.CompanyName
		,c.BillingAddress1
		,c.BillingAddress2
		,c.BillingCity
		,c.BillingZip
		,c.StateID
		,cs.[State]
		,cl.[Location]
		,cl.Address1
		,cl.Address2
		,cl.City
		,cl.Zip
		,cl.StateID
		,s.[State]
		, v.VehicleID
		,v.CompanyID
		,v.SerialNumber
		,v.AssetNumber
		,v.ManufacturerID
		,vm.Manufacturer
		,v.Model
		,v.[Year]
		,e.EngineID
		,e.CompanyID
		,e.ManufacturerID
		,em.Manufacturer
		,e.SerialNumber
		,e.Model
		,e.Year
		, ecd.ECDID
		,ecd.CompanyID
		,ecd.SubstrateTypeID
		,st.SubstrateType
		,ecd.ManfacturerID
		,ecdm.Manufacturer
		,ecd.DeviceTypeID
		,dt.DeviceType
		,ecd.TimesCleaned
		,ecd.PartNumber
		,ecd.SerialNumber
		,ecd.OtherNumber
		,ecd.OuterDiameter
		,ecd.SubstrateDiameter
		,ecd.OuterLength
		,ecd.SubstrateLength
		,qa.QASootOnFaceID
		,qa.QAAshOnFaceID
		,qa.QAAshColorID
		,qa.QASubstrateID
		,qa.Coolant
		,qa.RedAsh
		,qa.USignalReceived
		,qa.ECDPinDropDepth
		,qa.CleanChannels
		,qa.TargetMaxSpaceVelocity
		,qa.MaxHertz
	FROM WorkOrder as w
		inner join CompanyLocations as cl on w.CompanyLocationID = cl.CompanyLocationsID
		inner join [State] as s on cl.StateID = s.StateID
		inner join Company as c on cl.CompanyID = c.CompanyID
		inner join [State] as cs on c.StateID = cs.StateID
		inner join Vehicle as v on w.VehicleID = v.VehicleID
		inner join Manufacturer as vm on v.ManufacturerID = vm.ManufacturerID
		inner join ECD as ecd on w.ECDID = ecd.ECDID
		inner join Manufacturer as ecdm on ecd.ManfacturerID = ecdm.ManufacturerID
		inner join SubstrateType st on ecd.SubstrateTypeID = st.SubstrateTypeID
		inner join DeviceType as dt on ecd.DeviceTypeID = dt.DeviceTypeID
		inner join WorkOrderStatus as ws on w.WorkOrderStatusID = ws.WorkOrderStatusID
		left join Engine as e on w.EngineID = e.EngineID
		left join Manufacturer as em on e.ManufacturerID = em.ManufacturerID
		left join QA as  qa on   w.WorkOrderID = qa.WorkOrderID
		left outer join Contacts as con on w.ContactsID = Con.ContactsID
		left outer join CleaningReason as clean on w.CleaningReasonID = clean.CleaningReasonID
		left outer join DrivingType as drive on w.DrivingTypeID = drive.DrivingTypeID
  where w.WorkOrderID = @WorkOrderID;

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = 'spWorkOrderReportDataGet:: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH