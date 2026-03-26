create database project_db_new;
use project_db_new;
select * from customer limit 10;

-- revenue based on gender basis
select gender as Gender, sum(purchase_amount_in_usd) as Revenue from customer
group by gender
order by sum(purchase_amount_in_usd) desc;


-- customer who spend more than average money after distcount
select customer_id, sum(purchase_amount_in_usd) as Revenue
from customer
where purchase_amount_in_usd > (select avg(purchase_amount_in_usd) from customer) and discount_applied='Yes'
group by customer_id
order by sum(purchase_amount_in_usd) desc;


-- top 5 products with highest average review rating 
select item_purchased, round(avg(cast(review_rating as decimal(4,2))),2) from customer
where review_rating > (select avg(review_rating) from customer)
group by item_purchased
order by avg(review_rating) desc
limit 5;

select * from customer;
select shipping_type,avg(purchase_amount_in_usd) from customer
where shipping_type in ('Standard','Express')
group by shipping_type
order by avg(purchase_amount_in_usd) desc;



select subscription_status,
	avg(purchase_amount_in_usd) as average_spend,
    sum(purchase_amount_in_usd) as total_revenue 
    from customer
    group by subscription_status
    order by average_spend desc;
    

select item_purchased,
	concat(round((sum(case when discount_applied = 'Yes' then 1 else 0 end)/count(*))*100,2),'%') as purchase_percent
    from customer
	group by item_purchased
	order by purchase_percent desc
	limit 5;
    
    

select case when previous_purchases=1 then 'New'
	when previous_purchases between 2 and 10 then 'Returning'
    else 'Loyal' end as customer_type,
    count(customer_id)
    from customer
    group by segement;



with etc as(select category,item_purchased,
	count(item_purchased) as countt,
    row_number() over(partition by category order by count(item_purchased) desc) as rankk
	from customer 
	group by category,item_purchased
)
	select rankk,category,item_purchased,countt from etc
    where rankk<=3;
    
    
    
select subscription_status,count(customer_id) from customer
where previous_purchases >5
group by subscription_status;



select 
	age_group,
	concat(round((sum(purchase_amount_in_usd)/
    (select sum(purchase_amount_in_usd) from customer))*100,2),'%') as revenue_contribution  
		/*another way,  
		(sum(purchase_amount_in_usd)/ sum(sum(purchase_amount_in_usd)) over() *100 */
from customer
group by age_group
order by revenue_contribution desc;