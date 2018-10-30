CREATE TABLE [dbo].[Measurements] (
	[MeasurementsID]	INT	NOT NULL IDENTITY,
    [OuterDiameter]     FLOAT (53)   NOT NULL,
    [SubstrateDiameter] FLOAT (53)   NOT NULL,
    [OuterLength]       FLOAT (53)   NOT NULL,
    [SubstrateLength]   FLOAT (53)   NOT NULL,
    [SerialNumber]      NVARCHAR (50) NOT NULL,
    [ManufacturerID]    INT          NOT NULL,
    [PartNumberID]      INT          NOT NULL,
    [ECD_ID]            INT          NOT NULL, 
    CONSTRAINT [PK_Measurements] PRIMARY KEY ([MeasurementsID])
);

