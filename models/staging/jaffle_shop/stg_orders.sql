with orders as (

    select
        id as order_id,
        id as customer_id,
        order_date,
        status

    from {{ source('jaffle_shop', 'orders') }}
    {{ limit_data_in_dev('order_date', 10000) }}
)
select * from orders