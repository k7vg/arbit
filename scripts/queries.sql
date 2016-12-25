--Update published chats
update chat c, chatconversationcontent ccc set c.publishedContentId = ccc.id where ccc.chatId = c.chat_id and c.publishedContentId is null;

--Unpublished chats
select count(*) from chat c, chatconversationcontent ccc where ccc.chatId = c.chat_id and c.publishedContentId is null;

--Unpublished Premium Questions
select count(*) from  askdoctorquerydetail where (publishedQuestionId is null or publishedQuestionId ='')  and (status=4 or status=6)  and  date(lastUpdatedOn) < date(subdate(now(),15));

--Doctor list
select d.name, d.cityname, d.countryname, d.speciality from doctors d, users u where d.userid=u.user_id"

--Query related
mysql -h charm -udbadmin -pdbAdmin2009 hcm -e "select specialistquery, count(distinct askedby) from askdoctorquerydetail where askedon >= '20150101' group by specialistquery"

mysql -h charm -udbadmin -pdbAdmin2009 hcm -e "select count(distinct createdby) from mobilequestions where creationtime >= '20150101'"

mysql -h charm -udbadmin -pdbAdmin2009 hcm -e "select count(distinct userId) from userquery where createdOn >= '20150101'"

mysql -h charm -udbadmin -pdbAdmin2009 hcm -e "select count(*) from users where doctorprofileid is not null and lastLoginTime BETWEEN DATE( DATE_SUB( NOW() , INTERVAL 1 DAY ) )
    AND DATE ( NOW() )"

mysql -h charm -udbadmin -pdbAdmin2009 hcm -e "select date(p.paymenttime),p.currencycode, count(1) cnt, sum(p.paymentAmount) totalAmount
from ProductPayment p inner join users u on p.userId=u.user_id inner join UserProduct up on p.gatewaySubscriptionId=up.gatewaySubscriptionId where p.currencycode is not null and p.refunded=0 and p.gatewaySubscriptionId is not null and paymentStatus='SUCCESS' group by date(p.paymenttime), p.currencycode having min(p.paymentTime)>= '20150101' and min(p.paymentTime) <= '20150731' order by min(p.PaymentTime) desc";


select date(orderTime), (count(*)-count(parentPaymentId)) New from ProductPayment pp where orderTime>='20150101' and orderTime<='20150731' and paymentStatus in ('SUCCESS','AWAITING') and currencycode='USD' group by 1 order by 1 desc;


--mysql backup 
mysqldump -h charm -u dbadmin -pdbAdmin2009 --single-transaction --max_allowed_packet=1G hcm > /home/rxhealthcaremagic/hcm_DDMONYYYY.sql

--List table sizes
SELECT 
     table_schema as `Database`, 
     table_name AS `Table`, 
     round(((data_length + index_length) / 1024 / 1024), 2) `Size in MB` 
FROM information_schema.TABLES 
ORDER BY (data_length + index_length) DESC;


--Payment Reports
mysql -h charm -u dbadmin -pdbAdmin2009 hcm -e "select date(p.paymenttime),hbp.productname, p.currencycode, p.paymentAmount totalAmount from ProductPayment p left outer join HCMBaseProduct hbp on p.productId=hbp.productId where p.refunded=0 and paymentStatus='SUCCESS' and p.paymentTime>= '20160101' and p.paymentTime < '20160401' and p.sempayment=1;" > sempaymentreport.csv

mysql -h charm -u dbadmin -pdbAdmin2009 hcm -e "select date(p.paymenttime),hbp.productname, p.currencycode, p.paymentAmount totalAmount from ProductPayment p left outer join HCMBaseProduct hbp on p.productId=hbp.productId where p.refunded=0 and paymentStatus='SUCCESS' and p.paymentTime>= '20160101' and p.paymentTime < '20160401' and p.sempayment!=1;" > seopaymentreport.csv

