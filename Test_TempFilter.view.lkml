# view: test_tempfilter  {
#     derived_table: {
#       sql: SELECT orders.user_id user_id,
#            COUNT(DISTINCT orders.id ) customer_distinct_order_count,
#            COUNT(orders.id) customer_total_orders
#       FROM demo_db.order_items  AS order_items
#         LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id
#         WHERE { % condition orders_after % } orders.created_at { % endcondition % }
#         GROUP BY orders.user_id
#  ;;
#     }
#
#   filter: orders_after {
#     label: "Test Fiter to limit orders created date"
#     type: date
#
#   }
#
#     measure: count {
#       type: count
#       drill_fields: [detail*]
#     }
#
#     dimension: user_id {
#       type: number
#       sql: ${TABLE}.user_id ;;
#     }
#
#     dimension: customer_distinct_order_count {
#       type: number
#       sql: ${TABLE}.customer_distinct_order_count ;;
#     }
#
#     dimension: customer_total_orders {
#       type: number
#       sql: ${TABLE}.customer_total_orders ;;
#     }
#
#     set: detail {
#       fields: [user_id, customer_distinct_order_count, customer_total_orders]
#     }
#   }
