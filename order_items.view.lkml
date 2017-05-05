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

  dimension: line_revenue {
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
    sql: ${TABLE}.sale_price ;;

  }

  measure: average_sales_price {
    type: average
    value_format: "0.00"
    sql: ${TABLE}.sale_price ;;
  }

measure: cumulative_sales_total {
  type: running_total
  value_format: "0.00"
  sql: ${sale_price} ;;
}

measure: total_gross_revenue {
  type: sum
  sql: ${line_revenue}  ;;
}

measure:  total_gross_margin {
  type: number
  sql: ${total_gross_revenue} - ${inventory_items.total_cost} ;;

}

measure:  average_gross_margin {
  type:  average
  sql:  ${line_revenue} - {inventory_items.cost};;
}

measure: gross_margin_percentage {
  type: percent_of_total
  sql: ${total_gross_margin}/${total_gross_revenue} ;;
}

}
