CREATE TABLE [dbo].[Exceptions](
    [ExceptionsID]        INT              IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ReportingProcedure]  VARCHAR (250)    NULL,
    [ErrorNumber]         INT              NULL,
    [ErrorLine]           INT              NULL,
    [ErrorMessage]        VARCHAR (500)    NULL,
    [ErrorNote]           VARCHAR (8000)    NULL,
    [DateAdd]             DATETIME         DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tlbExceptions] PRIMARY KEY CLUSTERED ([ExceptionsID] ASC)
);
