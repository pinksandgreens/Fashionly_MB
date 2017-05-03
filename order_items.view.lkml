view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension: gross_revenue {
    type: number
    value_format_name: decimal_2
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }

  measure: total_sales {
    type:  sum
    value_format: "0.00"
    sql: ${TABLE}.sale_price ;;

  }

  measure: average_aales_arice {
    type: average
    value_format: "0.00"
    sql: ${TABLE}.sale_price ;;
  }

measure: cumulative_sales_total {
  type: running_total
  label: "Cumulative Sales Total"
  value_format: "0.00"
  sql: ${sale_price} ;;
}

measure: total_gross_revenue {
  type: sum
  sql: ${gross_revenue}  ;;

}
}
