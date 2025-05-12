create database quick_commerce;
use quick_commerce;

select count(*) from quick_commerce;
describe quick_commerce;

alter table quick_commerce
modify column Order_id varchar(255);

-- What is the average delivery time per month for each delivery agent?
select
Agent_name as Agent,
date_format(Order_Timestamp,'%Y-%m') as Month,
round(avg(Delivery_Time_Minutes),2) as avg_delivery_time
from
quick_commerce
group by 1,2
order by avg_delivery_time desc;

-- How many orders were placed each week by location?
select
Year(Order_Timestamp) as Year,
week(Order_Timestamp,3) as week,
Location,
count(Order_id) as NO_Orders
from
quick_commerce
group by 1,2,3
order by  NO_Orders desc;

-- What is the monthly average customer rating for each delivery agent?
select
Agent_Name,
date_format(Order_Timestamp, '%Y-%m') as Month,
round(avg(Rating),2) as Avg_Rating
from
quick_commerce
group by 1,2
order by Avg_Rating desc;

-- How does the average customer service rating change over time by agent?
select
Agent_name,
date_format(Order_Timestamp,'%Y-%m') as Time,
round(avg(Customer_Service_Rating)) as Avg_Customer_Rating
from
quick_commerce
group by 1,2
order by Avg_Customer_Rating desc;

-- How many 'Out of Stock' incidents occurred per week for each order type?
select
Order_Type,
Year(Order_Timestamp) as Year,
Week(Order_Timestamp,3) as Week,
count(Product_Availability) as Out_Of_Stock
from
quick_commerce
where Product_Availability='Out of Stock'
group by 1,2,3
order by Out_Of_Stock desc;

-- What percentage of deliveries took more than 45 minutes, broken down by week and agent?
Select
Agent_Name,
Year(Order_Timestamp) as Year,
Week(Order_Timestamp,3) as Week,
round(sum(case when Delivery_Time_Minutes>45 then 1 else 0 end)*100/count(*),2) as late_delivery_percent
from 
quick_commerce
group by 1,2,3
order by  late_delivery_percent desc;

-- What is the monthly trend of incorrect orders per agent?
select
Agent_Name,
date_format(Order_Timestamp,'%y-%m') as Month,
count(*) as Incorrect_Orders
from 
quick_commerce
where Order_Accuracy='incorrect'
group by 1,2
order by Incorrect_Orders desc;

-- Is there a difference in average rating between orders with and without discounts?
select
Discount_applied,
avg(Rating)
from
quick_commerce
group by 1;

-- How many positive, neutral, and negative reviews were received per agent over the last 6 months?
select
Agent_Name,
Customer_Feedback_Type,
date_format(Order_Timestamp,'%Y-%m') as Month,
count(*) as no_of_feedback
from
quick_commerce
where Order_Timestamp >= date_sub(CURDATE(),interval 6 month)
group by 1,2,3
order by Agent_Name, Month;

-- Which hours of the day have the highest Order?
select
Agent_Name,
Order_type,
hour(Order_Timestamp) as hour,
count(Order_id) as no_orders
from
quick_commerce
group by 1,2,3
order by  no_orders desc;

-- Which hours of the day have the highest average delivery time?" (Requires timestamp or derived hour column)
select
hour(Order_Timestamp) as Hour,
round(avg(Delivery_Time_Minutes),2) as avg_highest_delivery
from
quick_commerce
group by 1
order by  avg_highest_delivery desc;

-- Which locations have the highest average customer rating in the last 3 months?
select
Location,
date_format(Order_Timestamp,'%Y-%m') as Month,
round(avg(Rating),2) as avg_cutomer_rating
from
quick_commerce
where Order_Timestamp>=date_format(date_sub(curdate(),Interval 3 month),'%Y-%m-01')
And Order_Timestamp< date_format(curdate(),'%Y-%m-01')
group by 1,2
order by avg_cutomer_rating desc;

-- Which agent has the highest percentage of positive feedback in each month?
select
Agent_Name,
date_format(Order_Timestamp,'%Y-%m') as Month,
round(sum(case when Customer_Feedback_Type='Positive' then 1 else 0 End) *100/count(*),2) as Positive_FeedBack_Percentage
from 
quick_commerce
group by 1,2
order by Positive_FeedBack_Percentage desc;

-- List all orders where a discount was applied but the rating was 2 stars or below.
select
*
from
quick_commerce
where Discount_Applied='Yes' AND Rating<=2;

-- What is the average customer service rating for each price range category (Low, Medium, High) over time?
select
Price_Range,
date_format(Order_Timestamp,'%Y-%m') as Month,
round(avg(Customer_Service_Rating),2) as AVG_Customer_Rating
from
quick_commerce
group by 1,2
order by AVG_Customer_Rating desc;


