-- Master raw data table

Select *
From BankCustomerComplaints..consumer_complaints$

-- To clean date_received column

Select *, PARSENAME(Replace(date_received, '/','.'),1) as year_received
From BankCustomerComplaints..consumer_complaints$

Alter table BankCustomerComplaints..consumer_complaints$
Add year_received int

Update BankCustomerComplaints..consumer_complaints$
Set year_received = PARSENAME(Replace(date_received, '/','.'),1)

-- Create temptable with valid year_received

Drop table if exists #consumer_complaints
Create table #consumer_complaints
(
date_received nvarchar(255),
product nvarchar(255),
sub_product nvarchar (255),
issue nvarchar(255),
sub_issue nvarchar(255),
consumer_complaint_narrative nvarchar(255),
company_public_response nvarchar(255),
company nvarchar(255),
state nvarchar(255),
zipcode float,
tags nvarchar(255),
consumer_consent_provided nvarchar(255),
submitted_via nvarchar(255),
date_sent_to_company datetime,
company_response_to_consumer nvarchar(255),
timely_response nvarchar(255),
consumer_disputed nvarchar(255),
complaint_id float,
year_received int
)

Select *
From BankCustomerComplaints..consumer_complaints$
Where year_received <= 2016
Order by year_received desc

Insert into #consumer_complaints
Select *
From BankCustomerComplaints..consumer_complaints$
Where year_received <= 2016
Order by year_received desc

Select *
From #consumer_complaints

-- Using master temp table #consumer_complaints

Select *
From #consumer_complaints

-- Total complaints

Select COUNT(complaint_id) as TotalComplaints
From #consumer_complaints

-- Yearly total complaints

Select year_received, COUNT(year_received) as YearlyTotalComplaints
From #consumer_complaints
Group by year_received
Order by YearlyTotalComplaints desc

-- Top product complaints

Select product, COUNT(complaint_ID) as TotalProductComplain
From #consumer_complaints
Group by product
Order by TotalProductComplain desc

-- Top product complaints for top 3 year which has the highest complain (2015, 2014, 2013)

Select year_received, product, COUNT(complaint_ID) as TotalProductComplain
From #consumer_complaints
Where year_received = 2015 
Group by product, year_received
Order by TotalProductComplain desc

Select year_received, product, COUNT(complaint_ID) as TotalProductComplain
From #consumer_complaints
Where year_received = 2014 
Group by product, year_received
Order by TotalProductComplain desc

Select year_received, product, COUNT(complaint_id) as TotalProductComplain
From #consumer_complaints
Where year_received = 2013 
Group by product, year_received
Order by TotalProductComplain desc

-- Company has the highest complaints

Select company, COUNT(complaint_id) as TotalCompanyComplain
From #consumer_complaints
Group by company
Order by TotalCompanyComplain desc 

-- Consumer complaint via

Select submitted_via, COUNT(complaint_id) as TotalComplainSubmittedVia
From #consumer_complaints
Group by submitted_via
Order by TotalComplainSubmittedVia desc

-- Total complain per Zipcode

Select zipcode, COUNT(complaint_id) as TotalComplainbyZipCode
From #consumer_complaints
Where zipcode is not null
Group by zipcode
Order by TotalComplainbyZipCode desc

-- Company response to complain

Select company_response_to_consumer, COUNT(complaint_id) as TotalResponse
From #consumer_complaints
Group by company_response_to_consumer
Order by company_response_to_consumer

