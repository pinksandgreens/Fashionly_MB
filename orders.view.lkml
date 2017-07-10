view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

dimension_group: extracted_created {
  type: time
  timeframes: [ day_of_month, hour_of_day, minute, second]
  sql:   ${TABLE}.created_at;;
}
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count_of_orders {
    type: count
    drill_fields: [order_id, users.last_name, users.first_name, users.id, order_items.count]
  }
}
