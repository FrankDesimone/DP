CREATE TABLE [dbo].[CleaningReason] (
    [CleaningReasonID]          INT NOT NULL IDENTITY,
    [CleaningReason] NVARCHAR(100) NOT NULL, 
    CONSTRAINT [PK_CleaningReason] PRIMARY KEY ([CleaningReasonID])
);


GO

CREATE UNIQUE INDEX [IX_CleaningReason_CleaningReason] ON [dbo].[CleaningReason] ([CleaningReasonID])
