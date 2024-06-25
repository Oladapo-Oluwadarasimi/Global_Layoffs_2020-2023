# Global Layoffs EDA Project

## Introduction

The layoffs dataset offers detailed information on layoffs that have occurred in a number of companies in various locations. It contains the names of the companies, their locations, the number of laid-off employees, and the dates of the layoffs. The primary purpose of analyzing this dataset is to identify trends and evaluate the impact on different regions and industries. This analysis makes it easier to grasp the overall number of layoffs by nation and area, pinpoint the organizations that have had the most layoffs, and see how layoffs have changed over time.

## Problem Statement

This project aims to perform an exploratory data analysis (EDA) of layoffs in various locations, industries, and stages of the organization. The goals are to spot trends, show how layoffs have changed over time, and draw attention to the main causes of layoffs. This study will shed light on the most impacted industries and locations, the timing of layoffs, and the traits of the businesses that are being laid off at the greatest rate.

## Data Overview

The layoffs dataset contains information about layoffs across various companies and locations. Each record in the dataset includes the following columns:
- **Company**: The name of the company where layoffs occurred
- **Location**: The geographical location of the company
- **Industry**: The industry to which the company belongs
- **Total Laid Off**: The number of employees laid off from the company.
- **Percentage Laid Off**: The percentage of the company's workforce that was laid off.
- **Date**: The date on which the layoffs were reported
- **Stage**: The funding or operational stage of the company at the time of layoffs
- **Country**: The country where the layoffs occurred (e.g., Australia, United States).
- **Funds Raised (Millions)**: The total amount of funds raised by the company in millions

