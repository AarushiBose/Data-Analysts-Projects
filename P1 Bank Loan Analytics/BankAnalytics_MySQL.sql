use bank_analysis;

SELECT * FROM bank_analysis.transformedfin_1;
SELECT * FROM bank_analysis.transformedfin_2;

#KPI 1
select year(issue_d) as Year_of_Issue, concat("$ ", format(sum(loan_amnt)/1000000,0),"M") as Total_Loan_Amount 
from transformedfin_1
group by Year_of_Issue
order by Year_of_Issue;

#KPI 2
 select grade, sub_grade, concat("$ ", format(sum(revol_bal)/1000000,2),"M") as total_revolution_balance
 from transformedfin_1 inner join transformedfin_2
 on (transformedfin_1.id = transformedfin_2.id)
 group by grade, sub_grade
 order by grade, sub_grade desc;
 
 #KPI 3
 select verification_status, concat("$ ", format(sum(total_pymnt)/1000000,2),"M") as Total_Payment
 from transformedfin_1 inner join transformedfin_2
 on (transformedfin_1.id = transformedfin_2.id)
 group by verification_status;
 
#KPI 4
SELECT addr_state as State, 
       CONCAT(year(issue_d), '-', LPAD(month(issue_d), 2, '0')) as Year_Month_of_Issue,
       loan_status, 
       count(*) as Count_of_Loan_Status
FROM transformedfin_1 
GROUP BY State, Year_Month_of_Issue, loan_status
ORDER BY State, Year_Month_of_Issue;

#KPI 5
SELECT home_ownership AS Home_Ownership,
       MAX(last_pymnt_d) AS Last_Payment_Date, COUNT(last_pymnt_d) AS Count_of_Last_Payment_Date
FROM transformedfin_1
INNER JOIN transformedfin_2 ON transformedfin_1.id = transformedfin_2.id
GROUP BY Home_Ownership
ORDER BY Home_Ownership;


select home_ownership as Home_Ownership, last_pymnt_d as Last_payment_Date,
concat("$ ", format(sum(last_pymnt_amnt)/10000,2),"K") as total_Amount
from transformedfin_1 inner join transformedfin_2
on (transformedfin_1.id = transformedfin_2.id)
group by Home_Ownership, Last_payment_Date
order by Home_Ownership, Last_payment_Date desc;

#------------------------------------------------------------ Extra KPIs ------------------------------------------------------------------

#KPI 6 -- Purpose wise loan amount
 select purpose, concat("$ ", format(sum(loan_amnt)/1000000,2),"M") as total_loan_amount
 from transformedfin_1 
 group by purpose
 order by   SUM(loan_amnt) DESC;
 
#KPI 7 -- Top 5 States with most loan amount
 select addr_state as States, concat("$ ", format(sum(loan_amnt)/1000000,2),"M") as Total_Loan_Amount
 from transformedfin_1 
 group by States
 order by SUM(loan_amnt) desc
 LIMIT 5; 

#KPI 8A -- Term wise Average Installment
 select term,  ROUND(AVG(installment)) as installment
 from transformedfin_1 
 group by term;
 
 #KPI 8B -- Term wise Loan Amount
 select term,  concat("$ ", format(sum(loan_amnt)/1000000,2),"M") as Loan_Amount
 from transformedfin_1 
 group by term;

#Total Customers
select count(id) as Total_Customers from transformedfin_1;

#Total Loan Amount
select concat("$ ", format(sum(loan_amnt)/1000000,2),"M") as Total_Loan_Amount from transformedfin_1;

#Average Interest Rate
SELECT CONCAT(ROUND(AVG(int_rate) * 100, 2), '%') AS Average_Interest_Rate
FROM transformedfin_1;

#Average DTI
SELECT ROUND(AVG(dti), 2) AS Average_DTI 
FROM transformedfin_1;

#Average Revol Balance
SELECT CONCAT("$ ", FORMAT(AVG(revol_bal)/1000, 2), "K") AS Average_Revol_Balance 
FROM transformedfin_2;

