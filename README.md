# Global Layoffs Analysis — SQL Data Cleaning & EDA

This repository demonstrates a structured SQL workflow applied to a real-world global layoffs dataset.  
The project focuses on transforming raw data into an analysis-ready format and performing exploratory data analysis (EDA) to uncover trends across time, industries, companies, and geography.

The workflow mirrors how SQL is used in professional analytics environments: separating **data preparation** from **analysis** to ensure clarity, reproducibility, and scalability.

---

## Project Objectives
- Clean and standardize raw layoffs data using SQL
- Prepare an analysis-ready dataset
- Explore high-level trends in layoffs over time
- Identify industries, companies, and countries most impacted by layoffs

---

## Dataset
- **Source file:** `data/layoffs.csv`
- **Description:** Records of company layoff events including workforce impact, industry, funding stage, and geography
- **Granularity:** One row per layoff event per company

A full description of all fields is available in the data dictionary.

---

## Repository Structure
### SQL Workflow

#### 1. Data Cleaning (`sql/01_cleaning.sql`)
This script:
- Removes duplicate records
- Standardizes text fields and formats
- Converts date values to a consistent date type
- Produces a clean, analysis-ready dataset

The output of this script serves as the foundation for all analysis.

---

#### 2. Exploratory Data Analysis (`sql/02_eda.sql`)
This script performs exploratory queries to:
- Examine overall layoff trends over time
- Aggregate layoffs by company, industry, and country
- Identify the most significant contributors to total layoffs
- Summarize key patterns in the dataset

All EDA queries are run against the cleaned dataset.

---

## How to Run the Project

1. Load `layoffs.csv` into your SQL database as a raw table (e.g., `layoffs`)
2. Execute `sql/01_cleaning.sql`
3. Execute `sql/02_eda.sql`
4. Review query outputs for trends and insights

> SQL scripts are written in a dialect-agnostic style and may require minor adjustments depending on the database used (PostgreSQL, MySQL, SQLite, etc.).

---

## Key Questions Explored
- How have layoffs trended over time?
- Which companies and industries experienced the largest layoffs?
- Which countries were most affected?
- How do layoff patterns differ across industries and funding stages?

---

## Documentation
- **Data Dictionary:** `docs/data_dictionary.md`  
  Describes all fields, data types, and cleaning considerations used in this project.

---

## Purpose of This Repository
This project is intended to showcase practical SQL skills in:
- Data cleaning and preparation
- Exploratory data analysis
- Analytical thinking and documentation

The emphasis is on **clear logic, clean structure, and reproducible analysis**, rather than complex tooling.

---

## Contact
For questions or additional context, feel free to connect via GitHub or LinkedIn.
