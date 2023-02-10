--Simple Start To Explore Both Tables

SELECT *
FROM app_store_apps

SELECT *
FROM play_store_apps

--Starting Point For 3a Evaluations. Apps that are in both platforms since this is App Trader's preferance.
--Less is spent on marketing and those in both apps have the potential to reach a boarder audience.

WITH app_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS app_rating,
								MAX(review_count) AS app_review_count,
								MAX(price) AS app_price,
								MAX(content_rating) AS app_content_rating,
								MAX(primary_genre) AS app_genres
					FROM app_store_apps
					GROUP BY name),
	play_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS play_rating,
								MAX(review_count) AS play_review_count,
								MAX(install_count) AS play_install_count,
								MAX(price::money::numeric) AS play_price,
								MAX(content_rating) AS play_content_rating,
								MAX(genres) As play_genres
					FROM play_store_apps
					GROUP BY name)
SELECT *
FROM play_sorted
		INNER JOIN app_sorted USING(name);
		
--Deliverables

--3a. Develop some general recommendations about the price range, genre, 
--content rating, or any other app characteristics that the company should target.


--3a - Price Range Evaluation
WITH app_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS app_rating,
								MAX(review_count) AS app_review_count,
								MAX(price) AS app_price,
								MAX(content_rating) AS app_content_rating,
								MAX(primary_genre) AS app_genres
					FROM app_store_apps
					GROUP BY name),
	play_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS play_rating,
								MAX(review_count) AS play_review_count,
								MAX(install_count) AS play_install_count,
								MAX(price::money::numeric) AS play_price,
								MAX(content_rating) AS play_content_rating,
								MAX(genres) As play_genres
					FROM play_store_apps
					GROUP BY name)
SELECT name,
		play_price,
		app_price
FROM play_sorted
		INNER JOIN app_sorted USING(name)
ORDER BY app_price DESC;
-- Answer 80% are free apps so we recommend App Trader target free apps

--3a. Genre Evaluation

WITH app_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS app_rating,
								MAX(review_count) AS app_review_count,
								MAX(price) AS app_price,
								MAX(content_rating) AS app_content_rating,
								MAX(primary_genre) AS app_genres
					FROM app_store_apps
					GROUP BY name),
	play_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS play_rating,
								MAX(review_count) AS play_review_count,
								MAX(install_count) AS play_install_count,
								MAX(price::money::numeric) AS play_price,
								MAX(content_rating) AS play_content_rating,
								MAX(genres) As play_genres
					FROM play_store_apps
					GROUP BY name)
SELECT app_genres,AVG(app_rating), AVG(app_price),
COUNT(*) AS number_apps
FROM play_sorted
		INNER JOIN app_sorted USING(name)
GROUP BY app_genres
ORDER BY number_apps DESC;
--Most popular genre is games. We reccomendation App Trader target game apps that are around $0.99.

--3a. Content Rating Eval

WITH app_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS app_rating,
								MAX(review_count) AS app_review_count,
								MAX(price) AS app_price,
								MAX(content_rating) AS app_content_rating,
								MAX(primary_genre) AS app_genres
					FROM app_store_apps
					GROUP BY name),
	play_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS play_rating,
								MAX(review_count) AS play_review_count,
								MAX(install_count) AS play_install_count,
								MAX(price::money::numeric) AS play_price,
								MAX(content_rating) AS play_content_rating,
								MAX(genres) As play_genres
					FROM play_store_apps
					GROUP BY name)
SELECT play_content_rating,
COUNT(*),
AVG(play_rating) AS rating,
AVG(play_price) AS price
FROM play_sorted
		INNER JOIN app_sorted USING(name)
GROUP BY play_content_rating;
--ANSWER: Most popular content rating EVERYONE. It also has high ratings/interaction


--3b Develop a Top 10 List of the apps that App Trader should buy based on 
--profitability/return on investment as the sole priority.

WITH app_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS app_rating,
								(rating * 2) + 1 AS app_duration_years,
								MAX(review_count) AS app_review_count,
								MAX(price) AS app_price,
								MAX(content_rating) AS app_content_rating,
								MAX(primary_genre) AS app_genres,
								CASE WHEN price > 2.50 THEN ROUND(price *10000, 0)
	  								ELSE 25000 END AS app_broker_cost
					FROM app_store_apps
					GROUP BY name, price, rating),
	play_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS play_rating,
								MAX(rating) * 2 + 1 AS play_duration_years,
								MAX(review_count) AS play_review_count,
								MAX(install_count) AS play_install_count,
								MAX(price::money::numeric) AS play_price,
								MAX(content_rating) AS play_content_rating,
								MAX(genres) As play_genres,
								CASE WHEN price::money::numeric > 2.50 THEN ROUND(price::money::numeric*10000, 0)
	  								ELSE 25000 END AS play_broker_cost
					FROM play_store_apps
					GROUP BY name, price)
