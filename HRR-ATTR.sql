use DB_Amit

 

 
 
--Cleaning part 
--find dupplication value
select * from hr_attr 

select age_group, department,jobrole,monthlyincome from hr_attr
group by age_group, department,jobrole,monthlyincome 
having count(*)>=1

create view remove_null as 
select * , row_number() over (partition by age_group, department,jobrole,monthlyincome order by monthlyincome) as rank_null
from hr_attr

delete from remove_null
where rank_null >1

drop view remove_null

select * from hr_attr 
-- Finding: The age_group below 30 has highest Attrition =91 
-- Insight: The age_group under 30 & bet 30-40 attrition91+87
--Recommandation: Focus on the age bet them why they are leaving 

select age_group, count(*) attr_cnt
from hr_attr 
where attrition=1
group by age_group,attrition
order by attr_cnt desc

--Insight: Research & develplement Depart has the highest attrition 130 
--Suggestion: If most of the emp leaving in speciifc department that's means they feel pressure or poor management investigate those
--depart where attrition rate is high

select Department,count(*) as dept_cnt
from hr_attr
where Attrition =1
group by Department ,Attrition
order by 2 desc 

--Insight : Travel_rarely has the highest attrition count ---
--Suggestion : 

select businesstravel , count(*) attr_count,
     avg(monthlyincome) avg_sal
	 from HR_Attr
	 where businesstravel is not null
group by  businesstravel ,attrition
order by attrition,avg(monthlyincome) desc  


select jobsatisfaction, count(*) attr_count,
case 
when jobsatisfaction <=2 then 'emp_not_intrested'
when jobsatisfaction >=3 then 'emp_intrested'
end as reason_for_leaving
from hr_attr
where attrition = 1  
group by attrition ,jobsatisfaction
order by attr_count desc   
 
--current emnployye

select attrition, count(*) from hr_attr
where attrition =0
group by attrition 

  

select top 10 avg(EmployeeNumber),
      max(TrainingTimesLastYear),
       performancerating,
	   count(YearsSinceLastPromotion),
	   percentsalaryhike
	   from hr_attr
where attrition =1
group by  
	    performancerating,
	   YearsSinceLastPromotion,
	   percentsalaryhike
order by 5 desc

--overall emp attrition rate
--current emp -1218

select attrition, count(*) from hr_attr
where attrition =0
group by attrition

--emp left 233
select attrition, count(*) from hr_attr
where attrition =1
group by attrition 

--COMPARE THE EMPLOYEE ATTRITION INTO TOW PART THEN ANALYSE THE ATTRITION BETWEEN YES/NO 
 
 select top 5 * from hr_attr 

 --INSight: emp who working more than 10 year thier attrition is less than compare to those emp who working less than 10 year
 --next step to find the reason : by compare from different cat why those leaving 
 --53 emp left who aorking more than 10 years

SELECT COUNT(*) AS ATTR_CNT
FROM HR_Attr
WHERE TOTALWORKINGYEARS <=10 and attrition =1
GROUP BY ATTRITION
order by ATTR_CNT desc
 

--Finding: Less than 10 years working and less than 3 years last training has max attrition count 
--INSIGHT : The Org Conduct the Less Training Since Last 3 Years for emp who working since 10 years less
--Recommand: Based on Emp working in year-at-company conduct the training and mov=tivate them for new upcoming project and
--future growth they can stable thier career  


SELECT TOP 5 TOTALWORKINGYEARS,
         TrainingTimesLastYear,
		 COUNT(*) AS ATTR_CNT 
FROM HR_Attr
WHERE  TOTALWORKINGYEARS<10 and TrainingTimesLastYear <=3 and attrition =1
GROUP BY TOTALWORKINGYEARS,ATTRITION,TrainingTimesLastYear
ORDER BY ATTR_CNT DESC

--Finding: Since-last-promotion in within 3 years attrition count 36+38+58
--Insight:Job-satisfied range almost all 1-2-3-4 they are like less intrest to stay and work
--Suggest: Create the new job opening for internal hiring and focus on emp who has less promotion they are eligible for apply,
--and give them thier first priotise

SELECT JOBSATISFACTION,COUNT(*) ATT_CNT
   FROM HR_Attr
   WHERE  YearsSinceLastPromotion <=3 and ATTRITION =1
   GROUP BY JOBSATISFACTION
ORDER BY ATT_CNT 

SELECT JOBROLE,COUNT(*),
AVG(MONTHLYINCOME)
FROM HR_Attr
GROUP BY JOBROLE,TOTALWORKINGYEARS

--Finding: Attrition by gender emp count: male=147, female=86, 
--Insight : Max male are leaving the org compare to female  
--Recommand: Hire specific male candidate for specific department who specilist to handle the task and responsiblity 

select gender,
       attrition,
	   count(*)
from HR_Attr
where attrition =1
group by gender ,attrition

--Stayers
--Insight : Male count has the high emp 724 who currently working 
--Recommand: Focus on female candidate to increase the number hire female specilsit 

