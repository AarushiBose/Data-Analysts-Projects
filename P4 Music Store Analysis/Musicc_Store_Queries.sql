/*1. Who is the senior most employee based on job title? */

SELECT * FROM employee
ORDER BY levels DESC LIMIT 1;

/*2. Which countries have the most Invoices? */

SELECT billing_country AS Country, COUNT(invoice_id) AS invoices 
FROM invoice
GROUP BY Country
ORDER BY Country DESC
LIMIT 1; 

/*3. What are top 3 values of total invoice? */

SELECT total AS total_invoice FROM invoice
ORDER BY total DESC
LIMIT 3;

/*4. Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals*/

SELECT billing_city AS city, SUM(total) AS invoice_total
FROM invoice
GROUP BY city
ORDER BY invoice_total DESC
LIMIT 1;

/*5. Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money */

SELECT 
    ct.customer_id, 
    ct.first_name, 
    ct.last_name, 
    it.billing_city, 
    SUM(it.total) AS invoice_total
FROM 
    customer AS ct 
INNER JOIN 
    invoice AS it
ON 
    ct.customer_id = it.customer_id
GROUP BY 
    ct.customer_id, 
    ct.first_name, 
    ct.last_name, 
    it.billing_city
ORDER BY invoice_total DESC
LIMIT 1;

/*6. Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A*/

SELECT first_name, last_name, email 
FROM customer
INNER JOIN invoice ON customer.customer_id = invoice.customer_id
INNER JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id	   
WHERE track_id IN (
                   SELECT track_id FROM track
                   INNER JOIN genre 
                   ON track.genre_id = genre.genre_id
                   WHERE genre.name LIKE 'Rock')
ORDER BY email ASC;				   

/*7. Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands*/

SELECT artist.artist_id, artist.name, COUNT(track.track_id) AS total_tracks
FROM artist 
INNER JOIN album ON artist.artist_id = album.artist_id
INNER JOIN track ON album.album_id = track.album_id
WHERE track_id IN (
                   SELECT track_id FROM track
                   INNER JOIN genre 
                   ON track.genre_id = genre.genre_id
                   WHERE genre.name LIKE 'Rock' )
GROUP BY artist.artist_id
ORDER BY total_tracks DESC 
LIMIT 10;

/*8. Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first */

SELECT ROUND(AVG(milliseconds),0) AS average_song_length FROM track;

SELECT track_id, name, milliseconds AS song_length_ms
FROM track
WHERE milliseconds > 393599
ORDER BY song_length_ms DESC;

/*9. Find how much amount spent by each customer on artists? Write a query to return 
customer name, artist name and total spent*/

WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name,
	SUM(invoice_line.unit_price * invoice_line.quantity)AS sales
	FROM invoice_line
	INNER JOIN track ON invoice_line.track_id = track.track_id
	INNER JOIN album ON track.album_id = album.album_id
	INNER JOIN artist ON album.artist_id = artist.artist_id
	GROUP BY 1
	ORDER BY 3 DESC	
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
INNER JOIN customer c ON c.customer_id = i.customer_id
INNER JOIN invoice_line il ON il.invoice_id = i.invoice_id
INNER JOIN track t ON t.track_id = il.track_id
INNER JOIN album alb ON alb.album_id = t.album_id
INNER JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

/*10. We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres */

WITH popular_genre AS (
   SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
   ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo
   FROM invoice_line
   JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
   JOIN customer ON customer.customer_id = invoice.customer_id
   JOIN track ON track.track_id = invoice_line.track_id
   JOIN genre ON genre.genre_id = track.genre_id
   GROUP BY 2,3,4
   ORDER BY 2 ASC, 1 DESC	
)
SELECT * FROM popular_genre WHERE RowNo <= 1;

/*11. Write a query that determines the customer that has spent the most on music for each 
country. Write a query that returns the country along with the top customer and how 
much they spent. For countries where the top amount spent is shared, provide all 
customers who spent this amount */

WITH cte AS (
    SELECT 
        customer.customer_id, 
        customer.first_name, 
        customer.last_name, 
        invoice.billing_country,
        SUM(invoice.total) AS spendings,
        ROW_NUMBER() OVER(PARTITION BY invoice.billing_country ORDER BY SUM(invoice.total) DESC) AS RowNo
    FROM 
        invoice
    INNER JOIN 
        customer ON customer.customer_id = invoice.customer_id
    GROUP BY 
        customer.customer_id, 
        customer.first_name, 
        customer.last_name, 
        invoice.billing_country
)
SELECT * FROM cte WHERE RowNo = 1;








