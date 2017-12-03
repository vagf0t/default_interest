

CREATE FUNCTION [dbo].[DefaultInterest] (@AMOUNT float, @DATE1 datetime, @DATE2 datetime)  
RETURNS float  
AS  
BEGIN  
     DECLARE @Interest float;
	 DECLARE @PartialInterest float;
	 DECLARE @Rate float;  
	 DECLARE @UpperDate datetime;

     Select @Rate=YRate, @UpperDate=COALESCE(DateTo, GETDATE()) from dbo.almRates where @DATE1 between DateFrom and COALESCE(DateTo, GETDATE());

	 IF (@DATE2 <= @UpperDate)
	   SET @Interest = @AMOUNT * DATEDIFF(day, @DATE1, @DATE2) * @Rate / DATEDIFF(day,  cast(Year(@DATE1) as char(4)),  cast(Year(@DATE1)+1 as char(4)));
     ELSE
	 BEGIN
	   SET @PartialInterest = @AMOUNT * DATEDIFF(day, @DATE1, @UpperDate) * @Rate / DATEDIFF(day,  cast(Year(@DATE1) as char(4)),  cast(Year(@DATE1)+1 as char(4)));
	   SET @Interest = @PartialInterest + dbo.DefaultInterest(@AMOUNT,  DATEADD(day, 1, @UpperDate), @DATE2);
	 END;
     RETURN(@Interest);  
END;  




GO


