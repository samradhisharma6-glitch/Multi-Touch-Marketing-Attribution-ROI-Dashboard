# SQL queries and attribution logic (week 2)



Current Status: Database Setup Completed-DAY1

\- Created SQL Server database for marketing attribution analysis.

\- Designed and created tables to store marketing, CRM, and conversion data.

\- Defined primary keys to ensure record uniqueness.

\- Added indexes to improve query performance.

\- Imported cleaned marketing attribution dataset into SQL Server.

\- Verified successful data import through row count validation.

\- Tested database connectivity and table accessibility.





\## Key Insights day2



\* User journeys were successfully reconstructed by ordering events using UserID and EventTimestamp.

\* Sequential touchpoints were identified using SQL Window Functions (ROW\_NUMBER).

\* Most users interacted with multiple marketing channels before conversion.

\* Journey paths revealed common channel transitions such as Email → Social Media → Search Ads.

\* Touchpoint ordering enables attribution modeling by accurately identifying first and last interactions.

\* A dedicated UserJourney dataset was created for downstream attribution analysis.

\* Customer journeys vary significantly in length, highlighting the importance of multi-touch attribution rather than relying solely on a single interaction.\\



\## key insights day 3 # issue 13,14

\## First Touch Attribution Insights



\* First-touch attribution was implemented by assigning 100% conversion credit to the earliest marketing interaction in each user journey.

\* SQL Window Functions were used to identify the first touchpoint for every user based on chronological event order.

\* Channel-level attribution analysis revealed which marketing channels were most effective at acquiring new users.

\* The model highlights acquisition-focused channels that initiate customer journeys rather than those that close conversions.

\* Attribution results provide a baseline for comparison with Last-Touch and Linear Attribution models.

\* Channel contribution metrics were successfully generated and can be used for marketing performance evaluation.

\* The first-touch attribution dataset is ready for integration into dashboard reporting and ROI analysis.



\## key insight day 4 # issue 15,16

\## Last Touch Attribution Insights



\* Last-touch attribution assigns 100% conversion credit to the final marketing interaction before conversion.

\* SQL Window Functions were used to identify the most recent touchpoint in each user journey.

\* Channel-level attribution results highlighted the channels most effective at driving conversions.

\* Comparison with First-Touch Attribution revealed differences between acquisition-focused and conversion-focused channels.

\* Some channels generated strong closing performance despite receiving lower first-touch credit.

\* The attribution model provides valuable insight into which channels influence final conversion decisions.

\* Results were validated and prepared for dashboard reporting and marketing performance analysis.





\##Key Insights DAY 5 # ISSUE 17

\##Distribute conversion credit equally across all touchpoints in the customer journey.

Implemented a Linear Attribution model that distributes conversion credit equally across all touchpoints in a customer journey.

Attribution weights were calculated based on the total number of touchpoints per user, ensuring fair credit allocation across channels.

Channel-level attribution analysis provided a balanced view of marketing contribution and highlighted the collective impact of multiple interactions on conversions.



&#x20;Issue #19

Key Insights

CPC was calculated by dividing total advertising spend by total clicks for each marketing channel and campaign.

Channel-level comparison identified variations in advertising efficiency and cost effectiveness.

Results were validated successfully and provide insight into traffic acquisition costs across channels.



issue 20

Key Insights

Customer Acquisition Cost (CAC) was calculated by dividing total marketing spend by the number of converted customers.

The metric provides insight into the average cost required to acquire a customer through marketing activities.

CAC results were validated and prepared for KPI reporting and performance analysis.



issue 21,22

key insights

ROAS was calculated by comparing attributed revenue against total advertising spend.

Channel-level analysis identified the marketing channels generating the highest return on investment.

Results were validated and provide a clear measure of marketing effectiveness and profitability.





issue 23

key insights

A star schema was designed to support marketing attribution reporting and Power BI dashboard development.

FactMarketingPerformance serves as the central fact table containing spend, revenue, conversion, and attribution metrics.

Dimension tables for Date, Channel, Campaign, and User provide flexible filtering and aggregation capabilities.



issue 24

Key Insights 

Created a centralized fact table integrating spend, revenue, conversion, and attribution metrics from marketing datasets.

Successfully loaded attribution data and validated key performance metrics.

The fact table is ready for Power BI reporting and dimensional modeling.





issue 24

Key Insights

Integrated conversion and revenue data into a centralized fact table.

Successfully loaded marketing performance metrics for attribution analysis.

Data validation confirmed row counts and revenue totals were loaded correctly.



issue 25

Key Insights



Created dimension tables for channel, campaign, user, and date analysis.

Loaded unique values from source datasets and established relationships with the fact table.

The dimensional model supports Power BI reporting, KPI analysis, and marketing attribution dashboards.

















