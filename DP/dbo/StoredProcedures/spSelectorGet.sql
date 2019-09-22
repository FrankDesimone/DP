CREATE PROCEDURE [dbo].[spSelectorsGet]
	@Selector VARCHAR(50) 
	,@Filter as varchar(500) = null
	,@IsFilter as bit = 1
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = '';
	set @Filter = (case when len(coalesce(@Filter, '')) = 0 then null else @Filter end);

	IF @Selector ='workorder'  
	BEGIN
		select Null as WorkOrderID
			,'Please Select' as WorkOrder
			,0 as Sortkey
		union all
		select w.WorkOrderID
			,convert(nvarchar(100),w.WorkOrderID) as WorkOrder
			,1 as SortKey
		from WorkOrder as w
		where w.SalesID = try_cast(@Filter as int)
		order by Sortkey, WorkOrderID desc;
		
		goto ExitProc;
	END

	IF @Selector ='salesno'  
	BEGIN
		select Null as SalesID
			,'Please Select' as SalesNo
			,0 as Sortkey
			,getdate() as DateAdded
		union all
		select top 10 s.SalesID
			,s.SalesNo
			,1 as SortKey
			,s.DateAdded
		from Sales as s
		where s.BillingCompanyID = try_cast(@Filter as int)
			or @Filter is null
		order by Sortkey, SalesID desc;
		
		goto ExitProc;
	END

	IF @Selector ='company' 
	BEGIN
		select Null as CompanyID
			,'Please Select' as CompanyName
			,1 as Sortkey
		where (case
			when @Filter = 'ALL' then @True
			when @Filter is null then @True
			else @False end) = @True
		union
		select c.CompanyID
			,c.CompanyName
			,2 as SortKey
		from Company as c
		where (case
			when @Filter = 'ALL' then @True
			when @Filter is not null then @False
			when c.CompanyID = 0 then @False
			when c.Active = @False then @False
			else @True end) = @True
		union
		select s.CompanyID
			,c.CompanyName
			,3 as SortKey
		from Sales as s
			inner join Company as c on s.CompanyID = c.CompanyID
		where s.SalesID = try_cast(@Filter as int)
		order by SortKey, CompanyName;

		goto ExitProc;
	END

	IF @Selector ='billingcompany' 
	BEGIN
		select Null as CompanyID
			,'Please Select' as CompanyName
			,1 as Sortkey
		where @Filter is null
		union
		select c.CompanyID
			,c.CompanyName
			,2 as SortKey
		from Company as c
		where c.Active = @True
			and @Filter is null
		union
		select c.CompanyID
			,c.CompanyName
			,3 as SortKey
		from Sales as s 
			inner join Company as c on s.BillingCompanyID = c.CompanyID
		where s.SalesID = try_cast(@Filter as int)
		order by SortKey, CompanyName;

		goto ExitProc;
	END

	IF @Selector = 'companylocations' 
	BEGIN
		select Null as CompanyLocationsID
			,'Please Select' as [Location]
			,0 as Sortkey
		union all
		select cl.CompanyLocationsID 
			,cl.Location
			,1 as SortKey
		from CompanyLocations as cl
		where cl.CompanyID = try_cast(@Filter as int)
		order by SortKey;

		goto ExitProc;
	END

	IF @Selector = 'contacts' 
	BEGIN
		select Null as ContactsID
			,'Please Select' as Contact
			,0 as Sortkey
		union all
		select c.ContactsID
			,c.FirstName + ' ' + c.LastName as Contact
			,1 as SortKey
		from [Contacts] as c
		where c.CompanyID = try_cast(@Filter as int)
		order by SortKey;

		goto ExitProc;
	END
	
	IF @Selector = 'state' 
	BEGIN
		select Null as StateID
			,'Please Select' as StateName
			,0 as Sortkey
		union all
		select s.StateID
			,s.StateName
			,1 as SortKey
		from [State] as s
		order by SortKey;

		goto ExitProc;
	END
				  
	IF @Selector = 'manufacturer' 
	BEGIN
		select Null as [ManufacturerID]
			,'Please Select' as [Manufacturer]
			,0 as Sortkey
		union all
		SELECT   m.[ManufacturerID]
			,m.[Manufacturer]
			,1 as SortKey
		FROM [dbo].[Manufacturer] as m;

		goto ExitProc;
	END

	IF @Selector = 'vehicle' 
	BEGIN
		select Null as [VehicleID]
			,'Please Select' as [Vehicle]
			,0 as Sortkey
		union all
		SELECT  [VehicleID]
			,v.[SerialNumber] + ' / ' + v.AssetNumber as Vehicle
			,1 as SortKey
		from [dbo].[Vehicle] as v
		where v.CompanyID = try_cast(@Filter as int)
		order by SortKey;

		goto ExitProc;
	END

	IF @Selector = 'engine' 
	BEGIN
		select Null as [EngineID]
			,'Please Select' as Engine
			,0 as Sortkey
		union all
		SELECT  EngineID
			,e.SerialNumber + ' / ' + e.Model as Engine
			,1 as SortKey
		from [dbo].Engine as e
		where e.CompanyID = try_cast(@Filter as int)
		order by SortKey;

		goto ExitProc;
	END

	IF @Selector = 'ecd' 
	BEGIN
		select Null as [ECDID]
			,'Please Select' as ECD
			,0 as Sortkey
		from WorkOrder as w
			left outer join ECD as e on w.WorkOrderID = e.WorkOrderID
		where w.WorkOrderID = try_cast(@Filter as int)
			and e.WorkOrderID is null
		union all
		SELECT  [ECDID]
			,ecd.SerialNumber + ' / ' + ecd.[PartNumber] as ECD
			,1 as SortKey
		from [dbo].[ECD] as  ecd
		where ecd.WorkOrderID = try_cast(@Filter as int)
		order by SortKey;

		goto ExitProc;
	END


	IF @Selector = 'substratetype' 
	BEGIN
		select Null as SubstrateTypeID
			,'Please Select' as SubstrateType
			,0 as Sortkey
		union all
		SELECT  st.SubstrateTypeID
			,st.SubstrateType
			,1 as SortKey
		from [dbo].SubstrateType as  st
		order by SortKey;

		goto ExitProc;
	END


	IF @Selector = 'devicetype' 
	BEGIN
		select Null as DeviceTypeID
			,'Please Select' as DeviceType
			,0 as Sortkey
		union all
		SELECT  dt.DeviceTypeID 
			,dt.DeviceType 
			,1 as SortKey
		from [dbo].DeviceType as  dt
		order by SortKey;

		goto ExitProc;
	END

	IF @Selector = 'drivingtype' 
	BEGIN
		select Null as DrivingTypeID
			,'Please Select' as DrivingType
			,0 as Sortkey
		union all
		SELECT  dt.DrivingTypeID 
			,dt.DrivingType 
			,1 as SortKey
		from [dbo].DrivingType  as  dt
		order by SortKey;

		goto ExitProc;
	END

	IF @Selector = 'cleaningreason' 
	BEGIN
		select Null as [CleaningReasonID]
			,'Please Select' as [CleaningReason]
			,0 as Sortkey
		union all
		SELECT  cr.CleaningReasonID 
			,cr.CleaningReason 
			,1 as SortKey
		from [dbo].CleaningReason  as  cr
		order by SortKey;

		goto ExitProc;
	END

	IF @Selector in ('qasootonface', 'qaashonface')
	BEGIN
		select Null as QAPresenceID
			,'Please Select' as QAPresence
			,0 as Sortkey
		union all
		SELECT  qa.QAPresenceID
			,qa.QAPresence
			,1 as SortKey
		from QAPresence as qa
		order by SortKey, QAPresenceID;

		goto ExitProc;
	END

	IF @Selector = 'qaashcolor' 
	BEGIN
		select Null as QAAshColorID
			,'Please Select' as QAAshColor
			,0 as Sortkey
		union all
		SELECT  qa.QAColorID
			,qa.QAColor
			,1 as SortKey
		from QAColor as qa
		order by SortKey, QAAshColorID;

		goto ExitProc;
	END

	IF @Selector = 'qabreachchannels' 
	BEGIN
		select Null as QABreachChannelsID
			,'Please Select' as QABreachChannels
			,0 as Sortkey
		union all
		SELECT  qa.QABreachChannelsID
			,qa.QABreachChannels
			,1 as SortKey
		from QABreachChannels as qa
		order by SortKey, QABreachChannelsID;

		goto ExitProc;
	END
	
	IF @Selector = 'qasubstratecraking' 
	BEGIN
		select Null as QASubstrateCrakingID
			,'Please Select' as QASubstrateCraking
			,0 as Sortkey
		union all
		SELECT  qa.QASubstrateCrakingID
			,qa.QASubstrateCraking
			,1 as SortKey
		from QASubstrateCraking as qa
		order by SortKey, QASubstrateCrakingID;

		goto ExitProc;
	END

	IF @Selector = 'qasubstrateoveralcondition' 
	BEGIN
		select Null as QASubstrateOveralConditionID
			,'Please Select' as QASubstrateOveralCondition
			,0 as Sortkey
		union all
		SELECT  qa.QASubstrateOveralConditionID
			,qa.QASubstrateOveralCondition
			,1 as SortKey
		from QASubstrateOveralCondition as qa
		order by SortKey, QASubstrateOveralConditionID;

		goto ExitProc;
	END

	IF @Selector = 'vehicletype' 
	BEGIN
		SELECT vt.VehicleTypeID
			,vt.VehicleType
		from VehicleType as vt
		order by vt.VehicleTypeID;

		goto ExitProc;
	END


ExitProc:

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[spSelectorsGet] :: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH	