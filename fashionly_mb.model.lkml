connection: "thelook"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"


map_layer: my_neighborhood_layer {
  file: "map.topojson"
  property_key: "neighborhood"
}
explore: events {
conditionally_filter: {}
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.order_id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: customer_revenue {
    type: left_outer
    sql_on: ${customer_revenue.orders_created_date} = ${orders.created_date}
            AND ${customer_revenue.order_id} = ${orders.order_id} ;;
    relationship: many_to_one
  }

  join: customer_counts {
    type: left_outer
    sql_on: ${customer_counts.user_id} = ${orders.user_id} ;;
    relationship: one_to_one
  }

  join:  user_behavior {
      type: left_outer
      sql_on:  ${users.id} = ${user_behavior.user_id} ;;
      relationship: many_to_one
  }

}

explore: customers {
  view_name: order_items

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.order_id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: customer_counts {
    type: left_outer
    sql_on: ${customer_counts.user_id} = ${orders.user_id} ;;
    relationship: one_to_one
  }

  join: customer_revenue {
    type: left_outer
    sql_on: ${customer_revenue.order_id} = ${order_items.order_id} ;;
    relationship: many_to_one
  }

}

explore: orders {
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: products {}

explore: schema_migrations {}

explore: user_data {
  join: users {
    type: left_outer
    sql_on: ${user_data.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {}

explore: users_nn {}

explore: user_behavior {}
