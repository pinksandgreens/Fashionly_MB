view: customer_counts {
  label: "Customer Facts"
  derived_table: {
    sql:
    SELECT orders.user_id user_id,
           COUNT(DISTINCT orders.id ) customer_distinct_order_count,
           COUNT(orders.id) customer_total_orders,
           MAX(NULLIF(orders.created_at, 0)) customer_last_order_date,
           MIN(NULLIF(orders.created_at, 0)) customer_first_order_date,
           DATEDIFF(MAX(NULLIF(orders.created_at,0)),MIN(NULLIF(orders.created_at,0))) AS days_as_customer,
           DATEDIFF(CURDATE(),MAX(NULLIF(orders.created_at,0))) AS days_since_last_order
      FROM demo_db.order_items  AS order_items
        LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id
        GROUP BY orders.user_id  ;;
    # persist_for: "24 hours"
    }


    dimension: user_id {
      type: number
      sql: ${TABLE}.user_id ;;
      primary_key: yes
    }

    dimension: customer_order_count {
        type: number
        # hidden: yes
        sql:  ${TABLE}.customer_distinct_order_count ;;
    }

    dimension: customer_order_count_tier {
      type: tier
      tiers: [1,2,3,6,10]
      style: integer
      sql: ${customer_order_count} ;;
    }

    dimension: customer_last_order_date {
      type: date
      sql: ${TABLE}.customer_last_order_date ;;
    }

    dimension: customer_first_order_date {
      type: date
      sql: ${TABLE}.customer_first_order_date ;;
    }

    dimension: repeat_customer {
      type: yesno
      sql: ${customer_order_count} > 1 ;;
    }

    measure: average_orders_count {
      type: average
      sql: ${customer_order_count} ;;
    }

    dimension: days_since_last_order {
      type: number
      sql:  ${TABLE}.days_since_last_order;;
    }

    measure: average_days_since_last_order {
      type: average
      sql: ${TABLE}.days_since_last_order;;
    }
    measure: total_orders {
      type: sum
      sql:  ${customer_order_count} ;;
    }
}
