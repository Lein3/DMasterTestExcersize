CREATE PROCEDURE [dbo].[MyBackup] @aTableName varchar(250)
AS
BEGIN
	DECLARE @InsertStatements NVARCHAR(MAX) = ''
	DECLARE @ValuesList NVARCHAR(MAX) = ''
	DECLARE @ColumnList NVARCHAR(MAX) = (SELECT STRING_AGG(COLUMN_NAME, ',')
											FROM INFORMATION_SCHEMA.COLUMNS
											WHERE TABLE_NAME = @aTableName)
	
	DECLARE @i int = 1
	DECLARE @applyQuote bit = 0
	DECLARE @columnValue nvarchar(50)
	DECLARE @columnName nvarchar(50)
	DECLARE @dataType nvarchar(50)
	DECLARE @rowCount int
	declare @query nvarchar(max) = 'SELECT @rowCount = COUNT(*) FROM ' + @aTableName
	EXEC sp_executesql @query, N'@rowCount INT OUTPUT', @rowCount OUTPUT

	SET @InsertStatements = REPLACE('TRUNCATE TABLE {TableName} ', '{TableName}', @aTableName)
	IF (OBJECTPROPERTY(OBJECT_ID(@aTableName), 'TableHasIdentity') = 1)
		SET @InsertStatements = @InsertStatements + REPLACE('SET IDENTITY_INSERT {TableName} ON ', '{TableName}', @aTableName)
	
	WHILE (@i - 1 < @rowCount)
	BEGIN
		DECLARE tableInfo CURSOR FOR
		SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @aTableName
		open tableInfo
		fetch next from tableInfo into @columnName, @dataType
		while @@FETCH_STATUS = 0
		BEGIN
			SET @query = 
			'WITH CTE AS (SELECT *, ROW_NUMBER() over (order by @@Version) as tempID FROM @TableName)
			SELECT @columnValue = @columnName FROM CTE WHERE tempID = @i'
			SET @query = REPLACE(@query, '@TableName', @aTableName)
			SET @query = REPLACE(@query, '@columnName', @columnName)
			SET @query = REPLACE(@query, '@i', @i)	
			
			execute sp_executesql @query, N'@columnValue varchar(50) OUTPUT', @columnValue OUTPUT
			SET @applyQuote = CASE WHEN @dataType like '%CHAR%' OR @dataType like '%DATE%' OR @dataType like '%TIME%' THEN 1 ELSE 0 END
			SET @columnValue = CASE WHEN @applyQuote = 1 THEN '''' + @columnValue + '''' ELSE @columnValue END
			SET @ValuesList = @ValuesList + @columnValue + ', '
			fetch next from tableInfo into @columnName, @dataType
		END
		close tableInfo
		deallocate tableInfo
	
		SET @ValuesList = LEFT(@ValuesList, LEN(@ValuesList) - 1);
		SET @InsertStatements = @InsertStatements + 'INSERT INTO {tableName} ({columnList}) VALUES ({ValuesList})'
		SET @InsertStatements = @InsertStatements + CHAR(10) + CHAR(13)
		SET @InsertStatements = REPLACE(@InsertStatements, '{tableName}', @aTableName)
		SET @InsertStatements = REPLACE(@InsertStatements, '{columnList}', @columnList)
		SET @InsertStatements = REPLACE(@InsertStatements, '{ValuesList}', @ValuesList)
		SET @valuesList = ''
		SET @i = @i + 1
	END

SELECT @InsertStatements;
END
GO