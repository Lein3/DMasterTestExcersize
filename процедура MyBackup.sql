CREATE PROCEDURE [dbo].[MyBackup] @aTableName varchar(250)
AS
BEGIN
	DECLARE @Result varchar(max)
	DECLARE @columnList varchar(max) =	(SELECT STRING_AGG(COLUMN_NAME, ',')
										FROM INFORMATION_SCHEMA.COLUMNS
										WHERE TABLE_NAME = @aTableName)
	IF @columnList is null
		THROW 50000, 'Ќе существует таблицы с указанным именем', 1

	SET @Result = 
	'
	SELECT * INTO #tempTable FROM {tableName}
	TRUNCATE TABLE {tableName}
	SET IDENTITY_INSERT {tableName} ON
	INSERT INTO {tableName} ({columnList}) SELECT * FROM #tempTable
	SET IDENTITY_INSERT {tableName} OFF
	DROP TABLE #tempTable
	'

	SET @Result = REPLACE(@Result, '{tableName}', @aTableName)
	SET @Result = REPLACE(@Result, '{columnList}', @columnList)
	SELECT @Result
END
GO


