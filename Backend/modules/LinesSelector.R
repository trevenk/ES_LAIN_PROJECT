LinesSelectorUI <- function(id) {
  ns <- NS(id)
  awesomeCheckboxGroup(inputId = ns('lines_to_plot'), label = NULL, choices = c('holders', 'exchanges'), selected = 'holders',
                       inline = T, status = 'warning')
}

LinesSelectorServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      return(
        input$lines_to_plot
      )
    }
  )
}
