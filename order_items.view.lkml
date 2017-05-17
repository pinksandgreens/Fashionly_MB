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

  dimension: sale_margin {
    type: number
    description: "Gross revenue for completed orders and non-returned items"
    value_format_name: decimal_2
    sql: CASE
          WHEN  ${orders.status} = 'complete' AND ${returned_date} IS NULL
            THEN  ${sale_price}
          ELSE 0
        END ;;
  }

  dimension:  returned_item {
    type: yesno
    sql: ${returned_date} is NULL ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_sales_price {
    type:  sum
    value_format_name: decimal_2
    sql: ${TABLE}.sale_price ;;
  }

  measure: average_sales_price {
    type: average
    value_format_name: decimal_2
    sql: ${TABLE}.sale_price ;;
  }

  measure:  total_adjusted_revenue {
    description: "total adjusted sales for completed orders and non-returned items"
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: orders.status
      value: "complete"
    }
    filters: {
      field: returned_item
      value: "yes"
    }
  }

  measure: total_adjusted_margin {
    type: number
    description: "Adjusted sales minus inventory cost"
    sql: ${total_adjusted_revenue} - ${inventory_items.total_cost} ;;
  }

  measure:  average_gross_margin {
    type: average
    value_format_name: decimal_2
    sql: ${sale_margin} - ${inventory_items.cost} ;;

  }



  measure: cumulative_sales_total {
    type: running_total
    label: "Cumulative Sales Total"
    value_format: "0.00"
    sql: ${sale_price} ;;
  }

  measure: total_gross_revenue {
    type: sum
    value_format_name: decimal_2
    label: "Total Gross Revenue"
    sql: ${sale_margin}  ;;
  }

  measure:  gross_margin_percentage {
    type: number
    sql: 100.0 * ${total_adjusted_margin}/COALESCE(${total_gross_revenue}, 0) ;;
  }

  set: detail {
    fields: [id,
      orders.created_at,
      orders.status,
      returned_date,
      products.brand,
      products.item_name,
      sale_price]
  }

}
