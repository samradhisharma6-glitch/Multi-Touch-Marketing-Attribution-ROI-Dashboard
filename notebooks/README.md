# **Jupyter notebook for EDA and analysis**

Week\_1\_EDA

completed issues #1,#2,#3,#4

\## Key Insights



1\. Total records: 10,000

2\. Unique users: 2,847

3\. No missing values detected.

4\. No duplicate records found.

5\. Most users interacted multiple times before conversion.

6\. Search Ads generated the highest number of conversions.

7\. Email campaigns showed strong engagement.

8\. User journey lengths varied significantly across users.



\#task 5 solved and found that Data Quality Assessment



The provided Web Analytics dataset was inspected for missing values and marketing attribution fields.



Findings:



\* No missing values were detected in the available columns.

\* The dataset contains the following fields:



&#x20; \* User ID

&#x20; \* Timestamp

&#x20; \* Channel

&#x20; \* Campaign

&#x20; \* Conversion

\* UTM parameters (utm\_source, utm\_medium, utm\_campaign, utm\_term, utm\_content) were not present in the source dataset.



Action Taken:



\* Verified dataset completeness using Pandas null-value analysis.

\* Confirmed no UTM fields were available for standardization or imputation.

\* Documented dataset limitations for future attribution model development.



Conclusion:

No UTM cleaning was required because UTM-related attributes were not provided in the source data.



issues #6

\## Timestamp Standardization Report



\- Timestamp column identified successfully.

\- Converted Timestamp field to datetime64\[ns].

\- No invalid date values detected.

\- No time zone information was present in the source data.

\- All timestamps standardized for downstream analysis.

