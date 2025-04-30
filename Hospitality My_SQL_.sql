USE PROJECT;

---- QUES-1. TOTAL_REVENUE ----
select * from fact_bookings;

select sum(revenue_realized) as total_revenue
FROM fact_bookings;

---- QUES-2. OCCUPANCY ----

select * from fact_aggregated_bookings;

select property_id,SUM(successful_bookings) / SUM(capacity) * 100 AS occupancy_rate
FROM fact_aggregated_bookings 
group by property_id;

---- QUES-3. CANCELLATION RATE ----

Select * from fact_bookings;

select SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS cancellation_rate
FROM fact_bookings;
 
---- QUES-4. TOTAL BOOKINGS ----
    
select * from fact_bookings;

select COUNT(booking_id) AS total_bookings
FROM fact_bookings;
    
---- QUES-5. UTILIZE CAPACITY ----
    
select * from fact_aggregated_bookings;

select  sum(successful_bookings) * 100.0 / sum(capacity) AS Utilization_Rate
from fact_aggregated_bookings;
    
---- QUES.6 TREND ANALYSIS ----

 select * from fact_bookings;
 
 select DATE_FORMAT(booking_date, '%Y-%m') AS month, SUM(revenue_realized) AS total_revenue
FROM fact_bookings
GROUP BY 
    DATE_FORMAT(booking_date, '%Y-%m')
ORDER BY 
    month;
    
---- QUES.7 WEEKDAY_&_WEEKEND REVENUE AND BOOKING ----

    select * from fact_bookings;
    
    SELECT 
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(booking_date, '%Y-%m-%d')) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type, 
    COUNT(*) AS total_bookings, 
    SUM(revenue_realized) AS total_revenue
FROM fact_bookings

GROUP BY day_type
ORDER BY FIELD(day_type, 'Weekday', 'Weekend');

---- QUES.8 REVENUE BY STATE & HOTEL ----

# 1.Revenue by state

select * from fact_bookings;
select *from dim_hotels;

SELECT h.city, SUM(f.revenue_realized) AS total_revenue
FROM dim_hotels h JOIN fact_bookings f 
ON h.property_id = f.property_id
GROUP BY h.city
ORDER BY h.city ASC, total_revenue DESC;
    
# 2.Revenue By Hotel

select * from fact_bookings;
select * from dim_hotels;

SELECT h.property_name, SUM(f.revenue_realized) AS total_revenue
FROM dim_hotels h JOIN fact_bookings f
ON h.property_id = f.property_id
GROUP BY h.property_name
ORDER BY total_revenue DESC;
    
---- QUES.9 CLASS WISE REVENUE ----

select * from fact_bookings;
select * from dim_hotels;

SELECT dh.category AS hotel_class, SUM(fb.revenue_realized) AS total_revenue
FROM dim_hotels dh INNER JOIN fact_bookings fb
ON dh.property_id = fb.property_id
GROUP BY dh.category
ORDER BY total_revenue DESC;

---- QUES.10 CHECKED OUT_CANCEL_NO SHOW ----

select * from fact_bookings;

select booking_status, count(booking_status) as Count from fact_bookings
where booking_status in ('Checked Out', 'Cancelled', 'No show')
group by booking_status;



# weekly trend key trend (Revenue,Total booking,Occupancy)

SELECT * from fact_aggregated_bookings;
select * from fact_bookings;
select * from dim_hotels;
select * from dim_rooms;
select * from dim_date;

select
str_to_date(b.check_in_date, '%d-%m-%Y') as date,
year(str_to_date(b.check_in_date, '%d-%m-%Y')) as year,
week(str_to_date(b.check_in_date, '%d-%m-%Y'),1) as week_number,
sum(b.revenue_realized) as weekly_revenue,
count(b.booking_id) as weekly_bookings,
round(sum(a.successful_bookings)*100.0 / Nullif(sum(a.capacity), 0),2) as weekly_Occupancy
from fact_bookings b
join fact_aggregated_bookings a
on b.property_id = a.property_id
and str_to_date(b.check_in_date, '%d-%m-%Y') = str_to_date(a.check_in_date, '%d-%m-%Y')
group by 1,2,3 order by 1;


    

