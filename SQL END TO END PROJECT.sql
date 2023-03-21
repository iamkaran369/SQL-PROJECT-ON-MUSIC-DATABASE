--Q1 = who is the senior most employee based on job title?

select * from employee
--AFTER SEEING EMPLOYEE TABLE WE CAN UNDERSTAND SENIOR EMPLOYEE BY THEIR LEVELS.

select employee_id,first_name,last_name,title,levels from employee
order by levels desc
limit 1

--Q2 = which countries have the most invoices?

SELECT count(invoice_id)as count_of_invoice,billing_country FROM INVOICE
group by billing_country
order by count_of_invoice desc

--AFTER SEEING TABLE WE CAN COUNT INVOICE ID AND CAN GROUP BY BILLING COUNTRY TO FIND ANSWER. 

--Q3 = what are top 3 values of total invoice?

select total from invoice
order by total desc
limit 3

--Q4 = which city has the best customers? we would
--like to throw a promotional music festival in
--the city we made the most money. write a query 
--that returns one city that has the highest sum
--of invoice totals.return both the city name and
--sum of all invoice totals

select sum(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc
limit 3

-- PRAGUE HAVE THE HIGHEST INVOICE TOTAL 

--Q5 = who is the best customer? the customer who has
--spent the most money will be declared the best 
--customer. write a query that returns the person 
--who has spent the most money.

--BY JOINING TWO TABLES CUSTOMER AND INVOICE, WE CAN FIND THE ANSWER

select customer.customer_id, customer.first_name,customer.last_name,sum(invoice.total) as total
from customer
join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by total desc
limit 1


--Q6 = WRITE QUERY TO RETURN THE EMAIL, FIRST NAME, LAST NAME,
--AND GENRE OF ALL ROCK MUSIC LISTENERS, RETURN YOUR LIST ORDERED
--ALPHABETICALLY BY EMAIL STARTING WITH A
select distinct email,first_name,last_name
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id  in(
    select track_id from track
	join genre on track.genre_id=genre.genre_id
	where genre.name like 'rock'
)
order by email;


--Q7= let's invite the artists who have the most rock music in 
--our dataset.write a query that returns the artist name and total
--track count of the top 10 rock bands
select artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'rock'
group by artist.artist_id
order by number_of_songs desc
LIMIT 10


--Q8= Return all the track names that have a song length longer than
--the average song length.return the name and milliseconds for each track.
--order by the song length with the longest songs listed first
--1ST SOLUTION--NON DYNAMIC
select name,milliseconds 
from track
where milliseconds > 393599.212103910933
ORDER BY milliseconds desc

--2ND SOLUTION-- DYNAMIC
select name,milliseconds 
from track
where milliseconds > (
select avg(milliseconds) from track)
order by milliseconds desc


--Q9= find how much amount spent by each customer on artists?
--write a query to return customer name,artist ame and total spent

with best_selling_artist as (
	select artist.artist_id as artist_id,artist.name as artist_name,
	sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	from invoice_line
	join track on track.track_id = invoice_line.track_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	group by 1
	order by 3 desc
	limit 1
)

select c.customer_id,c.first_name,c.last_name,bsa.artist_name,
sum(il.unit_price*il.quantity) as amount_spent
from invoice as i
join customer as c on c.customer_id = i.customer_id
join invoice_line as il on il.invoice_id = i.invoice_id
join track as t on t.track_id = il.track_id
join album as alb on alb.album_id = t.album_id
join best_selling_artist as bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc

















