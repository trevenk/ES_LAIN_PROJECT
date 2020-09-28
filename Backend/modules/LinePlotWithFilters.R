LinePlotWithFiltersUI <- function(id) {
  ns <- NS(id)
  girafeOutput(ns('holders_plot'))
}

LinePlotWithFiltersServer <- function(id, lines_to_plot, token) {
  moduleServer(
    id,
    function(input, output, session) {
      output$holders_plot <- renderGirafe({
        theplot <- token_info[tolower(token_info$symbol) == tolower(token), ]
        gg <- ggplot()
        if(any(lines_to_plot == "holders")) {
          gg <- gg + geom_line(data = theplot, aes(
            x = date_time, y = sum_holders, group = 1
          ), col = "darkgreen") + geom_point_interactive(data = theplot, aes(
            x = date_time, y = sum_holders, tooltip = paste0("Fecha: " = date_time), group = date_time
          ), col = "green", size = 1.5)
        }
        if(any(lines_to_plot == "exchanges")) {
          gg <- gg + geom_line(data = theplot, aes(
            x = date_time, y = sum_exchanges, group = 1
          ), col = "red") + geom_point_interactive(data = theplot, aes(
            x = date_time, y = sum_exchanges, tooltip = paste0("Fecha: " = date_time), group = date_time
          ), col = "red")
        }
        gg <- gg + xlab("Fecha") + ylab("Cantidad") + theme_minimal() +
          theme(plot.background = element_rect(fill = "darkgrey"))
        girafe(ggobj = gg, width_svg = 11, height_svg = 4)
      })
    }
  )
}
