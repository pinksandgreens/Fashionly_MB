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
    value_format_name: decimal_2
    sql: ${TABLE}.sale_price ;;
  }

  dimension: gross_revenue {
    type: number
    value_format_name: decimal_2
    sql: CASE
          WHEN  ${orders.status} = 'complete' AND ${returned_date} IS NULL
            THEN  ${sale_price} - ${inventory_items.cost}
          ELSE 0
        END ;;
  }

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }

  measure: total_sales {
    type:  sum
    label: "Total Sales"
    sql: ${TABLE}.sale_price ;;

  }

  measure: average_sales_price {
    type: average
    label: "Average Sales Price"
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
  label: "Total Gross Revenuw"
  sql: ${gross_revenue}  ;;
}

measure:  total_gross_amount {
  type: number
  label: "Total Gross Amount"
  sql: ${total_gross_revenue} - ${inventory_items.total_cost} ;;

}

}