select gender,
       attrition,
	   count(*)
from HR_Attr
where attrition =0
group by gender ,attrition


--Finding: Job-satisfaction range bet 3-1-4 The total emp  71+65+52 who are leaving the org
--Insight : They are not satified with thier current job role 
--Recommand: Conduct the training or workshop and create survey of emp satisfaction ask about thier overall experience like
--management,policy,jobrole,department,managers then look out thier satisfaction who convience for the emp implement them0000000000000000.000000

select JOBSATISFACTION,
	   count(*) attritio_cnt
from HR_Attr
where Attrition=1
group by JOBSATISFACTION,attrition
order by attritio_cnt desc

----stayers Insight : 399 emp most satisfied with the job who currently working

select JOBSATISFACTION,
	   count(*) attrition_leavers_cnt
from HR_Attr
where Attrition=0
group by JOBSATISFACTION,attrition
order by attrition_leavers_cnt desc

select * from HR_Attr

--Finding : The percent_sal_hike in % bet 11-12-13-14-15 ,  Under the depart of Reasearch & Devlopment 
--Insight:  The attrition count MAX 39+ 34 + 32+ 24 +18 is high emp who leaving under the low percent-sal-hike
--Recommand: Emp who has good rating performance -wise increase thier the hike under the specific department 

SELECT  department,count(department),PERCENTSALARYHIKE,count(*) attr_cnt
FROM HR_Attr
where attrition =1
group by department,PERCENTSALARYHIKE,Attrition
order by attr_cnt desc 

--Leavers Finding: Performance-rating under 3-4 has 196+37 attrtion count who leaving the org
--Insight: Company are lossing Good people that effect on productivity may client not impress by current result  
--Suggestion: Retain the prevous emp who has good record in term of good rating permarance-wise high productvity , 
--offer god hike compare to previous CTC  


select performancerating, count(*) attr_cnt,
case 
when attrition =1 then 'leavers '
when attrition =0 then 'stayers'
end as attrition_status 
from HR_Attr
where attrition =1
group by performancerating,attrition
order by attr_cnt desc

--Stayers Insight: performance under 3 has 1032 who currently working  

select performancerating, count(*) emp_cnt,
case 
when attrition =1 then 'leavers '
when attrition =0 then 'stayers'
end as attrition_status 
from HR_Attr
where attrition =0
group by performancerating,attrition

--Finding: Honeymoon period time bet 0-2-7 years the attrition count is highest with 85+49+30 
--Insight: emp are leaving due to Emp or manager both are not alligned or built trust poor manager Behavior
--Recommand:Improve the interview process reassigned the managers and switch from one to anothers based on behavior-wise,productivity


select YearsWithCurrManager, count(*) attr_cnt
from HR_Attr
where Attrition= 1
group by YearsWithCurrManager,Attrition
order by attr_cnt desc


select * from  HR_Attr

--Finding: Tenure-group bet 2-5 year has MAX attrition RANGE 51+21+12  
--INSIGHT: With low promotion since the year range bet 0-2 years and year-at-company who has working since 0-2 years 
--Recommand: FOCUS on emp who working under below <3 year , Go thorugh thier performance and productivity provide the promotion,
--and swift the others roles from current roles they feel career stable and growth in order to promption and skills growth 

select 
tenure_group ,count(*) attr_cnt,
YearsInCurrentRole,
YearsSinceLastPromotion
from HR_Attr
where attrition =1
group by tenure_group,YearsInCurrentRole,
YearsSinceLastPromotion
order by attr_cnt desc

select * from HR_Attr

-- work-life-balance bet 2-3 and years-at-company bet ranges 1-2-3-5 has the highest attrition range (31-14)
--Insight: emp are not stable and within an year they are leaving the org
--Recommand: Focus on interview process improve the hiring management and hire some good amount of experience candidate who has 
--god experince and worked in previous companny atleast for 4 to 5 year it shows that candidate has good stablity and working hard 

select top 5 count(*) att_cnt,
worklifebalance,yearsatcompany 
from HR_Attr
where Attrition=1
group by Attrition,worklifebalance,yearsatcompany 
order by att_cnt desc





--product: id, pname, cat, price, stockqnty
--sales: id, sdate, pid, qntysold, tolamount

--Summary table 

select top 5 * from HR_Attr

select department,count(*) attr_cnt,
case 
when yearsincurrentrole <=3 then 'emp_aksing_for_promotion'
when yearsincurrentrole >=4 then 'Emp_feeling_frustrate'
end as emp_mindset_status
from HR_Attr
where attrition = 1
group by department,yearsincurrentrole
order by  attr_cnt desc


select top 5 department,count(*) attr_cnt,
case 
when YearsAtCompany <=3 then 'emp_aksing_for_promotion'
when YearsAtCompany >=4 then 'Emp_feeling_frustrate'
end as emp_mindset_status
from HR_Attr
where attrition = 1
group by department,YearsAtCompany
order by attr_cnt desc
