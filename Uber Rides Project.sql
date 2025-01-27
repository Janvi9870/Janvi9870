

show databases;
create database taxi_app;
use taxi_app

select * from drivers_csv;
select * from riders_csv;
select * from passengers_csv ;	

#Basic Level-->

#Q1: What are & how many unique pickup locations are there in the dataset?
select distinct pickup_location , count(pickup_location)
from riders_csv 
group by pickup_location ;

#Q:2 : What is the total number of rides in the dataset?
select count(*) from riders_csv ;

#Q3: Calculate the average ride duration.
select  round(avg(ride_duration)) from riders_csv ; 

#Q4: List the top 5 drivers based on their total earnings.
select driver_id  , round(sum(earnings)) as Total_earnings
from drivers_csv
group by driver_id 
order by Total_earnings desc limit 5 ;

#Q5: Calculate the total number of rides for each payment method.
select payment_method , count(*)  as Total_rides
from riders_csv 
group by payment_method ;

#Q6: Retrieve rides with a fare amount greater than 20.14523
select * from riders_csv where fare_amount > 20.14523;

#Q7: Identify the most common pickup location.
select pickup_location , count(*) as ride_count
from riders_csv 
group by pickup_location 
order by ride_count desc limit 2;

#Q8: Calculate the average fare amount.
select round(avg(fare_amount))
from riders_csv rc ;

#Q9: List the top 10 drivers with the highest average ratings.
select driver_id, avg(rating) as avg_rating
from drivers_csv 
group by driver_id 
order by avg_rating desc limit 10;

#Q10: Calculate the total earnings for all drivers.
select driver_id , round(sum(earnings)) as total_earnings
from drivers_csv 
group by driver_id 
order by total_earnings desc  ;

#Q11: How many rides were paid using the "Cash" payment method?
select payment_method , count(*)  as Total_rides
from riders_csv 
where payment_method = "cash";

#Q12: Calculate the number of rides & average ride distance for rides originating from the 'Dhanbad' pickup location.
select pickup_location ,count(*) , avg(ride_distance) as avg_distance
from riders_csv 
where pickup_location = "Dhanbad";

#Q13: Retrieve rides with a ride duration less than 10 minutes.
select ride_duration  from riders_csv 
where ride_duration < 10;

#Q14: List the passengers who have taken the most number of rides.
select passenger_id,count(*) as ride_count
from riders_csv 
group by passenger_id 
order by ride_count desc limit 1;

#Q15: Calculate the total number of rides for each driver in descending order.
select driver_id,count(*) as ride_count
from riders_csv 
group by driver_id 
order by ride_count desc ;

#Q16: Identify the payment methods used by passengers who took rides from the 'Gandhinagar' pickup location.
select passenger_id,payment_method,pickup_location
from riders_csv 
where pickup_location = "Gandhinagar";

#Q17: Calculate the average fare amount for rides with a ride distance greater than 10.
select round(avg(fare_amount)) as avg_fare
from riders_csv 
where ride_distance >10;

#Q18: List the drivers in descending order accordinh to their total number of rides.
select driver_id,total_rides
from drivers_csv 
order by total_rides desc;

#Q19: Calculate the percentage distribution of rides for each pickup location.
select pickup_location,count(pickup_location) from riders_csv group by pickup_location ;
select pickup_location,count(*) from riders_csv group by pickup_location ;
select count(pickup_location) from riders_csv rc ;

select pickup_location,count(*) as ride_count,round(count(*)*100.0/(select count(*) from riders_csv rc),2) as percentage
from riders_csv rc2 
group by pickup_location 
order by percentage desc;

#Q20: Retrieve rides where both pickup and dropoff locations are the same.
select * 
from riders_csv rc 
where pickup_location = dropoff_location ;

#Intermediate Level-->

#Q1: List the passengers who have taken rides from at least 300 different pickup locations.
select passenger_id,count(distinct pickup_location) as distinct_locations
from riders_csv rc 
group by passenger_id 
having distinct_locations>=300;

#Q2: Calculate the average fare amount for rides taken on weekdays.
SELECT round(AVG(fare_amount))
FROM riders_csv rc 
WHERE DAYOFWEEK(STR_TO_DATE(ride_timestamp, '%m/%d/%Y %H:%i'))>5;

select ride_timestamp, (STR_TO_DATE(ride_timestamp)) from riders_csv  rc;

SELECT DATE_FORMAT("2017-06-15", "%M %d %Y");
SELECT DATE_FORMAT("2017-06-15", "%W %M %e %Y");

SELECT 
    ride_timestamp, 
    STR_TO_DATE(ride_timestamp, '%Y-%m-%d %H:%i:%s') AS formatted_timestamp
FROM 
    riders_csv rc;
   
   #Q3: Identify the drivers who have taken rides with distances greater than 19.
select distinct driver_id,ride_distance
from riders_csv rc 
where ride_distance >19;

#Q4: Calculate the total earnings for drivers who have completed more than 100 rides.
select driver_id,sum(earnings) as total_earnings 
from drivers_csv dc 
where driver_id IN(select driver_id from riders_csv rc group by driver_id  having count(*)>100)
group by driver_id  ;

select rides_csv.ride_id ,drivers_csv.driver_id, count(drivers_csv.driver_id), sum(drivers_csv.earnings) as total_earning
from drivers_csv inner join rides_csv 
on drivers_csv.driver_id = rides_csv.driver_id
group by drivers_csv.driver_id
having count(drivers_csv.driver_id)>100;

select drivers_csv.driver_id ,count(drivers_csv.driver_id) as ride_count ,sum(drivers_csv.earnings) as total_earning
from drivers_csv join riders_csv 
on drivers_csv.driver_id = riders_csv.driver_id 
group by drivers_csv.driver_id 
having count(drivers_csv.driver_id)>100;

