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
		,s.Contact
		,s.TrackingNo
		,0 as WorkOrderStatus
		,w.PreventMaintAshCleanInter
		,w.HighSootCEL
		,w.EngineFailureFluidsInExhaust
		,clean.CleaningReason
		,w.RoadHighway
		,w.StartStop
		,w.HighIdle
		,drive.DrivingType
		,w.[Miles]
		,w.[MPG]
		,w.[Hours]
		,w.[HPG]
		,w.DateAdded as WODate
		,bc.CompanyName as Billing_CompanyName
		,bc.CompanyInitials
		,bc.BillingAddress1
		,bc.BillingAddress2
		,bc.BillingCity
		,bc.BillingZip
		,bcs.[State] 
		,c.CompanyName
		,c.CompanyInitials
		,c.BillingAddress1 as Address1
		,c.BillingAddress2 as Address2
		,c.BillingCity	as City
		,c.BillingZip as Zip
		,cs.[State]
		,cl.[Location]
		,cl.Address1 
		,cl.Address2
		,cl.City
		,cl.Zip
		,st.[State]
		,v.SerialNumber as Vehicle_SerialNumber
		,v.AssetNumber 
		,vm.Manufacturer 
		,v.Model
		,v.[Year]
		,vt.VehicleType
		,v.InitialCleaning
		,em.Manufacturer as Engine_Manufacturer
		,e.SerialNumber
		,e.Model
		,e.Year
		,sut.SubstrateType
		,ecdm.Manufacturer as ECD_Manufacturer
		,dt.DeviceType
		,ecd.TimesCleaned
		,ecd.PartNumber
		,ecd.SerialNumber
		,ecd.OtherNumber
		,ecd.OuterDiameter
		,ecd.SubstrateDiameter
		,ecd.OuterLength
		,ecd.SubstrateLength
		,qaf.QAPresence as AshOnFace
		,qaa.QAColor as AshColor
		,qas.QAPresence as SootOnFace
		,qaaf.QAColor as OutletColor
		,qaso.QASubstrateOveralCondition 
		,qac.QASubstrateCraking
		,qab.QABreachChannels
		,qa.Coolant
		,qa.RedAsh
		,qa.USignalReceived
		,qa.EngineEGRCoolant
		,qa.WearCorrosion
		,qa.FuelOil
		,coalesce(qa.ContaminantsOther, '') as ContaminantsOther
		,qa.CleanChannels
		,qa.TargetMaxSpaceVelocity
		,qa.MaxHertz
		,qa.Summary
		,qa.PinTest
		,s.LegacyJobID
		,he.Location as CleaingLocation
		,he.Address1 as CleaningAddress1
		,he.Address2 as CleaningAddress2
		,he.City as CleaningCity
		,hes.State as CleaningState
		,he.Zip as CleaningZip
	FROM WorkOrder as w
		inner join Sales as s on w.SalesID = s.SalesID
		inner join CompanyLocations as cl on s.CompanyLocationsID = cl.CompanyLocationsID
		inner join [State] as st on cl.StateID = st.StateID
		inner join Company as c on s.CompanyID = c.CompanyID
		inner join [State] as cs on c.StateID = cs.StateID
		inner join Company as bc on s.BillingCompanyID = bc.CompanyID
		inner join [State] as bcs on bc.StateID = bcs.StateID
		left join Vehicle as v on w.VehicleID = v.VehicleID
		left join VehicleType as vt on v.VehicleTypeID = vt.VehicleTypeID
		left join Manufacturer as vm on v.ManufacturerID = vm.ManufacturerID
		left join ECD as ecd on w.WorkOrderID = ecd.WorkOrderID
		left join Manufacturer as ecdm on ecd.ManufacturerID = ecdm.ManufacturerID
		left join SubstrateType as sut on ecd.SubstrateTypeID = sut.SubstrateTypeID
		left join DeviceType as dt on ecd.DeviceTypeID = dt.DeviceTypeID
		left join Engine as e on w.EngineID = e.EngineID
		left join Manufacturer as em on e.ManufacturerID = em.ManufacturerID
		left join QA as  qa on   w.WorkOrderID = qa.WorkOrderID
		left outer join CleaningReason as clean on w.CleaningReasonID = clean.CleaningReasonID
		left outer join DrivingType as drive on w.DrivingTypeID = drive.DrivingTypeID
		left join QAPresence as qaf on qa.QAAshOnFaceID = qaf.QAPresenceID
		left join QAPresence as qas on qa.QASootOnFaceID = qas.QAPresenceID
		left join QAColor as qaa on qa.QAAshColorID = qaa.QAColorID
		left join QAColor as qaaf on qa.QAOutletColorID = qaaf.QAColorID
		left join QASubstrateOveralCondition as qaso on qa.QASubstrateOveralConditionID = qaso.QASubstrateOveralConditionID
		left join QASubstrateCraking as qac on qa.QASubstrateCrakingID = qac.QASubstrateCrakingID
		left join QABreachChannels as qab on qa.QABreachChannelsID = qab.QABreachChannelsID
		left join CompanyLocations as he on s.CleaningLocationID = he.CompanyLocationsID
		left join State as hes on he.StateID = hes.StateID
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