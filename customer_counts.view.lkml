view: customer_counts {
  derived_table: {
    sql:
    SELECT orders.user_id user_id,  COUNT(DISTINCT orders.id ) customer_order_count
      FROM demo_db.order_items  AS order_items
        LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id
        GROUP BY orders.user_id  ;;
    }

    dimension: user_id {
      type: number
      sql: ${TABLE}.user_id ;;
    }

    dimension: customer_order_count {
        type: number
        sql:  ${TABLE}.customer_order_count ;;
    }

    dimension: customer_order_tier {
      type: tier
      tiers: [1,2,3,6,10]
      style: integer
      sql: ${customer_order_count} ;;
    }

}
