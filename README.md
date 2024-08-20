# Online UK Retail Store Analysis

## Overview
This repository contains the data analysis project for the Online UK Retail Store, conducted as part of STAT30340 Data Programming with R. The analysis focuses on exploring and providing insights into the sales patterns, customer behaviors, and product performance specific to the UK market segment of the online retail store. 

## Project Description
The project involves detailed exploratory data analysis (EDA) of the Online Retail dataset available from the UCI Machine Learning Repository. The analysis uses a combination of numerical and graphical methods to derive insights that could potentially aid in improving sales and customer engagement strategies.

### Goals
- Identify key trends and patterns in the purchasing behavior of customers.
- Analyze the sales performance of different product categories.
- Provide actionable insights to enhance marketing and sales strategies.

### Data Source
The dataset used in this project can be found at: [Online Retail Data Set](https://archive.ics.uci.edu/dataset/352/online+retail). It includes a mix of categorical and numerical variables such as InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, and Country.

## Repository Contents
- `Online_Retail_Analysis.Rmd`: Quarto document containing the complete analysis, from data loading to advanced visualizations.
- `Online_Retail.xlsx`: The dataset file used in the analysis.
- `functions/`: This directory contains custom R scripts used for data cleaning, processing, and analysis.
- `figures/`: Generated plots and figures saved from the analysis.
- `output/`: Any output files including processed data and final summaries.

## Key Findings
- **Sales Optimization**: Identified peak sales periods and low-demand phases, suggesting optimal times for promotions and stock adjustments.
- **Customer Insights**: Analyzed customer purchase patterns to identify valuable customers and potential target segments for marketing campaigns.
- **Product Performance**: Highlighted top-performing products and categories, providing a basis for inventory prioritization.

### Impact on Sales
The analysis led to a better understanding of sales dynamics, which enabled the retail store to:
- **Improve Stock Management**: Adjust stock levels based on seasonal and trend-based demand predictions.
- **Enhance Customer Engagement**: Tailor marketing strategies to customer preferences and purchasing behavior, leading to improved customer retention and acquisition.
- **Optimize Pricing Strategies**: Adjust pricing based on product performance and customer sensitivity, potentially increasing overall profitability.

## Technologies Used
- R Programming Language
- Tidyverse: For data manipulation and visualization
- Lubridate: For handling date-time data
- Readxl: For reading Excel files
- ggplot2: For creating advanced visualizations

## How to Run the Project
1. Clone this repository to your local machine.
2. Open the R project file `Online_Retail_Analysis.Rproj`.
3. Run the Quarto document `Online_Retail_Analysis.Rmd` to reproduce the analysis.

## FINAL FINDINGS:

In conclusion, the analysis of the online retail dataset uncovered valuable insights into the company’s operations and customer behavior. The dataset spans a year, from December 1, 2010, to December 9, 2011, providing a detailed temporal snapshot of business transactions. Notably, the dominance of the United Kingdom in terms of total revenue was evident, with wider interquartile ranges and potential outliers highlighting the UK’s significant contribution. The scatter plot of Quantity vs UnitPrice for the top 6 countries revealed diverse purchasing patterns, while the time series analysis showcased dynamic fluctuations in transactional quantities, offering a comprehensive view of temporal trends.

Furthermore, the exploratory data analysis addressed data quality concerns, including the handling of cancellations and the assignment of unique customer IDs to orders with null IDs. The removal of duplicates, thorough data cleaning, and the exclusion of cancellations with negative quantities ensured the integrity of subsequent analyses. The identification of outliers, such as exceptionally high quantities and negative unit prices, prompted further investigation into potential anomalies or bulk purchases. Overall, this analysis equips stakeholders with actionable insights to inform strategic decision-making and improve business performance.
