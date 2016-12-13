LOAD DATA INFILE "/home/vgk7/Downloads/abg-employees.txt"
INTO TABLE abgemployees
COLUMNS TERMINATED BY '\t'
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n';



SELECT
    CASE
        WHEN age < 35 THEN 'Under 35'
        WHEN age BETWEEN 35 and 46 THEN '35 - 46'
        WHEN age >= 46 THEN 'Over 46'
    END as agerange,
    count(lastLoginTime) unique_logins,
    ae.company
from users u, abgemployees ae
where u.email=ae.email
and u.source='adityabirla'
group by agerange, ae.company;

+----------+---------------+----------+
| agerange | unique_logins | company  |
+----------+---------------+----------+
| 35 - 46  |            16 | ABMCPL   |
| 35 - 46  |            38 | Hindalco |
| Over 46  |             8 | ABMCPL   |
| Over 46  |            17 | Hindalco |
| Under 35 |            36 | ABMCPL   |
| Under 35 |            72 | Hindalco |
+----------+---------------+----------+


SELECT
    functionalunit as 'function',
    count(lastLoginTime) unique_logins,
    ae.company
from users u, abgemployees ae
where u.email=ae.email
and u.source='adityabirla'
group by function, ae.company;


    sum(if content like '%used AskaSpecialist Service%',1,0) relogins,
    sum(if content like '%used AskaDoctor Service %',1,0) relogins,

SELECT
    jobband,
    sum(if(content like '%logged in at %',1,0)) as relogins,
    ae.company
from users u, abgemployees ae, useractivity ua
where u.email=ae.email
and ua.userid=u.user_id
and u.source='adityabirla'
group by jobband, ae.company;

SELECT
    CASE
        WHEN ae.age < 35 THEN 'Under 35'
        WHEN ae.age BETWEEN 35 and 46 THEN '35 - 46'
        WHEN ae.age >= 46 THEN 'Over 46'
    END as agerange,
    sum(if(specialistquery=1,1,0)) as AASQueries,
    sum(if(specialistquery=0,1,0)) as AADQueries,
    ae.company
from abgemployees ae, askdoctorquerydetail aq, users u 
where  aq.askedBy = u.user_id
and u.email=ae.email
and u.source='adityabirla'
group by agerange, ae.company;


SELECT
    ae.jobband,
    count(*) as Babymagic,
    ae.company
from abgemployees ae, BabyMagicSubscriptionDetails b, users u 
where  b.userid = u.user_id
and u.email=ae.email
and u.source='adityabirla'
group by jobband, ae.company;



SELECT
    CASE
        WHEN ae.age < 35 THEN 'Under 35'
        WHEN ae.age BETWEEN 35 and 46 THEN '35 - 46'
        WHEN ae.age >= 46 THEN 'Over 46'
    END as agerange,
    count(*) as Babymagic,
    ae.company
from abgemployees ae, BabyMagicSubscriptionDetails b, users u 
where  b.userid = u.user_id
and u.email=ae.email
and u.source='adityabirla'
group by agerange, ae.company;


SELECT
    CASE
        WHEN ae.age < 35 THEN 'Under 35'
        WHEN ae.age BETWEEN 35 and 46 THEN '35 - 46'
        WHEN ae.age >= 46 THEN 'Over 46'
    END as agerange,
    count(*) as dietchartrequests,
    ae.company
from abgemployees ae, dietchartrequest d, users u 
where  d.requestedBy = u.user_id
and u.email=ae.email
and u.source='adityabirla'
group by agerange, ae.company;


select distinct u.email email ,u.user_name username,ae.age, ae.gender, jobband, functionalunit as function, company, u.mobile mobile,s.creationTime creationTime from abgemployees ae, services s inner join users u on s.userId = u.user_id where s.servicetype = 'DoctorAppointment' and u.source ='adityabirla' and ae.email=u.email;



select u.email,u.user_name name,ae.age, ae.gender, jobband, functionalunit as function, company from abgemployees ae, chat c inner join users u on c.patient = u.user_id where u.source ='adityabirla' and ae.email=u.email;


select  u.email email ,u.user_name username ,ae.age, ae.gender, jobband, functionalunit as function, company from abgemployees ae, services dc inner join users u on dc.userId = u.user_id and dc.serviceType='DietChartRequest' where u.source='adityabirla'  and ae.email=u.email;


select u.email email ,u.user_name username,ae.age, ae.gender, jobband, functionalunit as function, company, u.mobile mobile,s.creationTime creationTime from abgemployees ae, services s inner join users u on s.userId = u.user_id where s.servicetype in ('DoctorAppointment','CounselorCallRequest','DoctorCallRequest') and u.source ='adityabirla' and ae.email=u.email;

select email, created_time, lastlogintime,accepteddate from users u left outer join abgtnc a on u.user_id=a.userid  where source='adityabirla';