#Q5: Retrieve rides where the fare amount is less than the average fare amount.
select ride_id , fare_amount 
from riders_csv 
where fare_amount < (select avg(fare_amount) as avg_fare from riders_csv rc);

#Q6: Calculate the average rating of drivers who have driven rides with both 'Credit Card' and 'Cash' payment methods.

select avg(rating) as avg_rating
from drivers_csv  in (select driver_id from riders_csv 
where payment_method in ('Credit card','cash') 
group by driver_id 	
having count (distinct payment_method)= 2 )
group by driver_id;

select avg(rating) as avg_rating
from drivers_csv 
where driver_id in
(select driver_id 
from riders_csv 
where payment_method in ("credit card","cash")
group by driver_id 
having count(distinct payment_method)=2);

#Q7: List the top 3 passengers with the highest total spending.
select passenger_id , passenger_name,total_spent 
from passengers_csv pc 
order by total_spent desc limit 3;

select * from passengers_csv pc 
order by total_spent desc;

select pc.passenger_id, pc.passenger_name, round(sum(rc.fare_amount)) as total_spending
from passengers_csv pc 
join riders_csv rc on pc.passenger_id =rc.passenger_id 
group by pc.passenger_id ,pc.passenger_name 
order by total_spending desc 
limit 3;

#Q8: Calculate the average fare amount for rides taken during different months of the year.

SELECT MONTH(STR_TO_DATE(ride_timestamp, '%m/%d/%Y %H:%i')) AS month_of_year, AVG(fare_amount) AS avg_fare
FROM riders_csv rc 
GROUP BY month_of_year;

create table new_rides select * from riders_csv rc ;

select * from new_rides;

SELECT MONTH(ride_timestamp) AS month_of_year, AVG(fare_amount) AS avg_fare
FROM riders_csv rc
GROUP BY month_of_year;




select ride_timestamp, monthname(STR_TO_DATE(ride_timestamp, '%m/%d/%Y %H:%i')) as new_date  from rides_csv rc ;

select ride_timestamp, monthname(STR_TO_DATE(ride_timestamp, '%m/%d/%Y')) as new_date  from rides_csv rc ;



(STR_TO_DATE(ride_timestamp, '%m/%d/%Y %H:%i') as ride_date from new_rides;

#Q9: Identify the most common pair of pickup and dropoff locations.
SELECT pickup_location, dropoff_location, COUNT(*) AS ride_count
FROM riders_csv rc
GROUP BY pickup_location, dropoff_location
order by ride_count desc
limit 1;

SELECT pickup_location, dropoff_location, COUNT(*) AS ride_count
FROM riders_csv rc 
GROUP BY pickup_location, dropoff_location
ORDER BY ride_count DESC
;

#Q10: Calculate the total earnings for each driver and order them by earnings in descending order.
SELECT driver_id, SUM(earnings) AS total_earnings
FROM drivers_csv dc 
GROUP BY driver_id
ORDER BY total_earnings DESC;

#Q11: List the passengers who have taken rides on their signup date.
SELECT pc.passenger_id, pc.passenger_name
FROM passengers_csv pc  
JOIN riders_csv rc  ON pc.passenger_id = rc.passenger_id
WHERE DATE(pc.signup_date) = DATE(rc.ride_timestamp);

#Q12: Calculate the average earnings for each driver and order them by earnings in descending order.
SELECT driver_id, avg(earnings) AS average_earnings
FROM drivers_csv dc 
GROUP BY driver_id
ORDER BY average_earnings DESC;

#Q13: Retrieve rides with distances less than the average ride distance.
SELECT ride_id, avg(ride_distance)
FROM riders_csv rc 
WHERE ride_distance < (SELECT AVG(ride_distance) FROM riders_csv rc)
group by ride_id;

SELECT AVG(ride_distance) FROM rides_csv;

#Q14: List the drivers who have completed the least number of rides.
SELECT driver_name , COUNT(driver_id) AS ride_count
FROM drivers_csv dc 
GROUP BY dc.driver_id,dc.driver_name 
ORDER BY ride_count asc;

#Q15: Calculate the average fare amount for rides taken by passengers who have taken at least 20 rides.
SELECT AVG(fare_amount)
FROM riders_csv rc 
WHERE passenger_id IN (SELECT passenger_id FROM riders_csv rc GROUP BY passenger_id HAVING COUNT(*) >= 20);

#Q16: Identify the pickup location with the highest average fare amount.
SELECT pickup_location, AVG(fare_amount) AS avg_fare
FROM riders_csv rc 
GROUP BY pickup_location
ORDER BY avg_fare desc
LIMIT 1;


#Q17: Calculate the average rating of drivers who completed at least 100 rides.
SELECT AVG(rating) FROM drivers_csv dc WHERE driver_id IN 
(SELECT driver_id FROM riders_csv rc  GROUP BY driver_id  HAVING COUNT(*) >= 100
);

select dc.driver_id, avg(rating) as Avg_Rating
from drivers_csv dc  inner join riders_csv rc  
on dc.driver_id = rc.driver_id 
group by dc.driver_id 
having avg(rating)<100;

#Q18: List the passengers who have taken rides from at least 5 different pickup locations.
SELECT passenger_id,COUNT(DISTINCT pickup_location) AS distinct_locations
FROM riders_csv rc 
GROUP BY rc.passenger_id
HAVING distinct_locations >= 300;

#Q19: Calculate the average fare amount for rides taken by passengers with ratings above 4.
SELECT AVG(fare_amount) FROM riders_csv rc  WHERE passenger_id in
(SELECT passenger_id FROM passengers_csv pc WHERE rating > 4);


select * from drivers_csv dc ;
select * from riders_csv rc ;
select * from passengers_csv ;




