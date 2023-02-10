SELECT *
FROM app_store_apps;

SELECT *
FROM play_store_apps;

--DURATION--
(SELECT name, 
		rating,
		(rating * 2) + 1 AS year,
 		primary_genre AS genres
FROM app_store_apps)
UNION ALL
(SELECT name, 
		rating,
		(rating * 2) + 1 AS year,
 		genres
FROM play_store_apps);

--BROKER COSTS--
SELECT name, price,
	  CASE WHEN price > 2.50 THEN price*10000
	  ELSE 25000 END AS broker_cost
FROM app_store_apps;

SELECT name, price,
	  CASE WHEN price::money::numeric > 2.50 THEN price::money::numeric*10000
	  ELSE 25000 END AS broker_cost
FROM play_store_apps;


--BOTH PLATFORMS--
SELECT name
FROM app_store_apps
WHERE name IN
		(SELECT name
		 FROM play_store_apps);

--PLAY_STORE_APP sorted with DISTINCT name--
SELECT DISTINCT name,
		MAX(rating) AS rating,
		MAX(review_count) AS review_count,
		MAX(install_count) AS install_count,
		MAX(price::money) AS price,
		MAX(content_rating) AS content_rating,
		MAX(genres) As genres
FROM play_store_apps
GROUP BY name;

--APP_STORE_APPS sorted with DISTINCT name--
SELECT DISTINCT name,
		MAX(rating) AS rating,
		MAX(review_count) AS review_count,
		MAX(price::money) AS price,
		MAX(content_rating) AS content_rating,
		MAX(primary_genre) AS genres
FROM app_store_apps
GROUP BY name;


--ALL APPs that appear in both with ALL DATA JOINED--
WITH app_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS app_rating,
								MAX(review_count) AS app_review_count,
								MAX(price::money) AS app_price,
								MAX(content_rating) AS app_content_rating,
								MAX(primary_genre) AS app_genres
					FROM app_store_apps
					GROUP BY name),
	play_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS play_rating,
								MAX(review_count) AS play_review_count,
								MAX(install_count) AS play_install_count,
								MAX(price::money) AS play_price,
								MAX(content_rating) AS play_content_rating,
								MAX(genres) As play_genres
					FROM play_store_apps
					GROUP BY name)
SELECT *
FROM play_sorted
		INNER JOIN app_sorted USING(name);
		

--RATINGS grouped by GENRE--
SELECT primary_genre,
		COUNT(rating) AS num_ratings,
		AVG(rating) AS avg_rating,
		ROUND(AVG(review_count::numeric),0) AS avg_reviews,
		ROUND(AVG(price),2) AS avg_price
FROM app_store_apps
GROUP BY primary_genre
ORDER BY avg_rating DESC;

SELECT genres,
		COUNT(rating) AS num_ratings,
		AVG(rating) AS avg_rating,
		ROUND(AVG(review_count),0) AS avg_reviews,
		ROUND(AVG(price::money::numeric),2) AS avg_price
FROM play_store_apps
GROUP BY genres
ORDER BY avg_rating DESC NULLS LAST;

--Cost / Duration / App_income
SELECT name,	
			CASE WHEN price > 2.50 THEN ROUND(price*10000, 0)
	  		ELSE 25000 END AS broker_cost,
		(rating * 2) + 1 AS app_duration_years,
		((rating * 2) + 1) * (1500*12) AS app_income,
		review_count
FROM app_store_apps
GROUP BY name, price, rating, review_count
ORDER BY name;

SELECT name,	
			CASE WHEN price::money::numeric > 2.50 THEN ROUND(price::money::numeric*10000, 0)
	  		ELSE 25000 END AS broker_cost,
		(rating * 2) + 1 AS app_duration_years,
		ROUND(((rating * 2) + 1) * (1500*12), 0) AS app_income,
		review_count
FROM play_store_apps
GROUP BY name, price, rating, review_count
ORDER BY name;


WITH app_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS app_rating,
								MAX(review_count) AS app_review_count,
								MAX(price::money) AS app_price,
								MAX(content_rating) AS app_content_rating,
								MAX(primary_genre) AS app_genres
					FROM app_store_apps
					GROUP BY name),
	play_sorted AS (SELECT DISTINCT name,
								MAX(rating) AS play_rating,
								MAX(review_count) AS play_review_count,
								MAX(install_count) AS play_install_count,
								MAX(price::money) AS play_price,
								MAX(content_rating) AS play_content_rating,
								MAX(genres) As play_genres
					FROM play_store_apps
					GROUP BY name)
SELECT name,
		CASE WHEN play_price::numeric > 2.50 THEN ROUND(play_price::numeric*10000, 0)
	  		ELSE 25000 END AS broker_cost_play,
		CASE WHEN app_price::numeric > 2.50 THEN ROUND(app_price::numeric*10000, 0)
	  		ELSE 25000 END AS broker_cost_app
FROM play_sorted
		INNER JOIN app_sorted USING(name);


		 


