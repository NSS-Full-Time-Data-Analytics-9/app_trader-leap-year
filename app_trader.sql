--ALL APPs that appear in both with ALL DATA JOINED--
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
	  								ELSE 25000 END AS play_broker_cost,
								MAX(category) AS category
					FROM play_store_apps
					GROUP BY name, price)
SELECT *
FROM play_sorted
		INNER JOIN app_sorted USING(name);


--PRICING--
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
		app_price,
		play_price
FROM play_sorted
		INNER JOIN app_sorted USING(name)
ORDER BY app_price DESC;
--80% of APPs are FREE 

--GENRE--
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
SELECT app_genres,
		COUNT(*) AS num_apps,
		ROUND(AVG(app_rating),2) As avg_rating,
		ROUND(AVG(app_price),2) AS avg_price
FROM play_sorted
		INNER JOIN app_sorted USING(name)
GROUP BY app_genres
ORDER BY num_apps DESC;
--GAMES most popular (174/328) - AVG(price) 


--CONTENT RATING--
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
		ROUND(AVG(play_rating),2) AS avg_rating,
		ROUND(AVG(play_price), 2) AS avg_price
FROM play_sorted
		INNER JOIN app_sorted USING(name)
GROUP BY play_content_rating
ORDER BY avg_rating DESC;
--'Everyone 10+' had highest AVG(rating) with losest AVG(price)-- 


--PROFITABILITY--
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
	  								ELSE 25000 END AS play_broker_cost,
								MAX(category) AS category

					FROM play_store_apps
					GROUP BY name, price)
SELECT name,
		(play_duration_years * (4500*12)) - play_broker_cost AS app_income,
		app_genres,
		play_content_rating,
		play_install_count,
		play_price,
		play_duration_years
FROM play_sorted
		INNER JOIN app_sorted USING(name)
ORDER BY app_income DESC;