--all payments
select orderTime Time
,user_id UserId
,hbp.productName
, case when (currencyCode = '036') then concat('AUD ',paymentAmount) when (currencyCode = '840') then concat('USD ',paymentAmount) when (currencyCode = '826') then concat('GBP ',paymentAmount) when (currencyCode = '978') then concat('EUR ',paymentAmount) when (currencyCode = '356') then concat('INR ',paymentAmount) when (currencyCode is null) then concat('INR ',paymentAmount) else concat (currencyCode,' ',paymentAmount) end as Amount ,gateway Gateway, case  when (pp.SEMPayment = 1) then 'SEM'  else 'SEO' end as productType
,  (select count(*) as cc 
from ProductPayment pp2 
where pp.productId=pp2.productId 
and pp2.userId=pp.userId 
and pp2.gatewaySubscriptionId=pp.gatewaySubscriptionId 
and pp2.paymentStatus='SUCCESS') countOfPmnt 
from ProductPayment pp, users, HCMBaseProduct hbp 
where pp.productId=hbp.productId 
and paymentStatus ='SUCCESS' 
and userId=user_id 
and email not like '%@hcm%' 
and email not like '%healthcaremagic%' 
and orderTime>'20151231' 
and pp.paymentId not in (select distinct paymentid from refunds where reason = 'Multiple Payments') order by orderTime desc;

--monthwise seo payments
select year(orderTime) year, month(ordertime) month,count(*) Count,count(parentPaymentId) Repeated,(count(*)-count(parentPaymentId)) New from ProductPayment pp where SEMPayment=0 and orderTime >= '20140401' and paymentStatus in ('SUCCESS','AWAITING') and gateway not in ('Apple Store','Google Checkout') and paymentId not in (select distinct paymentid from refunds where reason = 'Multiple Payments' and date(refundtime)='20150507') group by year, month order by year, month;

-- Users who have completed the HRA

select distinct u.email from users u, userhealthrisk uhr where u.user_id=uhr.userid and uhr.completed in (1,2) and email in ();

select name, u.email, d.mobile, d.office_phone, d.address from doctors d left outer join users u on d.userid=u.user_id, location l where speciality in ('Radiologist','Radiologist, Interventional','Radiologist, Nuclear Medicine') and d.location=l.id and (u.email is not null or d.mobile is not null or d.office_phone is not null) and d.address like '%bangalore%';

select name, u.email, speciality, l.area, d.countryname, d.creationtime from doctors d, users u , location l where  d.userid=u.user_id and d.location=l.id;

--temp
select count(*) from doctorpaymenttransaction where currency is null and entityParam='PUBLIC_QUESTION';
update doctorpaymenttransaction set amount=amount*50, currency='INR' where currency is null and entityParam='PUBLIC_QUESTION';


--seo report
select orderTime Time
, case when (currencyCode = '036') then 'AUD ' when (currencyCode = '840') then 'USD ' when (currencyCode = '826') then 'GBP ' when (currencyCode = '978') then 'EUR ' when (currencyCode = '356') then 'INR ' when (currencyCode is null) then 'INR ' else currencyCode end as Currency
,paymentAmount amount,
case when parentpaymentid is null then 'new' else 'repeat' end as type
from ProductPayment pp
where SEMPayment=0 
and orderTime >= '20160401' 
and orderTime < '20160618'
and paymentStatus in ('SUCCESS','AWAITING') 
and gateway not in ('Apple Store','Google Checkout');

--upload attachments
insert into userdocuments values (null, 9028568,'IMG_2518.JPG',null, null, now(), now(), 1);

--middle east
select lastAccessedIp, country, age, gender, triedADoctor, community , c2.message
from (
select u.lastAccessedIp, country, age, gender, triedADoctor, coalesce(updatedCommunityName, communityname, 'General Health') community, min(c.id) as convid
from users u, askdoctorquerydetail q, askdoctorconversation c
where u.user_id=q.askedby 
and q.id=c.askdoctorqueryId
and u.country in ('Bahrain','Cyprus','Egypt','Iran','Iraq','Israel','Jordan','Kuwait','Lebanon','Oman','Palestine','Qatar','Saudi Arabia','Syria','Turkey','United Arab Emirates','Yemen','Iran')
and date(q.askedon)>='20160701' group by q.id) t, askdoctorconversation c2
where t.convid=c2.id;


