# Data Dictionary – Global Layoffs Dataset

## Dataset Overview
This dataset contains records of company layoff events across industries and countries.  
Each row represents a single layoff event for a company at a specific point in time, including information about workforce impact, company stage, and funding.

The dataset is used to analyze trends in layoffs over time, by industry, company, and geography.

---

## Column Definitions

| Column Name | Description |
|------------|------------|
| company | Name of the company that conducted the layoffs |
| location | City or region where the layoffs occurred |
| industry | Industry classification of the company |
| total_laid_off | Number of employees laid off in the event |
| percentage_laid_off | Percentage of the company’s workforce laid off on specific event |
| date | Date on which the layoff event occurred |
| stage | Company funding or business stage at the time of layoffs |
| country | Country where the layoffs occurred |
| funds_raised_millions | Total funding raised by the company, in USD millions |

---

## Data Types (Logical)

| Column | Data Type |
|------|----------|
| company | Text |
| location | Text |
| industry | Text |
| total_laid_off | Integer |
| percentage_laid_off | Decimal |
| date | Date |
| stage | Text |
| country | Text |
| funds_raised_millions | Decimal |

---

## Data Quality Notes
- Some records contain missing values for `total_laid_off` and/or `percentage_laid_off`
- Certain companies report only one of the two layoff metrics (count vs percentage)
- Text fields may contain inconsistent casing or extra whitespace in the raw data
- Date values are standardized during the data cleaning process
- Duplicate rows are removed as part of the cleaning step

---

## Cleaning & Transformation Summary
The cleaning script performs the following actions:
- Removes duplicate records
- Trims and standardizes text fields
- Converts date values to a consistent date format
- Prepares the dataset for exploratory data analysis (EDA)

The cleaned output is used as the input for all exploratory analysis queries.
