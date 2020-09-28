header <- dashboardHeaderPlus(
    title = tagList(
        span(class = "logo-lg", "Lain Project"),
        img(src = "https://andres-crypto-bucket-ws.s3.amazonaws.com/logo24.png")),
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
    tags$head(tags$link(rel = "shortcut icon", href = "https://andres-crypto-bucket-ws.s3.amazonaws.com/logo24.png")),
    shinyDashboardThemes(theme = "grey_dark"),
    tabItems(
        tabItem(
            tabName = "main",
            fluidPage(
                h3("Evolución de los top holders"),
                fluidRow(
                    column(width = 7,
                           BigSelectorUI('token_selector', main_selector_options),
                           hr(),
                           StaticTableUI('token_table')),
                    column(width = 5, AllInfoTokenUI('token_all_info'))
                ),
                LinePlotWithFiltersUI('lines_with_filters_plot'),
                column(width = 12, align = 'right', LinesSelectorUI('lines_to_plot')),

                box(
                    title = h3("Traced Holders"), status = "info", solidHeader = F, width = 12,
                    collapsible = T, collapsed = T,
                    StaticTableForEntityUI('traced_table')
                ),

                box(
                    title = h3("Exchanges"), status = "info", solidHeader = F, width = 12, collapsible = T, collapsed = T,
                    StaticTableForEntityUI('exchanges_table')
                ),
                br()
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
