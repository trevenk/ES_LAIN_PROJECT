LinePlotWithFiltersUI <- function(id) {
  ns <- NS(id)
  plotOutput(ns('holders_plot'))
}

LinePlotWithFiltersServer <- function(id, lines_to_plot) {
  moduleServer(
    id,
    function(input, output, session) {
      output$holders_plot <- renderGirafe({
        gg <- ggplot() + geom_text(aes(label = as.character(lines_to_plot), x = c(1,1), y = c(1,2))) + theme_void()
        girafe(ggobj = gg, width_svg = 9, height_svg = 4)
      })
    }
  )
}
