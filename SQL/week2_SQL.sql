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


/*Assign 100% conversion credit to the first marketing touchpoint in each user journey.
Identify first touchpoint per user
Assign conversion credit
Aggregate channel performance
Validate attribution results
Acceptance Criteria
First-touch attribution model created
Channel contribution calculated
Results documented
*/
--Identify First Touchpoint Per User
WITH FirstTouch AS
(
    SELECT
        UserID,
        Channel,
        Campaign,
        Conversion,
        EventTimestamp,
        ROW_NUMBER() OVER (
            PARTITION BY UserID
            ORDER BY EventTimestamp
        ) AS Touchpoint_Order
    FROM WebAnalytics
)

SELECT *
FROM FirstTouch
WHERE Touchpoint_Order = 1;

--Assign Conversion Credit
WITH FirstTouch AS
(
    SELECT
        UserID,
        Channel,
        Campaign,
        Conversion,
        ROW_NUMBER() OVER (
            PARTITION BY UserID
            ORDER BY EventTimestamp
        ) AS Touchpoint_Order
    FROM WebAnalytics
)

SELECT
    UserID,
    Channel,
    Campaign,
    1 AS Conversion_Credit
FROM FirstTouch
WHERE Touchpoint_Order = 1
AND Conversion = 'Yes';

--Aggregate Channel Performance
WITH FirstTouch AS
(
    SELECT
        UserID,
        Channel,
        Conversion,
        ROW_NUMBER() OVER (
            PARTITION BY UserID
            ORDER BY EventTimestamp
        ) AS Touchpoint_Order
    FROM WebAnalytics
)

SELECT
    Channel,
    COUNT(*) AS FirstTouch_Conversions
FROM FirstTouch
WHERE Touchpoint_Order = 1
AND Conversion = 'Yes'
GROUP BY Channel
ORDER BY FirstTouch_Conversions DESC;

--Validate Attribution Results

WITH FirstTouch AS
(
    SELECT
        UserID,
        Channel,
        EventTimestamp,
        ROW_NUMBER() OVER (
            PARTITION BY UserID
            ORDER BY EventTimestamp
        ) AS Touchpoint_Order
    FROM WebAnalytics
)

SELECT *
FROM FirstTouch
WHERE UserID = 10062;

---Create a Table
WITH FirstTouch AS
(
    SELECT
        UserID,
        Channel,
        Campaign,
        Conversion,
        ROW_NUMBER() OVER (
            PARTITION BY UserID
            ORDER BY EventTimestamp
        ) AS Touchpoint_Order
    FROM WebAnalytics
)

SELECT
    UserID,
    Channel,
    Campaign,
    Conversion
INTO FirstTouchAttribution
FROM FirstTouch
WHERE Touchpoint_Order = 1;

select* from FirstTouchAttribution
/*- Search Ads received the highest first-touch attribution credit, indicating strong performance in customer acquisition.
- Social Media was the second-largest contributor to new customer journeys.*/


--Identify last touchpoint per user Assign conversion credit
--Identify Last Touchpoint Per User
WITH LastTouch AS
(
    SELECT
        UserID,
        Channel,
        Campaign,
        Conversion,
        EventTimestamp,
        ROW_NUMBER() OVER (
            PARTITION BY UserID
            ORDER BY EventTimestamp DESC
        ) AS Touchpoint_Order
    FROM WebAnalytics
)

SELECT *
FROM LastTouch
WHERE Touchpoint_Order = 1;


--Assign Conversion Credit
WITH LastTouch AS
(
    SELECT
        UserID,
        Channel,
        Campaign,
        Conversion,
        ROW_NUMBER() OVER (
            PARTITION BY UserID
            ORDER BY EventTimestamp DESC
        ) AS Touchpoint_Order
    FROM WebAnalytics
)

SELECT
    UserID,
    Channel,
    Campaign,
    1 AS Conversion_Credit
FROM LastTouch
WHERE Touchpoint_Order = 1
AND Conversion = 'Yes';


--Aggregate Channel Performance
WITH LastTouch AS
(
    SELECT
        UserID,
        Channel,
        Conversion,
        ROW_NUMBER() OVER (
            PARTITION BY UserID
            ORDER BY EventTimestamp DESC
        ) AS Touchpoint_Order
    FROM WebAnalytics
)

SELECT
    Channel,
    COUNT(*) AS LastTouch_Conversions
FROM LastTouch
WHERE Touchpoint_Order = 1
AND Conversion = 'Yes'
GROUP BY Channel
ORDER BY LastTouch_Conversions DESC;

--Compare with First-Touch Results
WITH FirstTouch AS
(
    SELECT
        Channel,
        COUNT(*) AS FirstTouch_Conversions
    FROM
    (
        SELECT
            UserID,
            Channel,
            ROW_NUMBER() OVER(
                PARTITION BY UserID
                ORDER BY EventTimestamp
            ) AS rn
        FROM WebAnalytics
    ) t
    WHERE rn = 1
    GROUP BY Channel
),

LastTouch AS
(
    SELECT
        Channel,
        COUNT(*) AS LastTouch_Conversions
    FROM
    (
        SELECT
            UserID,
            Channel,
            ROW_NUMBER() OVER(
                PARTITION BY UserID
                ORDER BY EventTimestamp DESC
            ) AS rn
        FROM WebAnalytics
    ) t
    WHERE rn = 1
    GROUP BY Channel
)

SELECT
    f.Channel,
    f.FirstTouch_Conversions,
    l.LastTouch_Conversions
FROM FirstTouch f
JOIN LastTouch l
    ON f.Channel = l.Channel;
/*Last-Touch Attribution Insights
Implemented a Last-Touch Attribution model that assigns 100% conversion credit to the final marketing interaction before conversion.
Analysis identified the channels most effective at driving conversions and highlighted differences between acquisition-focused and conversion-focused channels.
Attribution results were validated and prepared for marketing performance reporting and dashboard integration.