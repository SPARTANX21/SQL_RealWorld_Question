---

# SQL Real-World Question: Payment and Booking Reconciliation  

This repository showcases a **real-world SQL problem** involving payment and booking reconciliation, with a step-by-step solution.

---

## Problem Statement  

You have two tables:  

1. **`payments`**: Contains payment records.  
2. **`bookings`**: Contains booking details.  

### The Challenge  

- In the `payments` table, any payments above **999** are split into smaller chunks (multiples of 999 and the remainder).  
- The `bookings` table contains the reconciled total booking amounts directly.  
- The task is to confirm whether the `payments` table conforms to the `bookings` table reconciliation.

### Objective  

- Match the total payment amount for a `record_id` (including split chunks) with the total booking amount for a `booking_id`.  
- Add a column called **`final_result`**, indicating `"Match"` or `"No Match"` based on the comparison.  
- Compute **`difference_amount`** for non-matching records.  

### Example  

Consider the following example tables:  

#### `payments` Table  

| record_id | payment_id | amount |  
|-----------|------------|--------|  
| d25fg     | 1458321    | 450.65 |  
| h8ga6     | 1000001    | 999    |  
| h8ga6     | 1000002    | 999    |  
| h8ga6     | 1000003    | 999    |  
| h8ga6     | 1000004    | 503    |  
| a98oa     | 8792762    | 810    |  

#### `bookings` Table  

| booking_id | booking_amount |  
|------------|----------------|  
| 1458321    | 450.65         |  
| 1000001    | 3500           |  
| 8792762    | 750            |  

#### Expected Output (`final_output`)  

| payment_id | booking_id | total_payments_amount | total_booking_amount | final_result | difference_amount |  
|------------|------------|-----------------------|----------------------|--------------|-------------------|  
| 1458321    | 1458321    | 450.65                | 450.65               | Match        | 0                 |  
| 1000001    | 1000001    | 3500                  | 3500                 | Match        | 0                 |  
| 8792762    | 8792762    | 810                   | 750                  | No Match     | 60                |  

---

## Solution  

The SQL solution uses **Common Table Expressions (CTEs)** and **window functions** for clarity and performance.

```sql
-- Create database and use it
CREATE DATABASE sql_Pranay_Shah_by_rohit;
USE sql_Pranay_Shah_by_rohit;

-- Sample data
SELECT * FROM payments;
SELECT * FROM bookings;

-- SQL Solution
WITH paycte AS (
    SELECT 
        p.payment_id, 
        b.booking_id, 
        p.amount, 
        b.booking_amount, 
        SUM(p.amount) OVER (PARTITION BY p.record_id) AS amount_part
    FROM 
        payments p 
    LEFT JOIN 
        bookings b 
    ON 
        b.booking_id = p.payment_id
)
SELECT 
    payment_id, 
    booking_id,
    booking_amount, 
    amount_part, 
    ABS(p.booking_amount - p.amount_part) AS diff_amount, 
    CASE
        WHEN booking_amount = amount_part THEN 'Match'
        ELSE 'No Match'
    END AS 'Matched/Not Matched'
FROM 
    paycte p
WHERE 
    payment_id = booking_id;
```

---

## Repository Structure  

```
SQL_RealWorld_Question/
├── Question.png        # Problem statement image
├── SQL_query_.sql      # SQL solution file
├── README.md           # Documentation
├── SQL_useCase.xlsx    # problem statement
├── bookings.csv        # table for bookings
├── payments.csv        # table for payments
```

---

## How to Use  

1. **Clone the Repository**:  
   ```bash
   git clone https://github.com/SPARTANX21/SQL_RealWorld_Question.git
   ```
2. **Open the Image**: Review the problem statement in `Question.png`.  
3. **Execute the Solution**: Run `solution.sql` in your SQL environment.

---

## Highlights  

- **CTEs** simplify the query by breaking it into logical parts.  
- **Window functions** provide efficient aggregation.  
- **Real-world applicability**: Demonstrates payment and booking reconciliation in a scalable manner.  

---

Feel free to fork and contribute to this repository!  

--- 
