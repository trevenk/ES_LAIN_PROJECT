shinyServer(function(input, output, session) {
    observeEvent(BigSelectorServer('token_selector'), {
        this_token <- tryCatch({
            BigSelectorServer('token_selector')
        }, error = function(e) {
            this_token
        })
        selected_token <- main_table[tolower(main_table$symbol) == tolower(this_token), ]
        passed_days <- passedDay(t_holders = selected_token$sum_holders, t_exchanges = selected_token$sum_exchanges,
                                 selected_token = selected_token)
        token_table <- tibble(
            "Class" = c('Precio', 'Holders', 'Exchanges'),
            "Actual" = c(selected_token$price, selected_token$sum_holders, selected_token$sum_exchanges),
            "1 D" = passed_days$`1 D`,
            "7 D" = passed_days$`7 D`,
            "30 D" = passed_days$`30 D`
        )

        StaticTableServer('token_table', token_table)

        ### Token Info ###
        AllInfoTokenServer('token_all_info', selected = selected_token)

        ## Token Balances Plot
        observeEvent(LinesSelectorServer('lines_to_plot'), {
            lines_to_plot <- LinesSelectorServer('lines_to_plot')
            LinePlotWithFiltersServer(id = 'lines_with_filters_plot', lines_to_plot = lines_to_plot, token = this_token)
        })

        ## Wallets Table
        StaticTableForEntityServer("traced_table", entity = "traced", token = this_token)
        ## Exchanges Dropdown
        StaticTableForEntityServer("exchanges_table", entity = "exchanges", token = this_token)
    })



})

