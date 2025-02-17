create database cofee_database;

select* from coffee_shop_sales;

select count(*)
from coffee_shop_sales;

describe coffee_shop_sales;

-- Cleaning and Modify the DATA

SET SQL_SAFE_UPDATES = 0;

-- Change the Data-Type in Date Formate
update coffee_shop_sales
set transaction_date= str_to_date(transaction_date, '%d-%m-%Y');

alter table coffee_shop_sales
modify column transaction_date date;

-- Chnage the Data-Type in Time Formate
update coffee_shop_sales
set transaction_time= str_to_date(transaction_time, '%H:%i:%s');

alter table coffee_shop_sales
modify column transaction_time time;


alter table coffee_shop_sales
rename column ï»¿transaction_id to transaction_id ;




