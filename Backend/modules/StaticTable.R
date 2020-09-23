StaticTableUI <- function(id) {
  ns <- NS(id)
  tableOutput(ns('static_table_output'))
}

StaticTableServer <- function(id, selected_element) {
  moduleServer(
    id,
    function(input, output, session) {
      output$static_table_output <- renderTable({
        selected_element
      })
    }
  )
}
