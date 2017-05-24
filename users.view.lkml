view: users {
  sql_table_name: demo_db.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

dimension: age_tier {

  type: tier
  style: integer
  tiers: [15,25,35,50,65]
  sql: ${age} ;;
}

dimension: new_customer {
  type: yesno
  sql:  ${created_date} >= DATE_ADD(CURDATE(), INTERVAL -89 DAY)   ;;
#  (((users.created_at ) >= ((DATE_ADD(CURDATE(),INTERVAL -89 day))) AND (users.created_at ) < ((DATE_ADD(DATE_ADD(CURDATE(),INTERVAL -89 day),INTERVAL 90 day)))))
}
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
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
      day_of_month
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    map_layer_name: us_states
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    map_layer_name: us_zipcode_tabulation_areas
    type: zipcode
    sql: ${TABLE}.zip ;;
  }


  measure: count {
    label: "Count of users"
    type: count
    drill_fields: [detail*]
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      last_name,
      first_name,
      events.count,
      orders.count,
      user_data.count
    ]
  }
}
