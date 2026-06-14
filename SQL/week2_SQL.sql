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

/*Tasks# 13 BULD USER JOURNEY SEQUENCE

Sort events by User ID and Timestamp
Identify sequential touchpoints
Create user journey paths
Validate journey order
Acceptance Criteria
User journeys generated
Touchpoints correctly sequenced
Journey dataset available for attribution analysis*/


--Sort Events by User ID and Timestamp
SELECT
    UserID,
    EventTimestamp,
    Channel,
    Campaign,
    Conversion
FROM WebAnalytics
ORDER BY UserID, EventTimestamp;

/*Identify Sequential Touchpoints
Use ROW_NUMBER() to assign the order of touchpoints.*/
SELECT
    UserID,
    EventTimestamp,
    Channel,
    Campaign,
    Conversion,
    ROW_NUMBER() OVER (
        PARTITION BY UserID
        ORDER BY EventTimestamp
    ) AS Touchpoint_Order
FROM WebAnalytics;


--Create User Journey Dataset
CREATE VIEW UserJourney AS
SELECT
    UserID,
    EventTimestamp,
    Channel,
    Campaign,
    Conversion,
    ROW_NUMBER() OVER (
        PARTITION BY UserID
        ORDER BY EventTimestamp
    ) AS Touchpoint_Order
FROM WebAnalytics



SELECT TOP 20 *
FROM UserJourney
ORDER BY UserID, Touchpoint_Order;

--Validate Journey Order
SELECT *
FROM UserJourney
WHERE UserID = 10120
ORDER BY Touchpoint_Order;



--Better Validation Query
SELECT
    UserID,
    COUNT(*) AS TotalTouchpoints
FROM UserJourney
GROUP BY UserID
ORDER BY TotalTouchpoints DESC;


--Created Final Journey Path
SELECT
    UserID,
    STRING_AGG(Channel, ' > ')
        WITHIN GROUP (ORDER BY EventTimestamp) AS JourneyPath
FROM WebAnalytics
GROUP BY UserID;




--Save Journey Dataset
SELECT
    UserID,
    EventTimestamp,
    Channel,
    Campaign,
    Conversion,
    ROW_NUMBER() OVER (
        PARTITION BY UserID
        ORDER BY EventTimestamp
    ) AS Touchpoint_Order
INTO UserJourneyDataset
FROM WebAnalytics;

select* from UserJourneyDataset

/*Completed user journey construction by sorting events chronologically for each user and assigning 
touchpoint order usingSQL Window Functions. Generated journey paths and validated sequence integrity. 
Created a reusable UserJourney dataset to support attribution modeling in subsequent project phases.
*/

