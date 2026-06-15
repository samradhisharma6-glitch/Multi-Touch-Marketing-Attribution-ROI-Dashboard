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



