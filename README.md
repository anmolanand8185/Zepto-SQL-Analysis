
# 🛒 Zepto SQL Analysis

This project demonstrates **SQL data analysis and cleaning using PostgreSQL** on a simulated product dataset inspired by Zepto (an instant delivery platform).  
It covers table creation, data exploration, cleaning, and business-focused analytical queries to extract insights from raw product data.

---

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [Database & Tools Used](#database--tools-used)
3. [Dataset Description](#dataset-description)
4. [SQL Workflow](#sql-workflow)
5. [Key Learnings](#key-learnings)

---

## 🧩 Project Overview
The aim of this project is to perform a **complete SQL analysis workflow** using PostgreSQL — starting from data import to meaningful insights.  
It demonstrates practical SQL skills such as:
- Table creation and schema design  
- Data cleaning (handling nulls, duplicates, invalid values)  
- Aggregations and grouping  
- Conditional logic and derived columns  
- Analytical insights with real-world business relevance  

---

## 🧰 Database & Tools Used
- **Database:** PostgreSQL  
- **Tool:** pgAdmin  
- **Dataset Source:** CSV file (simulated Zepto product data)  

---

## 📊 Dataset Description

The dataset was sourced from [Kaggle](https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset/data?select=zepto_v2.csv). It mimics what you’d typically encounter in a real-world e-commerce inventory system.

Each row represents a unique SKU (Stock Keeping Unit) for a product. Duplicate product names exist because the same product may appear multiple times in different package sizes, weights, discounts, or categories to improve visibility – exactly how real catalog data looks.

🧾 Columns:
- **sku_code:** Unique identifier for each product entry (Synthetic Primary Key)

- **name:** Product name as it appears on the app

- **category:** Product category like Fruits, Snacks, Beverages, etc.

- **mrp:** Maximum Retail Price (originally in paise, converted to ₹)

- **discount_percent:** Discount applied on MRP

- **discounted_selling_price:** Final price after discount (also converted to ₹)

- **available_quantity:** Units available in inventory

- **weight_in_gms:** Product weight in grams

- **out_of_stock:** Boolean flag indicating stock availability

- **quantity:** Number of units per package (mixed with grams for loose produce)


---

## 🧮 SQL Workflow

### 1. **Table Creation**
```sql
create table Zepto(
  sku_code serial primary key,
  category varchar(100),
  name varchar(150) not null,
  mrp numeric(8,2),
  discount_percent numeric(5,2),
  available_quantity int,
  discounted_selling_price numeric(8,2),
  weight_in_gms int,
  out_of_stock boolean,
  quantity int
);
```

### 2. **Data Exploration**
```sql
-- count of rows
select count(*) from Zepto;

-- sample data
select * from zepto
limit 10;

-- null values
select * from Zepto
where
name is null
or
category is null
or
mrp is null
or
discount_percent is null
or
available_quantity is null
or
discounted_selling_price is null
or
weight_in_gms is null
or
out_of_stock is null
or
quantity is null;

-- different product categories
select distinct category from Zepto
order by category;

-- product in stock vs out of stock
select count(sku_code), out_of_stock from Zepto
group by out_of_stock;

-- product names present multiple times
select name, count(sku_code) from Zepto
group by name
having count(sku_code)>1
order by count(sku_code) desc;
```

### 3. **Data Cleaning**
```sql
-- product with price = 0
select * from Zepto
where mrp = 0 or discounted_selling_price = 0;

delete from Zepto 
where mrp = 0;

-- convert paise to rupee
update Zepto
set mrp = mrp/100,
discounted_selling_price = discounted_selling_price/100;
```

### 3. **Data Analysis**
Used SQL aggregation, case statements, and sorting to answer business questions.
```sql
-- Q1. Find the top 10 best-value products based on the discount percentage.

Select distinct name, mrp, discount_percent from Zepto
order by discount_percent desc
limit 10;

-- Q2. What are the Products with High MRP but Out of Stock

select distinct name, mrp from Zepto
where out_of_stock = true and mrp > 300
order by mrp desc;

-- Q3. Calculate Estimated Revenue for each category

select category, sum(discounted_selling_price*available_quantity) as estimated_revenue from Zepto
group by category
order by sum(discounted_selling_price*available_quantity);

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

Select distinct name, mrp, discount_percent from Zepto
where mrp>500 and discount_percent<10
order by mrp desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.

select category, round(avg(discount_percent),2) as average_discount_percent
from Zepto
group by category
order by round(avg(discount_percent),2) desc
limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.

Select distinct name, weight_in_gms, discounted_selling_price, round((discounted_selling_price/weight_in_gms),2) as price_per_gram
from Zepto
where weight_in_gms>100
order by round((discounted_selling_price/weight_in_gms),2);

-- Q7. Group the products into categories like Low, Medium, Bulk.

Select distinct name, weight_in_gms,
case
when weight_in_gms < 1000 then 'Low'
when weight_in_gms between 1000 and 5000 then 'Medium'
else 'Bulk'
end as quanity_category
from zepto;

-- Q8. What is the Total Inventory Weight Per Category

select category, sum(weight_in_gms*available_quantity) as total_inventory_weight
from Zepto
group by category
order by sum(weight_in_gms*available_quantity);
```

## 💡 Key Learnings
- Gained hands-on experience with PostgreSQL syntax and functions

- Improved understanding of data cleaning and preprocessing

- Practiced aggregation, filtering, and case statements

- Learned how to derive actionable insights from raw datasets

## 🧠 Author
👋 Created by Anmol Anand

An Ex-Finance professional exploring the world of data and aspiring to build impactful insights through analytics.
