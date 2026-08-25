# 🛒 Walmart Sales Data Analysis

> **End-to-end data analytics project using Python, Jupyter Notebook, PostgreSQL **


<img width="1672" height="941" alt="walmart" src="https://github.com/user-attachments/assets/5a10f01b-467a-4534-aaa4-04b89c1c5281" />

## 📌 Project Overview
This project is an end-to-end data analysis solution designed to extract critical business insights from Walmart sales data.
Here I utilize Python for data processing using ** kaggle API and cleaning, PostgrSQL** for advanced querying, and structured problem-solving techniques to solve key business questions. 

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

   - **Business Problem-Solving**: Write and execute complex SQL queries to answer critical business questions, such as:

     - Revenue trends across branches and categories.
     - Identifying best-selling product categories.
     - Sales performance by time, city, and payment method.
     - Analyzing peak sales periods and customer buying patterns.
     - Profit margin analysis by branch and category.

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
#importing dependencies 

import pandas as pd

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

#count duplicats
df.duplicated().sum()

#Remove duplicats 
df.drop_duplicates(inplace= True)

#count null
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
**Export this data to RDBMS (postgrsql)**
# ==========================================
#importing toolkit 
import psycopg2
from sqlalchemy import create_engine 

#create_engine("postgresql+psycopg2://scott:tiger@localhost/test")

engine_psql = create_engine("postgresql+psycopg2://postgres:Analyst2026@localhost:5432/walmart_db")

try:
     engine_psql
     print("Connection succeded to Postgrsql")
except:
     print("Unable to connect")

#uploading data to postgrsql

df.to_sql(name='walmart',con= engine_psql, if_exists='append', index= False)


---


# 💻 SQL Analysis

SQL was used to answer important business questions from the PostgreSQL database.

##📊 Business Questions
---

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
Q5 Determine the average , minimum and maximum rating  of category for each city. List the city, avg_rating, min_rating, max_rating .

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

### Q7 Determine the most common payment method for each branch.
--(display branch and the prefered payment method)

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




# 💡 Key Business Insights

Based on the analysis, the following insights were identified:

### 1. 🏆 Best Performing Product

**[WRITE YOUR FINDING HERE]**

Example:

> The [PRODUCT CATEGORY] generated the highest total sales during the analyzed period.

### 2. 🏢 Branch Performance

**[WRITE YOUR FINDING HERE]**

### 3. 💳 Payment Behavior

**[WRITE YOUR FINDING HERE]**

### 4. 👥 Customer Behavior

**[WRITE YOUR FINDING HERE]**

### 5. 📈 Sales Trend

**[WRITE YOUR FINDING HERE]**

### 6. 💰 Profitability

**[WRITE YOUR FINDING HERE]**

---

# 🚀 Business Recommendations

Based on the findings, the following recommendations can be considered:

### Recommendation 1

**[ADD YOUR RECOMMENDATION HERE]**

### Recommendation 2

**[ADD YOUR RECOMMENDATION HERE]**

### Recommendation 3

**[ADD YOUR RECOMMENDATION HERE]**

### Recommendation 4

**[ADD YOUR RECOMMENDATION HERE]**

---

# 📁 Project Structure

```text
walmart-sales-analysis/
│
├── 📄 README.md
│
├── 📂 data/
│   ├── raw/
│   │   └── Walmart.csv
│   │
│   └── cleaned/
│       └── [CLEANED_DATASET].csv
│
├── 📂 notebooks/
│   └── walmart_analysis.ipynb
│
├── 📂 sql/
│   └── walmart_analysis.sql
│
├── 📂 powerbi/
│   └── walmart_dashboard.pbix
│
├── 📂 images/
│   └── dashboard-preview.png
│
├── 📂 src/
│   └── data_cleaning.py
│
├── 📄 requirements.txt
│
└── 📄 .gitignore
```

---

# ▶️ How to Run the Project

## 1. Clone the Repository

