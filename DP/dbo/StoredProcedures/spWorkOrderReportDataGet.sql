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
		,s.SalesNo
		,(con.FirstName + ' ' + con.LastName) as Contact
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
		,w.DateAdded as WODate
		,bc.CompanyName as BillingCompanyName
		,bc.BillingAddress1
		,bc.BillingAddress2
		,bc.BillingCity
		,bc.BillingZip
		,bc.StateID as BillingStateID
		,bcs.[State] as BillingState
		,c.CompanyName
		,c.BillingAddress1 as Address1
		,c.BillingAddress2 as Address2
		,c.BillingCity	as City
		,c.BillingZip as Zip
		,c.StateID
		,cs.[State]
		,cl.[Location]
		,cl.Address1
		,cl.Address2
		,cl.City
		,cl.Zip
		,cl.StateID
		,st.[State]
		, v.VehicleID
		,v.CompanyID
		,v.SerialNumber
		,v.AssetNumber
		,vm.Manufacturer
		,v.Model
		,v.[Year]
		,e.CompanyID
		,em.Manufacturer
		,e.SerialNumber
		,e.Model
		,e.Year
		, ecd.ECDID
		,ecd.SubstrateTypeID
		,sut.SubstrateType
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
		,qa.QASubstrateOveralConditionID
		,qa.Coolant
		,qa.RedAsh
		,qa.USignalReceived
		,qa.ECDPinDropDepth
		,qa.EngineEGRCoolant
		,qa.WearCorrosion
		,qa.FuelOil
		,qa.ContaminantsOther
		,qa.CleanChannels
		,qa.TargetMaxSpaceVelocity
		,qa.MaxHertz
	FROM WorkOrder as w
		inner join Sales as s on w.SalesID = s.SalesID
		inner join CompanyLocations as cl on w.CompanyLocationID = cl.CompanyLocationsID
		inner join [State] as st on cl.StateID = st.StateID
		inner join Company as c on cl.CompanyID = c.CompanyID
		inner join [State] as cs on c.StateID = cs.StateID
		inner join Company as bc on s.BillingCompanyID = bc.CompanyID
		inner join [State] as bcs on bc.StateID = bcs.StateID
		inner join Vehicle as v on w.VehicleID = v.VehicleID
		inner join Manufacturer as vm on v.ManufacturerID = vm.ManufacturerID
		inner join ECD as ecd on w.ECDID = ecd.ECDID
		inner join Manufacturer as ecdm on ecd.ManfacturerID = ecdm.ManufacturerID
		inner join SubstrateType as sut on ecd.SubstrateTypeID = sut.SubstrateTypeID
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