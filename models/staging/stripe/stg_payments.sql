with payments as (
    select
        id as payment_id,
        orderid as order_id,
        created as payment_date,
        paymentmethod as payment_method,
        status,
        {{ cents_to_dollars('amount',4) }} as amount

    from {{ source('stripe', 'payment') }}
)
select * from payments