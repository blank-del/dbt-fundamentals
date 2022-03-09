with payments as (

    select
        id as payment_id,
        orderid as order_id,
        created as payment_date,
        status,
        amount/100 as amount

    from {{ source('stripe', 'payment') }}
)
select * from payments