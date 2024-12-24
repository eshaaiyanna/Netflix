Drop table IF exists netflix;
create table netflix (show_id varchar (6),
type varchar (10),title varchar (150),
	director varchar (208),
	casts varchar (1000),
	country varchar (150),
	date_added varchar (50),
	release_year INT,
	rating varchar (10),
	duration varchar (15),
	listed_in varchar (79),
	description varchar(250)
);




-- 1) Count the number of movies vs Tvshows

select type ,count(*) from netflix
group by 1;


-- 2) Find the most common rating for movies and tv shows.
select * from netflix;

with cte as (select type,rating ,count(*),rank() over(partition by type order by count(*) desc) as rn from netflix
	group by 1,2
	order by count(*) desc)
	select * from cte 
	where rn = 1;

-- 3) List all the movies in 2020

select title from netflix
where release_year = 2020 and type = 'Movie';

-- 4) Find the top 5 contries with most content 

select  unnest(STRING_TO_ARRAY(country,',')) as new_country,count(*)
from netflix
group by 1
order by 2 desc
limit 5;

-- 5) Find the longest movie?


SELECT title,
cast(SPLIT_PART(duration, ' ', 1)as int) AS duration_value
from netflix
where type = 'Movie'
order by duration_value desc;

-- 6)Find the content added in the last five years

SELECT *
FROM netflix
WHERE TO_DATE(date_added,'Month DD,YYY')  >= current_date - interval '5 years'


-- SELECT *
-- FROM netflix
-- WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;

-- 7) List TV shows with more than 5 seasons

select * from netflix 
where cast(split_part(duration,' ',1) as int) > 5
and type = 'TV Show'

-- 8)Count number on content in each genre
 

select count(*) ,unnest(string_to_array(listed_in,',')) as genre from netflix
group by 2;


-- 9)
select Extract(Year from TO_DATE(date_added,'Month DD ,YYY')) as dates,count(*),round(count(*)::numeric/972 *100,2) as avgg from netflix
where country = 'India'
group by 1
	order by avgg desc;

--10)List all movies that are documentaries

select listed_in,title from netflix 
where listed_in ilike '%Documentaries%';

-- 11)Select movies of ryan reynolds in he last ten yrs

with cte as(select title,casts,extract(year from to_date(date_added,'Month DD,YYY'))as yr from netflix
where type = 'Movie' and casts like '%Ryan Reynolds%')
select * from cte 
where yr >= extract(year from current_date) - 10;


-- 12)Find top 10 actors who appaered in the highest number of films?

select unnest(STRING_TO_ARRAY(casts,',')) as actors,count(*) from netflix
	where country = 'India'
	group by 1
	order by 2 desc
	limit 10;

-- 13) Categorize the movies with terms like kill and bad as bad content and rest as good content and count the category for each label.

select 
case when description ilike '%kill%' or description ILIKe '%violence%' then 'BAD CONTENT'
else 'GOOD CONTENT'
end as Labels,count(*) from netflix
	group by 1;
	






