#1a) 1a. Display the first and last names of all actors from the table `actor`. 

select first_name,
	   last_name
from actor;

#1b)Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' FROM customer;


#2a)You need to find the ID number, first name, and last name of an actor,
# of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

select actor_id,
	first_name,
    last_name
    from actor where first_name = "Joe";

   
#2b)Find all actors whose last name contain the letters `GEN`:

select * from actor where last_name LIKE '%GEN%';


#2C)Find all actors whose last names contain the letters `LI`. This time, order the rows 
#by last name and first name, in that order:

select last_name,
	   first_name
	from actor where last_name LIKE '%LI%';


#2d) Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

select country_id,
		   country
	from country where country in ('Afghanistan', 'Bangladesh', 'China');
				

#3a) Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.

ALTER table actor
    Add column middle_name integer AFTER first_name;
    	
  	
#3b) You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.

ALTER TABLE actor MODIFY middle_name blob;

#3c) Now delete the `middle_name` column.

ALTER TABLE actor drop middle_name;


#4a) List the last names of actors, as well as how many actors have that last name.

 select last_name, count(last_name) from actor group by last_name;

  	
#4b) List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

select last_name, count(last_name)
 from actor
 group by last_name 
 having count(last_name)>1;

	
#4c) Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's 
 #husband's yoga teacher. Write a query to fix the record.

 update actor 
 set first_name = 'HARPO'
 where (first_name = 'GROUCHO' and last_name = 'WILLIAMS');
  	
#4d) In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, 
#change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error.
 
   UPDATE actor 
SET first_name = CASE
   WHEN first_name = 'HARPO' THEN  'GROUCHO'
   ELSE 'MUCHO GROUCHO'
END
where actor_id = 172;

#5a) You cannot locate the schema of the `address` table. Which query would you use to re-create it? 

SHOW CREATE TABLE address;

#6a) Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

select s.first_name, s.last_name, a.address
from staff s
join address a on 
s.address_id = a.address_id;


#6b) Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 

SELECT  staff_id,
	s.last_name,
 	SUM(IF( p.payment_date like '2005-08-%', p.amount, 0)) AS sum_Aug_2005
FROM payment p
JOIN staff s 
USING(staff_id)
GROUP BY staff_id;

#6c) List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

 SELECT  film_id,
	film.title,
 	count(fa.actor_id) as Number_actor
FROM film
JOIN film_actor fa
USING(film_id)
GROUP BY film_id;

#6d) How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT film_id,
       count(store_id) as inventory
FROM inventory
WHERE film_id IN
 (
  SELECT film_id
  FROM film
  WHERE title = 'Hunchback Impossible'
 );

 #6e) Using the tables `payment` and `customer` and the `JOIN` command,
 #list the total paid by each customer. List the customers alphabetically by last name:

SELECT  customer_id,
	cu.last_name,
 	sum(p.amount) as total_paid
FROM customer cu
JOIN payment p
USING(customer_id)
group by(customer_id)
order by(cu.last_name);

505	ABNEY	97.79
504	ADAM	133.72
36	ADAMS	92.73
96	ALEXANDER	105.73
470	ALLARD	160.68
27	ALLEN	126.69
220	ALVAREZ	114.73
11	ANDERSON	106.76
326	ANDREW	96.75
183	ANDREWS	76.77
 

# 7a) The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
 # As an unintended consequence, films starting with the letters `K` and `Q`
 # have also soared in popularity. Use subqueries to display the titles of
 # movies starting with the letters `K` and `Q` whose language is English. 

 SELECT film_id,
       title as film_title
 FROM film
 WHERE (title like 'K%' or title like 'Q%') and 
       language_id IN
 (
  SELECT language_id
  FROM language
  WHERE name = 'English'
  
 );

#7b) Use subqueries to display all actors who appear in the film `Alone Trip`.

select first_name,
       last_name
from actor
where actor_id in 
(
   select actor_id
   from film_actor
   where film_id in 
   (
      select film_id
      from film
      where title = 'Alone Trip'
   )
);

ED	CHASE
KARL	BERRY
UMA	WOOD
WOODY	JOLIE
SPENCER	DEPP
CHRIS	DEPP
LAURENCE	BULLOCK
RENEE	BALL
   
#7c) 

select first_name,
       last_name,
       email
from customer 
join address 
using (address_id) 
join city
using (city_id)
join country
using (country_id)
where country = 'canada' ;

#7d) Sales have been lagging among young families, and you wish to target all
#family movies for a promotion. Identify all movies categorized as famiy films.

select title
from film
where film_id in 
(
 select film_id 
 from film_category
 where category_id in
 (
    select category_id
    from category
    where name = 'family'
  )
);

#7e) Display the most frequently rented movies in descending order.
select title,
       rental_rate
from film
order by rental_rate desc;
  	
#7f) Write a query to display how much business, in dollars, each store brought in.

select st.store_id,
	   sum(p.amount)
from store st
join payment p
on p.staff_id = st.manager_staff_id
group by st.store_id;

1	33489.47
2	33927.04

#7g) Write a query to display for each store its store ID, city, and country.


select store_id,
	   city.city,
       country.country
from store
join address
using(address_id)
join city
using(city_id)
join country
using(country_id);

1	Lethbridge	Canada
2	Woodridge	Australia
  	
#7h) List the top five genres in gross revenue in descending order. 

select name,
       sum(p.amount) as gross_revenue
from category
join film_category
using(category_id)
join inventory
using(film_id)
join rental
using(inventory_id)
join payment p
using(rental_id)
group by category.name
order by gross_revenue desc
limit 5;

Sports	5314.21
Sci-Fi	4756.98
Animation	4656.30
Drama	4587.39
Comedy	4383.58

#8a) Use the solution from the  problem above to create a view. If you haven't solved 7h, you can substitute
  #another query to create a view.

  create view gross
as
select name,
       sum(p.amount) as gross_revenue
from category
join film_category
using(category_id)
join inventory
using(film_id)
join rental
using(inventory_id)
join payment p
using(rental_id)
group by category.name
order by gross_revenue desc
limit 5;

  	
#8b) How would you display the view that you created in 8a?
select * from gross;

#8c) You find that you no longer need the view `top_five_genres`. Write a query to delete it.

drop view gross;
