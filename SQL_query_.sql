create database sql_Pranay_Shah_by_rohit;
use sql_Pranay_Shah_by_rohit;

show tables;

select * from payments;
select * from bookings;

with paycte as (
	select p.payment_id, b.booking_id, p.amount, b.booking_amount, sum(p.amount) over(partition by p.record_id) as amount_part
    from payments p left join bookings b on b.booking_id = p.payment_id
)
select payment_id, booking_id,booking_amount, amount_part, abs(p.booking_amount - p.amount_part) as diff_amount, 
case
	when booking_amount = amount_part then 'Match'
    else 'No Match'
    end as 'Matched/Not Matched'
from paycte p
where payment_id = booking_id;
