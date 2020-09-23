BigSelectorUI <- function(id, main_selector_options) {
  ns <- NS(id)
  selectInput(inputId = ns('main_selector'), label = "Token", choices = main_selector_options,
              selected = main_selector_options[1], multiple = F, selectize = T)
}

BigSelectorServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      return(
        input$main_selector
      )
    }
  )
}
