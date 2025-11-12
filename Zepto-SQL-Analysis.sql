create table Zepto(
sku_code serial primary key,
category varchar(100),
name varchar (150) not null,
mrp numeric (8,2),
discount_percent numeric (5,2),
available_quantity int,
discounted_selling_price numeric (8,2),
weight_in_gms int,
out_of_stock boolean,
quantity int
);

-- data exploration

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

-- data cleaning

-- product with price = 0
select * from Zepto
where mrp = 0 or discounted_selling_price = 0;

delete from Zepto 
where mrp = 0;

-- convert paise to rupee
update Zepto
set mrp = mrp/100,
discounted_selling_price = discounted_selling_price/100;

-- data analysis

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