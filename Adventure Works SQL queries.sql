use adventure_works;

select * from final_file; 
select * from dimcustomer;
select * from dimproductcategory;
select * from dimproductsubcategory;
select * from dimsalesterritory;
select * from dimproduct;

## 1. Total profit,Total sales,Total Quantity
select concat(round(sum(salesamount2)/1000000,1)," M") Total_Sales,
concat(round(sum(profit)/1000000,1)," M")Total_Profit,
sum(orderquantity)Total_Quantity 
from final_file;

## 2. Total Profit from Male
select concat(round(sum(b.profit)/1000000,1)," M") Profit_Male
from dimcustomer as a
join final_file as b
on a.customerkey=b.customerkey
where gender="M";


## 3. Total Profit from female
select concat(round(sum(b.profit)/1000000,1)," M") Profit_Female
from dimcustomer as a
join final_file as b
on a.customerkey=b.customerkey
where gender="F";


## 4. Region wise profit and sales
select Region,Sales,Profit from(
select salesterritoryregion as Region,
concat(round(sum(b.salesamount2)/1000000,1),"M")Sales,
concat(round(sum(b.profit)/1000000,1),"M")Profit, dense_rank() over( order by  sum(salesamount) desc)drnk
from dimsalesterritory as a
join final_file as b
on a.salesterritorykey=b.salesterritorykey
group by 1)ab;


## 5. Product name based count
select distinct englishproductname as Product_name,count(*)Quantity
from dimproduct as a
join dimproductsubcategory as b
on a.productsubcategorykey=b.productsubcategorykey
join dimproductcategory as c
on b.productcategorykey=c.productcategorykey
group by 1 order by 2 desc;


## 6.Sales and Profit Territory and Country based 
select Territory,Country,Sales,Profit from (
select b.salesterritorygroup as Territory,b.salesterritorycountry as Country,
concat(round(sum(a.salesamount2)/1000000,1)," M")Sales,
concat(round(sum(a.profit)/1000000,1)," M")Profit,
dense_rank() over(order by sum(profit) desc)drnk
from final_file as a
join dimsalesterritory as b
on a.salesterritorykey=b.salesterritorykey
group by 1,2)ab;


## 7. Subcategory wise sales and profit and Quantity
select Subcategory,Quantity,Sales,Profit from(
select b.englishproductsubcategoryname as Subcategory,
count(b.englishproductsubcategoryname)Quantity,
concat(round(sum(c.salesamount2)/100000,1)," M")Sales,
concat(round(sum(c.profit)/100000,1)," M")Profit,
dense_rank() over(order by sum(profit) desc)drnk
from dimproduct as a
join dimproductsubcategory as b
on a.productsubcategorykey=b.productsubcategorykey
join final_file as c 
on a.productkey=c.productkey
group by 1)ab;


## 8. product based stock level
select englishproductname as Product_name,
safetystocklevel as Stock_level,count(safetystocklevel)Count_of_Quantity
from dimproduct group by 1,2 order by 3 desc;

## 9.Year-Quarter wise sales and Profit
select Year,Quarter,Sales,Profit from(
select year,quarter,concat(round(sum(salesamount)/100000,1)," L")Sales,
concat(round(sum(profit)/100000,1)," L")Profit,
dense_rank() over(order by sum(salesamount) desc)drnk
from final_file group by 1,2)ab;


## 10. Year-Month wise sales and profit
select Year,Month_Name,Sales,Profit from(
select year,monthfullname as Month_name,concat(round(sum(salesamount)/100000,1)," L")Sales,
concat(round(sum(profit)/100000,1)," L")Profit,
dense_rank() over(order by sum(salesamount) desc)drnk
from final_file group by 1,2)ab;

## 11. Product name wise production cost
select englishproductname as product,
round(sum(productioncost),1) as Total_cost
from final_file group by 1 order by 2 desc;

## 12. Order number based count
select salesordernumber as Order_numbers,count(*)Count_of_Orders from final_file group by 1 order by 2 desc;

