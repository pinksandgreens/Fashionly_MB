view: orders {
  sql_table_name: demo_db.orders ;;


  filter: create_date_filter {
    type: date

  }
  filter: test_date_filter {
    type: string
    sql: ${created_date} > ${testdatefilter_date};;
  }

  dimension_group: testdatefilter {
    type: time
    timeframes: [raw, date]
    sql:  CAST({% parameter test_date_filter %} AS DATE);;
  }
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
      year,
      month_num
    ]
    sql: ${TABLE}.created_at;;
  }

  dimension: create_start_date {
    type: string
    hidden: yes
    sql: COALESCE( {% date_start create_date_filter %}, DATEADD(${create_end_date}, INTERVAL DAY -30) ;;
  }


  dimension: create_end_date {
    type: string
    hidden: yes
    sql: {% date_end create_date_filter %} ;;
  }
  dimension: order_date_diff {
    type: string
    sql:
      CONCAT(
       IF(FLOOR(HOUR(TIMEDIFF(CURDATE(), (DATE(orders.created_at )))) / 24) = 0, '', CONCAT(FLOOR(HOUR(TIMEDIFF(CURDATE(), (DATE(orders.created_at )))) / 24), ' days, ')),
       IF(MOD(HOUR(TIMEDIFF(CURDATE(), (DATE(orders.created_at )))), 24) = 0, '', CONCAT(MOD(HOUR(TIMEDIFF(CURDATE(), (DATE(orders.created_at )))), 24), ' hours, ')),
       IF(MINUTE(TIMEDIFF(CURDATE(), (DATE(orders.created_at )))) = 0, '', CONCAT(MINUTE(TIMEDIFF(CURDATE(), (DATE(orders.created_at )))), ' minutes, ')),
       SECOND(TIMEDIFF(CURDATE(), (DATE(orders.created_at )))), ' seconds')
    ;;
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

  dimension: status_upper {
    type: string
    sql: CASE WHEN ${status} LIKE 'complete%'  THEN 'COMPLETED'
              WHEN ${status} LIKE 'pend%' THEN 'PENDING'
              WHEN ${status} LIKE 'cancel%' THEN 'CANCELLED'
              END ;;

    }
    dimension: user_id {
      type: number
      hidden: yes
      sql: ${TABLE}.user_id ;;
    }

    dimension: yearly_orders_target_base {
      type: number
      hidden:  yes
      sql: 15000.00 ;;
    }

    measure: count_of_orders {
      type: count
      drill_fields: [order_id, users.last_name, users.first_name, users.id, order_items.count]
    }

    measure:  yearly_budget_target {
      type: average
      sql: ${yearly_orders_target_base} ;;
    }

    measure:  running_monthly_budget_target {
      type: running_total
      sql: ${yearly_orders_target_base}/12 ;;
    }

    measure:  running_total_of_orders {
      type: running_total
      sql: ${count_of_orders} ;;
      html: {{ running_total_of_orders._value }} | {{ running_total_of_orders._value | divided_by: yearly_orders_target_base._value  | times: 100 | round: 2 }}% of Target;;

    }

    measure:  percentage_complete {
      type:  number
      sql:  ${running_total_of_orders} ;;

      html: {{ running_total_of_orders._value | divided_by: yearly_orders_target_base._value | times: 100 | round: 2 }}% of Target;;
    }

  }
