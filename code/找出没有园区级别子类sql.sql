
select t7.account,t7.deminsion_level, t7.deminsion_value,t7.deminsion_code  ,t7.parent_code
,case when sum(t8.nums)>0   then sum(t8.nums) when t7.deminsion_level ='区域' then 1 else 0 end  as  nums
FROM
	(SELECT *, CASE when deminsion_level ='区域' then 1 else 0 end  as nums from user_deminsion_t) t7 
LEFT JOIN
(
	select t5.account,t5.deminsion_level, t5.deminsion_value,t5.deminsion_code  ,t5.parent_code
	,case when sum(t6.nums)>0   then sum(t6.nums) when t5.deminsion_level ='区域' then 1 else 0 end  as  nums
	from 
	 (SELECT *, CASE when deminsion_level ='区域' then 1 else 0 end  as nums from user_deminsion_t) t5 
	LEFT JOIN
		(select t3.account,t3.deminsion_level, t3.deminsion_value,t3.deminsion_code  ,t3.parent_code,case when sum(t4.nums)>0   then sum(t4.nums) 
		when t3.deminsion_level ='区域' then 1
		else 0 end  as  nums
		from   (SELECT *, CASE when deminsion_level ='区域' then 1 else 0 end  as nums
		from user_deminsion_t)as t3 LEFT JOIN (SELECT *, CASE when deminsion_level ='区域' then 1 else 0 end  as nums
		from user_deminsion_t) t4 on t3.deminsion_code = t4.parent_code 
		GROUP BY  t3.deminsion_value,t3.deminsion_code ) t6
	on t5.deminsion_code = t6.parent_code 
	GROUP BY  t5.deminsion_value,t5.deminsion_code
) t8
on t7.deminsion_code = t8.parent_code 
GROUP BY  t7.deminsion_value,t7.deminsion_code
