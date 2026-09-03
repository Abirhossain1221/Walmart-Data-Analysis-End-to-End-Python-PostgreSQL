# 🛒 Walmart Sales Data Analysis

End-to-end data analytics project using Python, Jupyter Notebook, PostgreSQL 


<img width="1672" height="941" alt="walmart" src="https://github.com/user-attachments/assets/5a10f01b-467a-4534-aaa4-04b89c1c5281" />

## 📌 Project Overview
This project is an end-to-end data analysis solution designed to extract critical business insights from Walmart sales data.
Here I utilize Python for data processing using **kaggle API and cleaning, PostgrSQL** for advanced querying, and structured problem-solving techniques to solve key business questions. 

---
## Project Steps

### 1. Set Up the Environment
   - **Tools Used**: Visual Studio Code (VS Code), Python, SQL ( PostgreSQL)
   - **Python Libraries**:|
    `pandas`, `numpy`, `sqlalchemy`, `mysql-connector-python`, `psycopg2`
   - **Kaggle API Key** (for data downloading)




The project follows a complete data analytics workflow:

```text
Kaggle API set up
     ↓
Connect to Walmart sales datasets
     ↓
Python & Pandas
     ↓
Data Cleaning & Exploration
     ↓
Connect to PostgreSQL using `sqlalchemy`
     ↓
SQL Analysis
     ↓
Business insets 
```


## 🎯 Business Objectives

The main objectives of this project are:

   - **Business Problem-Solving**:Execution of complex SQL queries to answer critical business questions, such as:

     - Revenue trends across branches and categories.
     - Identifying best-selling product categories.
     - Sales performance by time, city, and payment method.
     - Analyzing peak sales periods and customer buying patterns.
     - Profit margin analysis by branch and category.
     - Cashless branches and cities identification.

---

# 🛠️ Tools & Technologies

| Tool                | Purpose                                |
| ------------------- | -------------------------------------- |
| 🐍 Python           | Data analysis and preprocessing using  |  
| 🐼 Pandas           | Data cleaning and manipulation         |
| 📓 Jupyter Notebook | Exploratory Data Analysis              |
| 🐘 PostgreSQL       | Database storage and analysis          |
| 💻 SQL              | Data querying and business analysis    |
| 🔧 Git & GitHub     | Version control and project management |

---

# 📂 Dataset

### Walmart 10k Sales Datasets

**Walmart Sales Dataset**

