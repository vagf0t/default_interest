
ALTER FUNCTION [dbo].[DefaultInterest] (@AMOUNT float, @DATE1 datetime, @DATE2 datetime)  
RETURNS float  
AS  
BEGIN  
    DECLARE @Interest float;
	DECLARE @Rate float;  
	DECLARE @UpperDate datetime;

    Select @Rate=YRate, @UpperDate=COALESCE(DateTo, GETDATE()) from dbo.almRates where @DATE1 between DateFrom and COALESCE(DateTo, GETDATE());
	IF @UpperDate <= @DATE2
		SET @Interest = @AMOUNT * DATEDIFF(day, @DATE1, @UpperDate) * @Rate / DATEDIFF(day,  cast(Year(@DATE1) as char(4)),  cast(Year(@DATE1)+1 as char(4)));
    ELSE 
		SET @Interest = @AMOUNT * DATEDIFF(day, @DATE1, @DATE2) * @Rate / DATEDIFF(day,  cast(Year(@DATE1) as char(4)),  cast(Year(@DATE1)+1 as char(4)));
	WHILE @DATE2 > @UpperDate
	BEGIN
	    SET @DATE1 = DATEADD(day, 1, @UpperDate);
	    Select @Rate=YRate, @UpperDate=COALESCE(DateTo, GETDATE()) from dbo.almRates where @DATE1 between DateFrom and COALESCE(DateTo, GETDATE());
		IF @UpperDate <= @DATE2
			SET @Interest = @Interest + @AMOUNT * DATEDIFF(day, @DATE1, @UpperDate) * @Rate / DATEDIFF(day,  cast(Year(@DATE1) as char(4)),  cast(Year(@DATE1)+1 as char(4)));
		ELSE 
			SET @Interest = @Interest + @AMOUNT * DATEDIFF(day, @DATE1, @DATE2) * @Rate / DATEDIFF(day,  cast(Year(@DATE1) as char(4)),  cast(Year(@DATE1)+1 as char(4)));
	END;
	 
    RETURN(@Interest);  
END;  




GO


