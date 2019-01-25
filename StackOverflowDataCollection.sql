
/* This file contains codes for a research paper coauthored with Professor Ramesh Shankar and Professor Jan Stallaert */
--Sample selection 
select id from users where reputation between 10000 and 100000
and creationdate 
between '2010-06-01 00:00:00' and '2010-12-31 23:59:59'
and LastAccessDate>'2013-01-01 00:00:00'

-- Variables (for a certain user during one week)
-- Number of Answers received:
select year(a.creationdate) years, datepart (week,a.creationdate) weeks,
count(a.id) [answers received], q.owneruserid
from posts a join posts q on a.parentid = q.id 
where a.posttypeid=2 and q.owneruserid in
(select id from users where reputation between 10000 and 100000
and creationdate between '2010-06-01 00:00:00' and '2010-12-31 23:59:59'
and LastAccessDate>'2013-01-01 00:00:00')
and a.parentid in (select id from posts where posttypeid =1
and owneruserid in (select id from users where reputation between 10000 and 100000
and creationdate between '2010-06-01 00:00:00' and '2010-12-31 23:59:59'
and LastAccessDate>'2013-01-01 00:00:00'))
and year(a.creationdate) between 2011 and 2012
group by year (a.creationdate), datepart(week, a.creationdate), q.owneruserid
order by owneruserid, year(a.creationdate), datepart(week, a.creationdate)


-- Answers given:
select count(id) [answers given], year(creationdate) years, datepart (week,creationdate) weeks, owneruserid from posts 
where postTypeId=2 and owneruserid in 
(select id from users where reputation between 10000 and 100000
and creationdate between '2010-06-01 00:00:00' and '2010-12-31 23:59:59'
and LastAccessDate>'2013-01-01 00:00:00') and
year(creationdate) between 2011 and 2012 group by year(creationdate), 
datepart (week,creationdate), owneruserid

-- Questions given:
select count(id) que_given, year(creationdate) years,owneruserid, month(creationdate) months,day(creationdate) days from posts where postTypeId=1 and owneruserid in (select id from users where reputation between 100000 and 150000) and year(creationdate) between 2011 and 2012 group by year(creationdate), month(creationdate),day(creationdate),owneruserid


-- Scores Received
select year(a.creationdate) years, datepart(week,a.creationdate) weeks,
sum(a.score) [score received], q.owneruserid
 from posts a join posts q on a.parentid = q.id
 where a.posttypeid=2 and a.parentid in
(select id from posts where posttypeid =1
and owneruserid in (select id from users where reputation between 10000 and 100000
and creationdate 
between '2010-06-01 00:00:00' and '2010-12-31 23:59:59'
and LastAccessDate>'2013-01-01 00:00:00'))
and year(a.creationdate) between 2011 and 2012
group by year(a.creationdate), datepart(week,a.creationdate), q.owneruserid
order by owneruserid,year(a.creationdate), datepart(week,a.creationdate)


-- Answer’s Comments received:

select count(comments.id) [answers comments received],year(comments.creationdate) years, datepart(week,comments.creationdate) weeks, posts.owneruserid 
from comments inner join posts on comments.postid=posts.id 
where postid in
(select posts.id from posts where posttypeid=2 and owneruserid in 
(select id from users where reputation between 10000 and 100000 and creationdate 
between '2010-06-01 00:00:00' and '2010-12-31 23:59:59'
and LastAccessDate>'2013-01-01 00:00:00')) 
and year(comments.creationdate) between 2011 and 2012 
group by posts.owneruserid, year(comments.creationdate),
datepart(week, comments.creationdate)

-- Question’s Comments received:

select count(comments.id) [question comments received],year(comments.creationdate) years, datepart(week,comments.creationdate) weeks, posts.owneruserid 
from comments inner join posts on comments.postid=posts.id 
where postid in
(select id from posts where posttypeid=1 and owneruserid in 
(select id from users where reputation between 10000 and 100000 and creationdate 
between '2010-06-01 00:00:00' and '2010-12-31 23:59:59'
and LastAccessDate>'2013-01-01 00:00:00')) 
and year(comments.creationdate) between 2011 and 2012 
group by posts.owneruserid,year(comments.creationdate),
datepart(week,comments.creationdate)

/* Answers’ upvotes received:
Questions’ upvotes received:
Answers’ upvotes received:
Questions’ upvotes received:
question upvotes received */
select year(votes.creationdate) years, datepart(week,votes.creationdate) weeks, count(votes.id) que_upv_rec, posts.owneruserid 
from votes inner join posts on votes.postid=posts.id
where votetypeid=2 and postid in(select id from posts where
posttypeid=1 and owneruserid in (select Id from users
where reputation between 100000 and 150000)) and 
year(votes.creationdate) between 2011 and 2012
group by year(votes.creationdate),month(votes.creationdate),
day(votes.creationdate),posts.owneruserid


-- join date
select id, year(creationdate) years, datepart(week, creationdate) weeks 
from users 
where reputation between 10000 and 100000 and creationdate 
between '2010-06-01 00:00:00' and '2010-12-31 23:59:59'
and LastAccessDate>'2013-01-01 00:00:00'

-- Gold Medals 
select count(id) golds, year(date) years,datepart(week, date) weeks, userid
from badges where class=1 and userid in 
(select id from users where reputation between 10000 and 100000 and creationdate 
between '2010-06-01 00:00:00' and '2010-12-31 23:59:59'
and LastAccessDate>'2013-01-01 00:00:00') 
and year(date) between 2011 and 2012
group by year(date), datepart(week, date),userid

/* B Rules from StackOverflow 
You get reputation when:
•	question is voted up: +5
•	answer is voted up: +10
•	answer is marked “accepted”: +15 (+2 to acceptor)
•	suggested edit is accepted: +2 (up to +1000 total per user)
•	bounty awarded to your answer: + full bounty amount
•	one of your answers is awarded a bounty automatically: + half of the bounty amount (see more details about how bounties work)
•	site association bonus: +100 on each site (awarded a maximum of one time per site)
If you are an experienced Stack Exchange network user with 200 or more reputation on at least one site, you will receive a starting +100 reputation bonus to get you past basic new user restrictions. This will happen automatically on all current Stack Exchange sites where you have an account, and on any other Stack Exchange sites at the time you log in.
You lose reputation when:
•	your question is voted down: −2
•	your answer is voted down: −2
•	you vote down an answer: −1
•	you place a bounty on a question: − full bounty amount
•	one of your posts receives 6 spam or offensive flags: −100 */