### Snapshot of Layoffs Dataset
 ![layoffs-1 - Excel 6_25_2024 12_29_29 PM](https://github.com/Oladapo-Oluwadarasimi/World_Layoffs_2020-2023/assets/173706258/ed1cd69a-2d33-4e78-97de-7ceae335e97b)



## Data Cleaning

There were many cleaning stages that were taken in order to get the layoffs dataset ready for exploratory data analysis:
- Missing values in the `percentage_laid_off` column were resolved.
- The `date` column was transformed into the correct date format.
- Inaccurate or unclear entries in columns such as `location`, `industry`, `stage`, and `country` were standardized.
- Duplicates in the dataset were identified and eliminated.
- Numerical data, including `total_laid_off` and `funds_raised_millions`, were inspected for consistency and adjusted as needed.

### Snapshots Cleaning Data of in MySQL
![MySQL Workbench 6_25_2024 7_49_32 PM](https://github.com/Oladapo-Oluwadarasimi/World_Layoffs_2020-2023/assets/173706258/4ff3ae60-747a-478a-a84d-ee3c5743bf9f)

## Data Exploration

### Key Findings
- Due to the COVID-19 pandemic in 2020, many companies experienced increased layoffs by early 2023.
- **Industries with the Most Layoffs**: Consumers & retail were hit hard, likely due to office closures during the pandemic.
- **Countries with the Most Layoffs**: The United States had the most layoffs, with 256,420.
- **Locations with the Most Layoffs**: The SF Bay Area had the highest number, with 125,551, likely due to higher COVID-19 cases.

### Progression of Layoffs by Year
- Rolling sum in MySQL and breakdown by year to understand the progression.
- Ranked companies by layoffs per year using CTEs to identify the top 5 companies.

### Snapshots of EDA in MySQL

![readme so - Google Chrome 6_25_2024 12_37_13 PM](https://github.com/Oladapo-Oluwadarasimi/World_Layoffs_2020-2023/assets/173706258/b3c3e552-e1eb-42e5-b4bb-f87a423f8697)
![layoffs-1 - Excel 6_25_2024 12_36_46 PM](https://github.com/Oladapo-Oluwadarasimi/World_Layoffs_2020-2023/assets/173706258/adca9c89-f488-45b7-9638-ebf1d214d8a3)

## Visualized Results in Power BI

### Total Layoffs by Company

#### Dax Function
TotalLayoffsByLocationDate = CALCULATE(
    SUM('layoffs_staging2'[total_laid_off]),
    ALLEXCEPT('layoffs_staging2', 'layoffs_staging2'[location], 'layoffs_staging2'[date])
)

### Total Layoffs by Location

#### Dax Function
TotalLayoffsByLocation = CALCULATE(
    SUM('layoffs_staging2'[total_laid_off]),
    ALLEXCEPT('layoffs_staging2', 'layoffs_staging2'[location])
)
TotalLayoffsByLocationCompany = CALCULATE(
    SUM('layoffs_staging2'[total_laid_off]),
    ALLEXCEPT('layoffs_staging2', 'layoffs_staging2'[location], 'layoffs_staging2'[company])
)

### Monthly Rolling Total of Layoffs

#### Dax Function
YearMonth = FORMAT('layoffs_staging2'[date], "YYYY-MM")
TotalLayoffsPerMonth = CALCULATE(
    SUM('layoffs_staging2'[total_laid_off]),
    ALLEXCEPT('layoffs_staging2', 'layoffs_staging2'[YearMonth])
)
RollingTotalLayoffs = CALCULATE(
    SUM('layoffs_staging2'[TotalLayoffsPerMonth]),
    FILTER(
        ALL('layoffs_staging2'),
        'layoffs_staging2'[YearMonth] <= EARLIER('layoffs_staging2'[YearMonth])
    )
)

### Top Companies with Most Layoffs Each Year

#### Dax Function
Year = YEAR('layoffs_staging2'[date])
TotalLayoffsPerCompanyYear = CALCULATE(
    SUM('layoffs_staging2'[total_laid_off]),
    ALLEXCEPT('layoffs_staging2', 'layoffs_staging2'[company], 'layoffs_staging2'[Year])
)
CompanyYearRank = RANKX(
    FILTER(
        ALL('layoffs_staging2'),
        'layoffs_staging2'[Year] = EARLIER('layoffs_staging2'[Year])
    ),
    'layoffs_staging2'[TotalLayoffsPerCompanyYear],
    ,
    DESC,
    DENSE
)
Top3CompaniesPerYear = IF(
    'layoffs_staging2'[CompanyYearRank] <= 3,
    'layoffs_staging2'[TotalLayoffsPerCompanyYear],
    BLANK()
)

### Percentage of Layoffs by Company

#### Dax Function
MaxPercentageLaidOff = CALCULATE(
    MAX('layoffs_staging2'[percentage_laid_off]),
    ALLEXCEPT('layoffs_staging2', 'layoffs_staging2'[company])
)
MinPercentageLaidOff = CALCULATE(
    MIN('layoffs_staging2'[percentage_laid_off]),
    ALLEXCEPT('layoffs_staging2', 'layoffs_staging2'[company])
)

# Snapshot of Layoffs Dashboard (Power Bi Desktop)

![Visualization 6_24_2024 5_09_11 PM](https://github.com/Oladapo-Oluwadarasimi/World_Layoffs_2020-2023/assets/173706258/56cb2bfa-56fb-43bd-8e52-777c9137f951)

## Key Insights

A single-page report was created on Power BI Desktop and published to Power BI Service. 

### The companies with the highest layoffs were:
- Amazon: 18,150 layoffs
- Google: 12,000 layoffs
- Meta: 11,000 layoffs
- Salesforce: 10,090 layoffs
- Microsoft: 10,000 layoffs

### The location with the highest layoffs:
- Seattle, with Amazon accounting for 54,430 layoffs.

### Progression of Layoffs
- March 2020: Rolling total of 9,628 layoffs
- December 2020: Rolling total of 80,998 layoffs
- January 2021: Rolling total of 87,811 layoffs
- December 2021: Rolling total of 96,821 layoffs
  - 2021 was a relatively better year compared to others.
- January 2022: Rolling total of 97,331 layoffs
- December 2022: Rolling total of 257,143 layoffs
  - 2022 was the worst year for layoffs.
- Data for 2023 is incomplete as it only includes early 2023.

### Variance in Layoffs and Fundraising
- There is a higher variance in both the number of layoffs and funds raised in the 1% layoffs than the 0% layoffs.

### Top Companies with the Most Layoffs Each Year
- 2020: Uber with 30,100 layoffs
- 2021: ByteDance with 7,200 layoffs
- 2022: Amazon with 20,300 layoffs
- 2023: Google with 12,000 layoffs

### Suggestion Strategy
- Provide specialized assistance programs for industries such as retail, transportation, and real estate, including financial aid packages, retraining programs, and staff retention incentives.
- Implement early warning systems and trend tracking to anticipate and address possible layoff surges, allowing for proactive measures to lessen the effects.

## How to Use this Project

1. Clone the repository:
   ```sh
   git clone https://github.com/Oladapo-Oluwadarasimi/Global Layoffs-EDA-Project.git

