CREATE FUNCTION [dbo].[MyDate] (@aDate DATETIME, @aMonth int, @aBegFlag bit)
RETURNS DATETIME
AS
BEGIN
    DECLARE @result DATETIME
    SET @result = DATEADD(MONTH, @aMonth, @aDate)

	SET @result = DATEADD(DAY, 1 - DAY(@result), @result)
	SET @result = cast(@result as date)

    IF @aBegFlag = 0
        SET @result = DATEADD(DAY, -1, DATEADD(MONTH, 1, @result)) + '23:59:59.998'

    RETURN @result
END
GO