CREATE DATABASE MarketingAttributionDB; --created a database named marketing attribution
use MarketingAttributionDB

--  create table for cleaned " multi_touch_attribution_data"
CREATE TABLE WebAnalytics (
    UserID INT,
    EventTimestamp DATETIME,
    Channel VARCHAR(50),
    Campaign VARCHAR(100),
    Conversion VARCHAR(10)
); 
--create table for "ad_spend"
CREATE TABLE AdSpend (
    SpendDate DATE,
    Channel VARCHAR(50),
    Campaign VARCHAR(100),
    DailySpend DECIMAL(18,2)
);
--create table for final_attribution_data"
CREATE TABLE CRMRevenue (
    UserID INT,
    EventTimestamp DATETIME,
    Channel VARCHAR(50),
    Campaign VARCHAR(100),
    Conversion VARCHAR(10),
    Revenue DECIMAL(18,2)
);
SELECT TOP 5 * FROM WebAnalytics;
SELECT TOP 5 * FROM AdSpend;
SELECT TOP 5 * FROM CRMRevenue;

--Verify:
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE='BASE TABLE';

--Created Primary Keys and Indexes
ALTER TABLE WebAnalytics
ADD EventID INT IDENTITY(1,1) PRIMARY KEY;

ALTER TABLE AdSpend
ADD SpendID INT IDENTITY(1,1) PRIMARY KEY;

ALTER TABLE CRMRevenue
ADD ConversionID INT IDENTITY(1,1) PRIMARY KEY;
--Indexes created
CREATE INDEX IX_WebAnalytics_UserID
ON WebAnalytics(UserID);

CREATE INDEX IX_WebAnalytics_Time
ON WebAnalytics(EventTimestamp);

CREATE INDEX IX_CRMRevenue_UserID
ON CRMRevenue(UserID);

CREATE INDEX IX_AdSpend_Channel
ON AdSpend(Channel);


--Verify indexes:
SELECT name
FROM sys.indexes
WHERE object_id = OBJECT_ID('WebAnalytics');

--Verify Database Connectivity
SELECT @@SERVERNAME AS ServerName;
SELECT DB_NAME() AS DatabaseName;

SELECT TOP 5 *
FROM WebAnalytics;



/*Database in Object Explorer
Three tables visible
Successful query output
Index creation statements
Row count queries after import */

SELECT COUNT(*)as total FROM WebAnalytics;
SELECT COUNT(*) as tspend FROM AdSpend;
SELECT COUNT(*) as trevenue FROM CRMRevenue;