.open track_metadata.db
.headers on
.mode csv
.output question_1.csv

select * from songs
where artist_name = "Guided By Voices"

LIMIT 20;

.output question_2.csv

select title, release, year from songs
where artist_name="Guided By Voices"
order by release, year

LIMIT 20; 

.output question_3.csv

select artist_name, sum(1) as count from songs
group by artist_name


LIMIT 20; 

.output question_4.csv

create table songs_per_year as
select year, sum(year) as sum_yr from songs
where year >= 1900
order by year

LIMIT 20; 

.output question_5.csv

create table albums_per_year as
select year, distinct count(release) as release_count from track_metadata.db
where year >=1900
group by year
order by year

LIMIT 20; 

.output question_6.csv

create table q6 as
select * from songs_per_year s
inner join albums_per_year a
on s.year=a.year

LIMIT 20; 


