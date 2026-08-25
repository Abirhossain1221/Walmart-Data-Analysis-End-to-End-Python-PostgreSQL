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

select 
	payment_method,
	count(*) as no_transactions,
	sum(quantity) as no_quantity
from walmart
group by 1
---

# 3️⃣ Exploratory Data Analysis

Exploratory Data Analysis was performed using Python and Pandas to understand the structure and characteristics of the dataset.

### Areas Analyzed

* Sales distribution
* Product performance
* Branch performance
* Customer types
* Payment methods
* Gender distribution
* Revenue trends
* Customer ratings
* Gross income
* Quantity sold

### EDA Code

```python
# ==========================================
# EXPLORATORY DATA ANALYSIS
# ==========================================

[PASTE YOUR EDA CODE HERE]
```

---



# 5️⃣ SQL Analysis

SQL was used to answer important business questions from the PostgreSQL database.

## 📊 Business Questions

###  Q1 Find different payment method and number of transactions, number of quantity sold .

```sql
select 
	payment_method,
	count(*) as no_transactions,
	sum(quantity) as no_quantity
from walmart
group by 1
```

### Question 2 — Which product category generates the highest sales?

```sql
[PASTE YOUR SQL QUERY HERE]
```

### Question 3 — Which branch performs the best?

```sql
[PASTE YOUR SQL QUERY HERE]
```

### Question 4 — Which payment method is most commonly used?

```sql
[PASTE YOUR SQL QUERY HERE]
```

### Question 5 — What is the average customer rating?

```sql
[PASTE YOUR SQL QUERY HERE]
```

### Question 6 — Which products generate the highest gross income?

```sql
[PASTE YOUR SQL QUERY HERE]
```

### Question 7 — What are the monthly sales trends?

```sql
[PASTE YOUR SQL QUERY HERE]
```

### Additional SQL Analysis

```sql
[PASTE YOUR ADDITIONAL SQL QUERIES HERE]
```

---

# 📈 6️⃣ Power BI Dashboard

The cleaned and analyzed data was used to create an interactive **Power BI dashboard**.

## Dashboard Preview

![Power BI Dashboard](images/dashboard-preview.png)

> Replace `images/dashboard-preview.png` with the actual path to your dashboard screenshot.

---

## 📊 Dashboard KPIs

The dashboard includes the following key performance indicators:

| KPI                    |           Value |
| ---------------------- | --------------: |
| Total Revenue          | **[ADD VALUE]** |
| Total Sales            | **[ADD VALUE]** |
| Total Quantity Sold    | **[ADD VALUE]** |
| Gross Income           | **[ADD VALUE]** |
| Average Rating         | **[ADD VALUE]** |
| Number of Transactions | **[ADD VALUE]** |

---

## 📊 Dashboard Visualizations

The Power BI dashboard includes:

* 📈 Sales trend analysis
* 📊 Sales by product category
* 🏢 Branch performance
* 💳 Payment method analysis
* 👥 Customer segmentation
* ⭐ Customer rating analysis
* 💰 Gross income analysis
* 📅 Time-based sales analysis

---

# 🧮 DAX Measures

The following DAX measures were created in Power BI.

### Total Sales

```DAX
[PASTE YOUR DAX MEASURE HERE]
```

### Total Quantity

```DAX
[PASTE YOUR DAX MEASURE HERE]
```

### Gross Income

```DAX
[PASTE YOUR DAX MEASURE HERE]
```

### Average Rating

```DAX
[PASTE YOUR DAX MEASURE HERE]
```

### Additional Measures

```DAX
[PASTE YOUR ADDITIONAL DAX MEASURES HERE]
```

---

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



