AllInfoTokenUI <- function(id) {
  ns <- NS(id)
  uiOutput(ns('token_info'))
}

AllInfoTokenServer <- function(id, selected) {
  moduleServer(
    id,
    function(input, output, session) {
      output$token_info <- renderUI({
        fluidPage(
          box(
            width = 12,
            h3(selected$name),
            hr(),
            HTML(paste0('<a href = "', selected$website, '"> ', "Sitio web", '</a>')),
            br(),
            "Ver en etherscan: ", HTML(paste0('<a href = "https://etherscan.io/token/', selected$address, '" title = "Etherscan">',
                                              selected$address, '</a>')),
            br(),
            "Telegram: ", HTML(paste0('<a href = "', selected$telegram, '" title = "Telegram ', selected$name, '">',
                                      selected$name, '</a>')),
            br(),
            "Volumen: ", selected$volume,
          )
        )
      })
    }
  )
}
