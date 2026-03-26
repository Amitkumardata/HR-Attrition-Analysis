use DB_Amit
--HR-Attrition Analysis:
--This is END-TO END my personal project started from row data into actionable insight  

--Cleaning part 
--find dupplication value
select * from hr_attr 

select age_group,
      department,
	  jobrole,
	  monthlyincome 
	  from hr_attr
group by age_group, department,jobrole,monthlyincome 
having count(*)>=1

create view remove_null as 
select * , row_number() over (partition by age_group, department,jobrole,monthlyincome order by monthlyincome) as rank_null
from hr_attr

delete from remove_null
where rank_null >1

drop view remove_null

select * from hr_attr 
-- Question: check the highest Attrition based on the age_group  
-- Insight: The age_group under 30 & bet 30-40 has highest attritions 91+87
--Recommandation: Focus on the age bet them why they are leaving 

select age_group,
       count(*) attr_cnt
        from hr_attr 
where attrition=1
group by age_group,attrition
order by attr_cnt desc

--Insight: Research & develplement Depart has the highest attrition 130 
--Suggestion: If most of the emp leaving in speciifc department that's means they feel pressure or poor management 
--Investigate this depart why attrition rate is high

select Department,
       count(*) as dept_cnt
       from hr_attr
where Attrition =1
group by Department ,Attrition
order by 2 desc 

--Insight : Travel_rarely has the highest attrition count ---
--Suggestion : 

select businesstravel ,
       count(*) attr_count,
       avg(monthlyincome) avg_sal
	   from HR_Attr
	  where businesstravel is not null
group by  businesstravel ,attrition
order by attrition,avg(monthlyincome) desc  


select jobsatisfaction,
      count(*) attr_count,
case 
when jobsatisfaction <=2 then 'emp_not_intrested'
when jobsatisfaction >=3 then 'Loyal_emp'
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

--Emp left 233

select attrition, count(*) from hr_attr
where attrition =1
group by attrition

--Avg number of emp

select 
(count(case when attrition = 1 then 1 end )*100) / count(*) as attr_rate
from hr_attr
group by attrition 




--COMPARE THE EMPLOYEE ATTRITION INTO ROW PART THEN ANALYSE THE ATTRITION BETWEEN YES/NO 
 
 select top 5 * from hr_attr 

 --INSight: emp who working more than 10 year thier attrition is less than compare to those emp who working less than 10 year
 --next step to find the reason : by compare from different cat why those leaving 
 --53 emp left who working more than 10 years

SELECT COUNT(*) AS ATTR_CNT
FROM HR_Attr
WHERE TOTALWORKINGYEARS <=10 and attrition =1
GROUP BY ATTRITION
order by ATTR_CNT desc
 

--Finding: Less than 10 years working and less than 3 years last training has max attrition count 
--INSIGHT : The Org Conduct the Less Training Since Last 3 Years for emp who working since 10 years less
--Recommand: Based on Emp working in year-at-company conduct the training and mov=tivate them for new upcoming project and
--future growth they can stable thier career  


SELECT  count(TOTALWORKINGYEARS),
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

-- Attrition by Job Role
-- increase the salary hike of the emp who working in Laboratory Technician role
select * from HR_Attr

SELECT JOBROLE,
       COUNT(*) attr_cnt,
       AVG(MONTHLYINCOME) avg_income
FROM HR_Attr
where attrition = 1
GROUP BY JOBROLE,TOTALWORKINGYEARS,attrition,percentsalaryhike
order by attr_cnt desc

--Finding: Attrition by gender emp count: male=147, female=86, 
--Insight : Max male are leaving the org compare to female under the age of 30-40  
--Recommand: create the new job opening and Hire specific male candidate for specific department who specilist to handle the task and responsiblity 

select gender,
       age_group,
	   count(*) attr_cnt
from HR_Attr
where attrition =1
group by gender ,attrition,age_group
order by attr_cnt desc

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
-- keep them satisfied who 

select JOBSATISFACTION,
	   count(*) attrition_leavers_cnt,
case when JOBSATISFACTION between 1 and 2 then 'low_satisfied' else 'fully_satisfied'
end as satifaction_status
	     