SELECT name,
		(play_duration_years * (4500*12)) - play_broker_cost AS app_income
FROM play_sorted
		INNER JOIN app_sorted USING(name)
ORDER BY app_income DESC
LIMIT 10;

--3c. Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are 
--thematically appropriate for next months's Pi Day themed campaign.

WITH app_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS app_rating,
								(rating * 2) + 1 AS app_duration_years,
								MAX(review_count) AS app_review_count,
								MAX(price) AS app_price,
								MAX(content_rating) AS app_content_rating,
								MAX(primary_genre) AS app_genres,
								CASE WHEN price > 2.50 THEN ROUND(price *10000, 0)
	  								ELSE 25000 END AS app_broker_cost
					FROM app_store_apps
					GROUP BY name, price, rating),
	play_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS play_rating,
								MAX(rating) * 2 + 1 AS play_duration_years,
								MAX(review_count) AS play_review_count,
								MAX(install_count) AS play_install_count,
								MAX(price::money::numeric) AS play_price,
								MAX(content_rating) AS play_content_rating,
								MAX(genres) As play_genres,
								CASE WHEN price::money::numeric > 2.50 THEN ROUND(price::money::numeric*10000, 0)
	  								ELSE 25000 END AS play_broker_cost
					FROM play_store_apps
					GROUP BY name, price)
SELECT name,
		(play_duration_years * (4500*12)) - play_broker_cost AS app_income
FROM play_sorted
		INNER JOIN app_sorted USING(name)
ORDER BY app_income DESC;

--3c Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are thematically 
--appropriate for next months's Pi Day OR VALENTINE's DAY themed campaign.

--Went with Valentine's Day--


WITH app_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS app_rating,
								(rating * 2) + 1 AS app_duration_years,
								MAX(review_count) AS app_review_count,
								MAX(price) AS app_price,
								MAX(content_rating) AS app_content_rating,
								MAX(primary_genre) AS app_genres,
								CASE WHEN price > 2.50 THEN ROUND(price *10000, 0)
	  								ELSE 25000 END AS app_broker_cost
					FROM app_store_apps
					GROUP BY name, price, rating),
	play_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS play_rating,
								MAX(rating) * 2 + 1 AS play_duration_years,
								MAX(review_count) AS play_review_count,
								MAX(install_count) AS play_install_count,
								MAX(price::money::numeric) AS play_price,
								MAX(content_rating) AS play_content_rating,
								MAX(genres) As play_genres,
								CASE WHEN price::money::numeric > 2.50 THEN ROUND(price::money::numeric*10000, 0)
	  								ELSE 25000 END AS play_broker_cost
					FROM play_store_apps
					GROUP BY name, price)
SELECT name,
		(play_duration_years * (4500*12)) - play_broker_cost AS app_income
FROM play_sorted
		INNER JOIN app_sorted USING(name)
WHERE name ILIKE '%candy%'
OR name ILIKE '%love%'
OR name ILIKE '%sugar%'
OR name ILIKE '%sugar%'
OR name ILIKE '%tinder%'
ORDER BY app_income DESC;
--ANSWER: Candy Crush, Tom's Love Letters, Sugar,Sugar,Tinder



--Just some simple trial and error playing with trying to figure our profitability


--1.	Determine life span of apps based on star rating. Remember . 
You can estimate the lifespan of an app by looking at its star rating. 
The longevity of an app begins at 1 year for an app with a rating of 0 and increases by six months for 
every quarter point increase in rating.

SELECT name, rating, (rating*2)+1 AS app_lifespan
FROM app_store_apps
UNION
SELECT name, rating, (rating*2)+1 AS app_lifespan
FROM play_store_apps;

--3.	Look at app price and based on price calculate price app trader paid to broker rights from developer

SELECT name, price,
	  CASE WHEN price > 2.50 THEN price*10000
	  ELSE 25000 END AS broker_cost
FROM app_store_apps;

SELECT name, price,
	  CASE WHEN price::money::numeric > 2.50 THEN price::money::numeric*10000
	  ELSE 25000 END AS broker_cost
FROM play_store_apps;

--2. Which apps are in both platforms B. Which are only in a single platform ??



SELECT a.name AS apple_name,p.name AS play_store_name,a.price,p.price
FROM app_store_apps AS a
FULL JOIN play_store_apps AS p
USING(name)

SELECT name
FROM app_store_apps
WHERE name IN
		(SELECT name
		 FROM play_store_apps);







SELECT name, price
FROM app_store_apps
CASE WHEN price <= 2.50 THEN 25000,
WHEN price > 2.50 then price*100000




