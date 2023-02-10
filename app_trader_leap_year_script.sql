--a. Develop some general recommendations about the price range, genre, content rating,
--or any other app characteristics that the company should target.

--The most popular genre is gaming, with average rating of 4.3 & a price of $0.99, rated for everyone.

--cleaned tables of both stores:
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

--top rated by price--
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
SELECT name, app_price, play_price, play_rating
FROM play_sorted
		INNER JOIN app_sorted USING(name)
ORDER BY app_price DESC;
--80% of apps are free

--top rated by genre--
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
SELECT
	app_genres,
	COUNT(*) AS num_apps,
	AVG(app_rating) AS avg_rating,
	AVG(app_price) AS avg_price
FROM play_sorted
		INNER JOIN app_sorted USING(name)
GROUP BY app_genres
ORDER BY num_apps DESC;
--the top rated apps in the games genre were around $0.99.

--genre by content rating--
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
SELECT app_genres, play_content_rating, COUNT(*)
FROM play_sorted
		INNER JOIN app_sorted USING(name)
WHERE app_genres = 'Games'
GROUP BY play_content_rating, app_genres;

--top rated by content rating--
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
	   ROUND(AVG(play_rating), 2) AS avg_rating,
	   ROUND(AVG(play_price), 2) AS avg_price
FROM play_sorted
		INNER JOIN app_sorted USING(name)
GROUP BY play_content_rating;



--b. Develop a Top 10 List of the apps that App Trader should buy based on profitability/return\
--on investment as the sole priority.

--the Top 10 apps based on profitability/return include:
--1. H*nest Meditation; 2. Fernanfloo; 3. PewDiePie's Tuber Simulator; 4. Narcos: Cartel Wars;
--5. Domino's Pizza USA; 6. ASOS; 7. Deck Heroes: Lecagy; 8. Cytus; 9. Bible; 10. Egg, Inc.

--*note: due to several apps tying for total revenue, it would be ideal to consider the top 15 apps.

--added lifespan of app & broker cost to CTE--
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
SELECT *
FROM play_sorted
		INNER JOIN app_sorted USING(name);

--(profit-broker cost = revenue)
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
	   (play_duration_years * (4500*12)) - play_broker_cost AS app_income,
	   app_review_count
FROM play_sorted
		INNER JOIN app_sorted USING(name)
ORDER BY app_income DESC
LIMIT 20;

--initial broker price, present in both stores:
(SELECT name, price,
	  CASE WHEN price > 2.50 THEN price*10000
	  ELSE 25000 END AS broker_cost
FROM app_store_apps)
INTERSECT
(SELECT name, price::money::numeric,
	  CASE WHEN price::money::numeric > 2.50 THEN price::money::numeric*10000
	  ELSE 25000 END AS broker_cost
FROM play_store_apps);

--additional consideration: how quickly does an app "break even"?

--c. Develop a Top 4 list of the apps that App Trader should buy that are profitable
--but that also are thematically appropriate for next months's Pi Day themed campaign.

--for Pi Day: "Domino's Pizza" (order a pie for Pi Day), "Cooking Fever" (bake a *simulated* pie for Pi Day),
--"Trivia Crack" (what do you know about pi?), "Allrecipes" (bake a pie for Pi Day)

--for Valentine's Day: "Candy Crush Saga", "Tom Loves Angela", "sugar, sugar", "Tinder"

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
SELECT name, play_genres,
	   (play_duration_years * (4500*12)) - play_broker_cost AS app_income,
	   app_review_count
FROM play_sorted
		INNER JOIN app_sorted USING(name)
WHERE name ILIKE '%tinder%'
	OR name ILIKE '%candy%'
	OR name ILIKE '%love%'
 	OR name ILIKE '%sugar%'
ORDER BY app_income DESC;
