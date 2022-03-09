with payments as (
    select * from {{ ref('stg_payments') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
)

order_refine as (
    select order_id, 
    customer_id
    from orders
    where orders.status='completed'
),
payment_refine as (
    select payment_id, 
    order_id, 
    amount
    from payments
    where payments.status='success'
),

final as (
    select order_refine.order_id,
    order_refine.customer_id,
    payment_refine.amount,
    payment_refine.payment_date as order_date
    from order_refine 
    Inner join payment_refine using(order_id)
)
select * from final