If (db_id('HW10') IS NOT NULL)
	DROP DATABASE HW10;

CREATE DATABASE HW10;  
GO  

use HW10;
Go

SET NOCOUNT ON;

IF EXISTS (SELECT * FROM sys.objects 
		WHERE object_id = OBJECT_ID('Employees'))
			  DROP TABLE Employees;
GO

CREATE TABLE Employees 
(ID int IDENTITY(1,1) PRIMARY KEY CLUSTERED,
 BadgeNum INT NOT NULL UNIQUE,
 Title varchar(20),
 DATEHired DateTime2 NOT NULL
); 


--Populate Table
DECLARE @Counter INT = 1;
DECLARE @RNDNUM INT;
WHILE @Counter < 26 BEGIN
	SET @RNDNUM = CAST(RAND() * 1000 AS INT); 
	IF NOT EXISTS (SELECT BadgeNum from dbo.Employees WHERE BadgeNum = @RNDNUM) 
		BEGIN
		INSERT INTO dbo.Employees (BadgeNum, Title, DATEHired)
		VALUES (@RNDNUM,'Null', GETDATE());
		SET @Counter += 1;
		END;
	ELSE BEGIN
		Continue;
	END;
END;
GO



--TRIGGER
CREATE TRIGGER UpdateTitle on dbo.Employees
AFTER INSERT
AS
DECLARE @BadgeNum INT;

select @BadgeNum = BadgeNum
from inserted

	IF @BadgeNum BETWEEN 0 and 300 BEGIN
		UPDATE dbo.Employees SET Title = 'Clerk' WHERE BadgeNum = @BadgeNum
	END
	ELSE
	IF @BadgeNum BETWEEN 300 and 600 BEGIN
		UPDATE dbo.Employees SET Title = 'Office Employee' WHERE BadgeNum = @BadgeNum
	END
	ELSE
	IF @BadgeNum BETWEEN 700 and 800 BEGIN
		UPDATE dbo.Employees SET Title = 'Manager' WHERE BadgeNum = @BadgeNum
	END
	ELSE
	IF @BadgeNum BETWEEN 900 and 1000 BEGIN
		UPDATE dbo.Employees SET Title = 'Director' WHERE BadgeNum = @BadgeNum
	END
GO


--CURSOR
DECLARE @BadgeNum INT;
DECLARE @Title varchar(20);
DECLARE @DATEHired DateTime2
DECLARE Empl CURSOR FAST_FORWARD FOR
	SELECT BadgeNum, Title, DATEHired from dbo.Employees;

OPEN Empl;

FETCH NEXT FROM Empl into @BadgeNum, @Title, @DATEHired;

WHILE @@FETCH_STATUS = 0 BEGIN
	PRINT 'BadgeNum = ' + CONVERT(NVARCHAR(4), @BadgeNum) + ' Title = ' + @Title + ' DATEHired = ' + CONVERT(NVARCHAR(30), @DATEHired)
	FETCH NEXT FROM Empl INTO @BadgeNum, @Title, @DATEHired;
END;
CLOSE Empl;
DEALLOCATE Empl

