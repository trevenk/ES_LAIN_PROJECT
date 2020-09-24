header <- dashboardHeaderPlus(
    title = tagList(
        span(class = "logo-lg", "shiny"),
        img(src = "https://drive.google.com/file/d/1yYBQeebgXF-xcZ1ba9f3skEhlJI9AX0G/view?usp=sharing")),
    enable_rightsidebar = F
)

sidebar <- dashboardSidebar(
    collapsed = F,
    sidebarMenu(
        id = "menu_sidebar",
        menuItem(
            text = "Main", icon = icon('ethereum'), badgeLabel = "dev", badgeColor = "red", tabName = 'main', selected = T
        ),
        menuItem(text = "History", icon = icon('line-chart'), badgeLabel = "dev", badgeColor = "red",tabName = 'history')
    )
)

body = dashboardBody(
    tabItems(
        tabItem(
            tabName = "main",
            fluidPage(
                BigSelectorUI('token_selector', main_selector_options),
                hr(),
                StaticTableUI('token_table'),

                column(
                    width = 12,
                    boxPlus(
                        title = 'Token balances', status = "info", solidHeader = F, collapsible = T, closable = F, width = 12,
                        LinePlotWithFiltersUI('lines_with_filters_plot'),
                        column(width = 12, align = 'right', LinesSelectorUI('lines_to_plot'))
                    )
                )
            )
        ),
        tabItem(
            tabName = "history"
        )
    )
)

ui <- dashboardPagePlus(
    header = header,
    sidebar = sidebar,
    body = body,
    skin = 'black'
)
