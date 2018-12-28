CREATE TABLE [dbo].[DropdownValues]
(
    [DropdownValuesID] INT NOT NULL, 
    [DropdownMasterID] INT NOT NULL, 
    [DropdownValues] NCHAR(10) NOT NULL, 
    CONSTRAINT [PK_DropdownValues] PRIMARY KEY ([DropdownValuesID]), 
    CONSTRAINT [FK_DropdownValues_DropdownMaster] FOREIGN KEY ([DropdownMasterID]) REFERENCES [DropdownMaster]([DropdownMasterID])
)

GO

CREATE INDEX [IX_DropdownValues_DropdownMasterID] ON [dbo].[DropdownValues] ([DropdownMasterID])
