
-- 5 most reviewed businesses
SELECT
        review_count,
        name
FROM
        businesses
ORDER BY
        review_count DESC
LIMIT 5;
 
 
 -- highest rating, how many businesses have it?
SELECT
	*
FROM 
	(SELECT
            rating,
            RANK() OVER(ORDER BY rating DESC) AS rating_rank,
            name
	FROM
            businesses) a
WHERE
	rating_rank = 1;
        
-- what percentage of buss have rating 4.5 or over
SELECT
       SUM(percent)
FROM (SELECT
					rating,
					COUNT(rating)/(SELECT
														COUNT(rating)
											 FROM
														businesses) *100 AS percent
			FROM 
						businesses
			WHERE rating >= 4.5
			GROUP BY
						rating
			ORDER BY
						rating DESC) a
    ;
    
-- percent of ratings less than 3
SELECT
       SUM(percent)
FROM (SELECT
					rating,
					COUNT(rating)/(SELECT
														COUNT(rating)
											 FROM
														businesses) *100 AS percent
			FROM 
						businesses
			WHERE rating < 3
			GROUP BY
						rating
			ORDER BY
						rating DESC) a
    ;
    
-- avg rating of restaurants with grouped by $$$$$$$'s

SELECT
	AVG(rating),
    price
FROM
	businesses
GROUP BY
	price
    ;
	
-- Return text for most reviewed rest

SELECT
	business_id,
    text
FROM
	reviews
WHERE 
	business_id  = (SELECT business_id 
							FROM businesses 
                            WHERE review_count = (SELECT MAX(review_count) FROM businesses))
;
    
    
    
-- return the name of the business with most recent review

SELECT
	business_id,
    name
FROM
	businesses
WHERE 
	business_id  = (SELECT business_id 
							FROM reviews 
                            WHERE time_created = (SELECT MAX(time_created) FROM reviews))
;
    

-- find highest rated business and return text of most recent review
-- IF multiple businesses have same rating, select the most recent text for the business with the most reviews

SELECT 
	*
FROM 
	(SELECT
		text,
        time_created
	 FROM
		reviews
	 WHERE
		business_id = (SELECT business_id
								FROM (SELECT * 
											 FROM businesses 
                                             WHERE rating = (SELECT MAX(rating) 
																		 FROM businesses)) max_rating
                                WHERE review_count = (SELECT MAX(review_count) 
																		 FROM businesses
																		 WHERE business_id IN (SELECT business_id 
																												FROM businesses
																												WHERE rating = (SELECT MAX(rating) 
																																			FROM businesses))))
     )  review_text
ORDER BY
     time_created DESC
LIMIT 1
;

-- find lowest rated business and return text of most recent review
-- IF multiple businesses have same rating, select the most recent text for the business with the leastr eviews

SELECT 
	*
FROM 
	(SELECT
		text,
        time_created
	 FROM
		reviews
	 WHERE
		business_id = (SELECT business_id
								FROM (SELECT * 
											 FROM businesses 
                                             WHERE rating = (SELECT MIN(rating) 
																		 FROM businesses)) min_rating
                                WHERE review_count = (SELECT MIN(review_count) 
																		 FROM businesses
																		 WHERE business_id IN (SELECT business_id 
																												FROM businesses
																												WHERE rating = (SELECT MIN(rating) 
																																			FROM businesses))))
     )  review_text
ORDER BY
     time_created DESC
LIMIT 1
;