```bash
git clone [YOUR GITHUB REPOSITORY URL]
```

```bash
cd walmart-sales-analysis
```

---

## 2. Install Python Dependencies

```bash
pip install -r requirements.txt
```

---

## 3. Open the Jupyter Notebook

```bash
jupyter notebook
```

Then open:

```text
notebooks/walmart_analysis.ipynb
```

---

# 🐘 PostgreSQL Setup

Create a PostgreSQL database:

```sql
CREATE DATABASE [DATABASE_NAME];
```

Create the required table:

```sql
[PASTE YOUR CREATE TABLE SQL HERE]
```

Import the cleaned dataset:

```text
[ADD YOUR POSTGRESQL IMPORT INSTRUCTIONS HERE]
```

---

# 🔐 Database Connection

Python was connected to PostgreSQL using SQLAlchemy.

```python
from sqlalchemy import create_engine

engine = create_engine(
    "postgresql+psycopg2://USERNAME:PASSWORD@localhost:5432/DATABASE_NAME"
)

[PASTE YOUR CONNECTION / QUERY CODE HERE]
```

> ⚠️ **Security:** Never upload your real PostgreSQL password, API keys, or other credentials to GitHub. Use environment variables or a `.env` file and add `.env` to `.gitignore`.

---

# 📦 Requirements

The main Python libraries used in this project are:

```text
pandas
numpy
matplotlib
seaborn
sqlalchemy
psycopg2-binary
jupyter
```

You can generate your requirements file using:

```bash
pip freeze > requirements.txt
```

---

# 📚 Skills Demonstrated

This project demonstrates practical experience with:

* ✅ Python
* ✅ Pandas
* ✅ NumPy
* ✅ Jupyter Notebook
* ✅ Data Cleaning
* ✅ Exploratory Data Analysis
* ✅ SQL
* ✅ PostgreSQL
* ✅ Database Management
* ✅ Data Visualization
* ✅ Power BI
* ✅ DAX
* ✅ Business Intelligence
* ✅ Business Analysis
* ✅ Data Storytelling
* ✅ Git & GitHub

---

# 🎓 What I Learned

Through this project, I strengthened my ability to:

* Work with real-world datasets
* Clean and transform raw data
* Perform exploratory data analysis
* Write SQL queries for business analysis
* Work with PostgreSQL databases
* Build Power BI dashboards
* Create DAX measures
* Extract actionable business insights
* Present data-driven recommendations
* Manage an analytics project using Git and GitHub

---

# 🔮 Future Improvements

Potential future improvements include:

* [ ] Add automated data pipelines
* [ ] Connect Power BI directly to PostgreSQL
* [ ] Add more advanced DAX measures
* [ ] Add customer segmentation
* [ ] Perform predictive sales analysis
* [ ] Automate data cleaning
* [ ] Add scheduled data refresh
* [ ] Deploy the dashboard for online access

---

# 📸 Screenshots

## Python / Jupyter Notebook

![Jupyter Notebook](images/jupyter-preview.png)

## PostgreSQL / SQL Analysis

![PostgreSQL Analysis](images/postgresql-preview.png)

## Power BI Dashboard

![Power BI Dashboard](images/dashboard-preview.png)

---

# 👨‍💻 Author

**[YOUR NAME]**

Aspiring **Data Analyst | Business Analyst | BI Analyst**

### Skills

`SQL` `Python` `Pandas` `PostgreSQL` `Power BI` `DAX` `Excel` `Data Analytics`

### Connect With Me

* 💼 LinkedIn: [ADD YOUR LINKEDIN URL]
* 🐙 GitHub: [ADD YOUR GITHUB URL]
* 📧 Email: [ADD YOUR EMAIL]

---

# ⭐ If You Find This Project Useful

If you found this project interesting or useful, consider giving the repository a ⭐.

---

## 📌 Project Status

**Status:** 🚧 In Progress / Completed

**Last Updated:** [ADD DATE]



