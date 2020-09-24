shinyServer(function(input, output, session) {
    observeEvent(BigSelectorServer('token_selector'), {
        this_token <- BigSelectorServer('token_selector')
        token_info <- token_info[token_info$name == this_token, ]
        token_table <- tibble(
            "Class" = c('Precio', 'Holders', 'Exchanges'),
            "Actual" = c(token_info$precio, 50, token_info$exchanges),
            "7 D" = c(token_info$precio_7, 40, token_info$exchanges_7),
            "30 D" = c(token_info$precio_30, 95, token_info$exchanges_30)
        )
        StaticTableServer('token_table', token_table)

        ## Token Balances Plot
        observeEvent(LinesSelectorServer('lines_to_plot'), {
            lines_to_plot <- LinesSelectorServer('lines_to_plot')
            print(lines_to_plot)
            LinePlotWithFiltersServer('lines_with_filters_plot', lines_to_plot)
        })

        ## Wallets Table

        ## Exchanges Dropdown
    })



})