from HR_Attr
where Attrition=0
group by JOBSATISFACTION,
case when JOBSATISFACTION between 1 and 2 then 'low_satisfied' else 'fully_satisfied'
end as satifaction_status
order by attrition_leavers_cnt desc

select * from HR_Attr

--Finding : The percent_sal_hike in % bet 11-15 ,  Under the depart of Reasearch & Devlopment 
--Insight:  The attrition count range 60 is high emp who leaving under the low percent-sal-hike
--Recommand: Emp who perform good performance-wise increase thier salary hike under the specific department 

SELECT  department,
		count(*) attr_cnt,
		min(PERCENTSALARYHIKE)
FROM HR_Attr
where attrition =1
group by department,PERCENTSALARYHIKE,Attrition
order by attr_cnt desc    

--Leavers Finding: Performance-rating under 3-4 has 196+37 attrtion count who leaving the org
--Insight: Company are lossing Good perorming people that effect on productivity may client not impress by current result  
--Suggestion: Retain the prevous emp who has good record in term of good rating permarance-wise high productvity , 
--offer good hike compare to previous CTC  


select performancerating,
       count(*) attr_cnt,
case 
when attrition =1 then 'leavers '
when attrition =0 then 'stayers'
end as attrition_status 
from HR_Attr
where attrition =1 
group by performancerating,attrition
order by attr_cnt desc

--Stayers Insight: performance under 3 has 1032 who currently working  
-- Keep maintain thier performce rating record-wise and give the chance to apply the enternal job opening

select performancerating, count(*) emp_cnt,
case 
when attrition =1 then 'leavers '
when attrition =0 then 'stayers'
end as attrition_status 
from HR_Attr
where attrition =0
group by performancerating,attrition

--Finding: Honeymoon period time bet 0-7 years the attrition count is increased by  85 + 49 + 30 = 164
--Insight: Emp are leaving due to Emp or manager both are not alligned or built trust poor manager Behavior
--Recommand:Improve the interview process reassigned the managers and switch from one to anothers process based on expericence-wise,productivity


select YearsWithCurrManager,
       count(*) attr_cnt
      from HR_Attr
where Attrition= 1
group by YearsWithCurrManager,Attrition
order by attr_cnt desc


select * from  HR_Attr

--Finding: Tenure-group bet 2-5 year has high attrition RANGE 51 +21 +12  
--INSIGHT: With low promotion since the year range bet 0-2 years and year-at-company who has working since 0-2 years 
--Recommand: FOCUS on emp who working under below <3 year , Go thorugh thier performance and productivity provide the promotion,
--and swift the others roles from current roles they feel career stable and growth in order to promption and skills growth 

select 
      tenure_group,
	  count(*) attr_cnt,
      YearsInCurrentRole,
      YearsSinceLastPromotion
from HR_Attr
where attrition =1
group by tenure_group,YearsInCurrentRole,
YearsSinceLastPromotion
order by attr_cnt desc

select * from HR_Attr

--Work-life-balance bet 2-3 and years-at-company bet ranges 1-2-3-5 has the highest attrition range (31-14)
--Insight: emp are not stable and within an year they are leaving the org
--Recommand: Focus on interview process improve the hiring management and hire some good amount of experience candidate who has 
--god experince and worked in previous companny atleast for 4 to 5 year it shows that candidate has good stablity and working hard 

select top 5 count(*) att_cnt,
         worklifebalance,yearsatcompany 
         from HR_Attr
where Attrition=1
group by Attrition,worklifebalance,yearsatcompany 
order by att_cnt desc

  

--within yearsatcompany emp leaved look for long-term employee 
--someone who tenured in their previous compnay so that they can stay for long term 


select top 5 * from HR_Attr

select top 5 
        department,
		count(*) attr_cnt,
		
    case 
    when YearsAtCompany <=3 then 'emp_aksing_for_promotion'
    when YearsAtCompany >=4 then 'Emp_feeling_frustrate'
end as Emp_working_years_status
from HR_Attr
where attrition = 1
group by department,YearsAtCompany
order by attr_cnt desc

-- Attrition by OverTime

select overTime,
       count(*)
	   from HR_Attr	
	   where overtime is not null and  attrition =1
	   	   group by overTime,attrition

 
   