### Source

 [Walmart Sales Dataset](https://www.kaggle.com/najir0123/walmart-10k-sales-datasets)

### Dataset Size

* Number of rows: 10051
* Number of columns: 11
* Time period: 01/01/19 - 31/12/23


---

# 🔍 Project Workflow

#### 2. Set Up Kaggle API
   - **API Setup**: Obtain your Kaggle API token from [Kaggle](https://www.kaggle.com/) by navigating to your profile settings and downloading the JSON file.
   - **Configure Kaggle**: 
      - Place the downloaded `kaggle.json` file in your local `.kaggle` folder.
      - Use the command `kaggle datasets download -d <dataset-path>` to pull datasets directly into your project.

### 3. Download Walmart Sales Data
   - **Data Source**: Use the Kaggle API to download the Walmart sales datasets from Kaggle.
   - **Dataset Link**: [Walmart Sales Dataset](https://www.kaggle.com/najir0123/walmart-10k-sales-datasets)
   - **Storage**: Save the data in the `data/` folder for easy reference and access.

### 4. Install Required Libraries and Load Data
   - **Libraries**: Install necessary Python libraries using:
     ```bash
     pip install pandas numpy sqlalchemy mysql-connector-python psycopg2
     ```
   - **Loading Data**: Read the data into a Pandas DataFrame for initial analysis and transformations.

### 5. Explore the Data
   - **Goal**: Conduct an initial data exploration to understand data distribution, check column names, types, and identify potential issues.
   - **Analysis**: Use functions like `.info()`, `.describe()`, and `.head()` to get a quick overview of the data structure and statistics.

### 6. Data Cleaning
   - **Remove Duplicates**: Identify and remove duplicate entries to avoid skewed results.
   - **Handle Missing Values**: Drop rows or columns with missing values if they are insignificant; fill values where essential.
   - **Fix Data Types**: Ensure all columns have consistent data types (e.g., dates as `datetime`, prices as `float`).
   - **Currency Formatting**: Use `.replace()` to handle and format currency values for analysis.
   - **Validation**: Check for any remaining inconsistencies and verify the cleaned data.

### 7. Feature Engineering
   - **Create New Columns**: Calculate the `Total Amount` for each transaction by multiplying `unit_price` by `quantity` and adding this as a new column.
   - **Enhance Dataset**: Adding this calculated field will streamline further SQL analysis and aggregation tasks.

### 8. Load Data into MySQL and PostgreSQL
   - **Set Up Connections**: Connect to MySQL and PostgreSQL using `sqlalchemy` and load the cleaned data into each database.
   - **Table Creation**: Set up tables in both MySQL and PostgreSQL using Python SQLAlchemy to automate table creation and data insertion.
   - **Verification**: Run initial SQL queries to confirm that the data has been loaded accurately.
---


### Python Code

```python
# ==========================================
# IMPORTING DEPENDENCIES 
# ==========================================
importing dependencies 
#importing toolkit 
import pandas as pd
import psycopg2
from sqlalchemy import create_engine 

# ==========================================
# DATA INSPECTION
# ==========================================
df = pd.read_csv(
    Project- walmart\walmart-10k-sales-datasets\Walmart.csv',
    encoding_errors='ignore'

df.shape
df.describe()
df.head()
df.info()

# ==========================================
# DATA CLEANING
# ==========================================

#count duplicates
df.duplicated().sum()

#Remove duplicates 
df.drop_duplicates(inplace= True)

#Count null
df.isnull().sum()
#Drop  all records with missing records 
df.dropna(inplace= True)

df.dtypes
df["unit_price"]= df["unit_price"].str.replace('$','').astype(float)

df.head()
df.columns
#creating a new column called Total
df['total'] = df['unit_price']*df['quantity']
df.head()

#converting columns to lower case

df.columns = df.columns.str.lower()
df.columns
#Save clean data as csv
df.to_csv('walmart_clean_data.csv',index=False)

# ==========================================
# EXPORT TO  RDBMS 
# ==========================================

#create_engine("postgresql+psycopg2://scott:tiger@localhost/test")

engine_psql = create_engine("postgresql+psycopg2://postgres:****@localhost:***/****")

try:
     engine_psql
     print("Connection succeded to Postgrsql")
except:
     print("Unable to connect")

#uploading data to postgrsql

df.to_sql(name='walmart',con= engine_psql, if_exists='append', index= False)

```

# 💻 SQL Analysis

SQL was used to answer important business questions from the PostgreSQL database.

##📊 Business Questions

### Q1 Find different payment method and number of transactions, number of quantity sold.
```sql
select 
	payment_method,
	count(*) as no_transactions,
	sum(quantity) as no_quantity
from walmart
group by 1
```
### Q2  Identify the highest-rated category in each branch, display the branch, category and avg rating .

```sql
SELECT *		
FROM 
	( SELECT
		branch,
		category,
		avg(rating) AS rating,
		RANK() OVER(PARTITION BY branch ORDER BY avg(rating) DESC) as rank 
	FROM walmart
	GROUP BY 1,2 
)
WHERE rank = 1 ;
```

### Q3 Identify the busiest day of each branch based on the nunber of transactions. 

```sql
WITH cte AS
(
SELECT 
	branch,
	TO_CHAR(TO_DATE(date, 'DD-MM-YY'), 'DAY') AS day_name,
	COUNT(*) AS no_transaction,
	RANK() OVER (PARTITION BY branch ORDER BY COUNT(*)) AS rank

FROM walmart
GROUP BY 1, 2
)
select *
from cte 
WHERE rank = 1
```
### Q4 Calculate the total quantity of item sold per payment methon. List payment method and total quantity.

```sql
SELECT 
	payment_method,
	SUM(quantity) AS total_quantity
FROM walmart
GROUP BY payment_method;
```
### 
Q5 Determine the average , minimum and maximum rating  of category for each city. List the city, avg_rating, min_rating, max_rating.

```sql
SELECT 
	city,
	category,
	ROUND(AVG(rating:: NUMERIC), 2) AS avg_rating,
	MIN(rating) AS min_rating,
	MAX(rating) AS max_rating 
	
FROM walmart
GROUP BY 1, 2;

-- Catagory by city

select city ,  count (category)
from walmart
group by city
```

### Q6 calculate the total profit for each category by considering .

```sql
SELECT 
	category,
	SUM(unit_price*quantity) as revenue,
	SUM(unit_price*quantity*profit_margin) as total_profit

FROM walmart
GROUP BY 1
```
### Q7 Determine the most common payment method for each branch.display branch and the prefered payment method

```sql
SELECT * FROM
(
SELECT 
	branch,
	payment_method,
	count(*) as total_payment,
	RANK() OVER (PARTITION BY branch ORDER BY count(*) DESC) AS rank
FROM walmart
GROUP BY 1,2
)
WHERE rank = 1
```

### Q8 Categorize sales into 3 groups morning ,afternoon, evening . find out each shift and number of invoices .

```sql
SELECT 
	branch,
 		CASE 
		 WHEN EXTRACT(HOUR FROM time :: TIME ) < 12 THEN 'Morning'
		 WHEN EXTRACT(HOUR FROM time :: TIME ) BETWEEN 12 AND 17 THEN 'Afternoon'
		 ELSE 'Evening'
		END AS day_time,
		COUNT(*) AS no_invoice	
FROM walmart
GROUP BY 1,2
ORDER BY 1,3 DESC;
```
### Q9 Identify 5 branch with highest desrease ratio in revenue compare to the last year (current year 2022 and last year 2023)
```sql
with ls AS
(SELECT
	branch,
	SUM(total) AS ls_rev
FROM walmart  
WHERE EXTRACT (YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2022
GROUP BY 1
),

cs AS
(
SELECT
	branch,
	SUM(total) cs_rev
FROM walmart  
WHERE EXTRACT (YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2023
GROUP BY 1
)

SELECT
	ls.branch,
	ls.ls_rev,
	cs.cs_rev,
	ROUND((cs.cs_rev-ls.ls_rev):: NUMERIC /ls.ls_rev :: NUMERIC * 100,2) as rev_dec_ratio
FROM ls
JOIN cs
ON ls.branch =cs.branch 
ORDER BY 4 
LIMIT 5; 

```
### Q10 cashless branches
```sql
SELECT branch, city
FROM walmart
GROUP BY branch, city
HAVING SUM(CASE WHEN payment_method = 'Cash' THEN 1 ELSE 0 END) = 0;
```

## 💡 Key Business Insights

### 🏦 Branches & Cities with Zero or Minimal Cash Transactions
Zero Cash Transactions (entirely Ewallet/Credit Card):

Recent years (2020–2023): Branches like San Antonio (WALM003), Irving (WALM013), Brownwood (WALM090), Lewisville (WALM031), Weatherford (WALM099), Bedford (WALM064), Cleburne (WALM088), and several others show no cash transactions at all in the later years.

-This indicates a shift toward digital payments in these cities.

-Minimal Cash Usage (very few cash records compared to digital):

-Weslaco (WALM074, WALM082) – occasional small cash entries but dominated by Ewallet.

-La Porte (WALM079) – mostly Ewallet, with rare low-value cash.

-Canyon (WALM100) – cash transactions exist but are very low compared to Ewallet.

-👉 These branches are effectively cashless or nearly cashless, which is critical for planning POS infrastructure and customer experience.

### 📊 Critical Business Insights
Digital Payment Adoption Trend

From 2019 onwards, cash was common, but by 2020–2023, Ewallet dominates in many branches.

Business decision: Invest more in digital payment systems and reduce cash-handling costs in cities already cash-free.

Branch-Level Profitability

Branches like San Antonio, Garland, Irving, and Canyon consistently show high transaction totals with strong profit margins.

Business decision: These branches could be prioritized for new product launches or premium services.

Customer Rating Patterns

Cities like Bryan, Lufkin, and Angleton often show higher ratings (8–10), while Corpus Christi, Denton, and Grapevine have lower averages (4–6).

Business decision: Focus on customer satisfaction programs in lower-rated cities to improve loyalty.

Category Insights

Health & Beauty and Food & Beverages dominate in transaction frequency.

Sports & Travel and Fashion Accessories show high-value but less frequent purchases.

Business decision: Bundle promotions in high-frequency categories and targeted marketing for high-value categories.

Seasonality

Many high-value transactions cluster around January–March, suggesting post-holiday shopping spikes.

Business decision: Plan inventory and staffing around these seasonal peaks.

 ### ✅ Summary for Decision-Makers:

Certain branches (San Antonio, Irving, Brownwood, Lewisville, Weatherford, Bedford, Cleburne) are already cashless → reduce cash infrastructure there.

Focus on digital-first strategies (loyalty apps, QR payments).

Improve customer experience in low-rating cities.

Leverage seasonal demand for inventory planning.

Prioritize high-profit branches for expansion and premium offerings.

---


### 👨‍💻 Author

**Md Abir Hossain**

Aspiring **Data Analyst | Business Analyst | BI Analyst**

### Skills

`SQL` `Python` `Pandas` `PostgreSQL` `Power BI` `DAX` `Excel` `Data Analytics`


### ⭐ If You Find This Project Useful

If you found this project interesting or useful, consider giving the repository a ⭐.


### 📌 Project Status

**Status:** Completed

**Last Updated:** 26/08/2026



