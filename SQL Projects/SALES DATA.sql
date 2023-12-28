/* 
 Using SQL, I have been tasked with analyzing a sales database. The database contains several necessary datasets to analyze the following case studies:
 
1.	Find the product names and total sales (in retail price) for each product that has been delivered during a specific December of 2022 with the status = Complete. Sort the results in descending order based on total sales.
2.	Retrieve the usernames and total orders made by users between July 1, 2022, and August 15, 2022, ordering the usernames with the highest total orders.
3.	Identify the distribution center with the highest quantity of products. Provide the distribution center's name, the quantity of products, and the most commonly sold product. Sort the results based on the quantity of products in descending order.
4.	Locate the distribution center with the highest total revenue. Include the distribution center's name, product name, total production cost, total retail price, and total revenue. Sort the results based on total revenue in descending order.

Here are the codes of the analysis for the specified case studies:
*/

/* STUDY CASE 1 */
with MonthlyProductSales as (
select
p."name" product_name,
SUM(oi.sale_price) as total_sales
from
thelook_ecommerce_products p
left join 
thelook_ecommerce_order_items oi on p.id = oi.product_id  
where 
oi.status='Complete'
and oi.delivered_at  between '2022-12-01' and '2022-12-31'
group by 
p."name"
)
select 
product_name,
total_sales
from
MonthlyProductSales
order by
total_sales desc;

/* STUDY CASE 2 */
select 
u.id as user_id,
u.first_name,
u.last_name,
count(o.order_id) as total_orders
from
thelook_ecommerce_users u
inner join
thelook_ecommerce_orders o on u.id = o.user_id
inner join 
thelook_ecommerce_order_items oi on o.order_id = oi.order_id 
inner join 
thelook_ecommerce_products p on oi.product_id  = p.id  
where 
o.created_at between '2022-07-01' and '2022-08-15'
group by 
u.id, u.first_name, u.last_name 
order by 
total_orders desc;

/* STUDY CASE 3*/
with DistributionCenterProductCount as (
select 
dc.name as distribution_center_name,
sum(p."cost") as total_products,
max(p."name") as most_sold_product
from
thelook_ecommerce_distribution_centers dc
left join
thelook_ecommerce_products p on dc.id = p.distribution_center_id 
group by 
dc."name" 
)
select 
distribution_center_name,
total_products,
most_sold_product
from 
DistributionCenterProductCount
order by
total_products desc;

/*STUDY CASE 4*/
with DistributionCenterMaxCost as (
select 
dc.name as distribution_center_name,
p."name" product_name,
sum(p."cost") as total_cost,
sum(p."retail_price") as total_price,
(sum(p."retail_price")-sum(p."cost")) total_revenue
from
thelook_ecommerce_distribution_centers dc
left join
thelook_ecommerce_products p on dc.id = p.distribution_center_id 
group by 
dc.name, p."name"
)
select 
distribution_center_name, 
product_name,
total_cost,
total_price,
total_revenue
from 
DistributionCenterMaxCost
order by
total_revenue desc;
