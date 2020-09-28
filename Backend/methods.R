passedDay <- function(t_exchanges, t_holders, selected_token) {
  h1 <- token_info[
    (tolower(token_info$symbol) == tolower(selected_token$symbol)) & (token_info$date_time >= (today - 1))
  , ]
  ch_h1 <- round(100 * (as.numeric(t_holders) - as.numeric(h1$sum_holders[1])) / as.numeric(t_holders), 2)

  h7 <- token_info[
    (tolower(token_info$symbol) == tolower(selected_token$symbol)) & (token_info$date_time >= (today - 7))
  , ]
  ch_h7 <- round(100 * (as.numeric(t_holders) - as.numeric(h7$sum_holders[1])) / as.numeric(t_holders), 2)

  h30 <- token_info[
    (tolower(token_info$symbol) == tolower(selected_token$symbol)) & (token_info$date_time >= (today - 30))
  , ]
  ch_h30 <- round(100 * (as.numeric(t_holders) - as.numeric(h30$sum_holders[1])) / as.numeric(t_holders), 2)


  e1 <- token_info[
    (tolower(token_info$symbol) == tolower(selected_token$symbol)) & (token_info$date_time >= (today - 1))
    , ]
  ch_e1 <- round(100 * (as.numeric(t_exchanges) - as.numeric(e1$sum_exchanges[1])) / as.numeric(t_exchanges), 2)

  e7 <- token_info[
    (tolower(token_info$symbol) == tolower(selected_token$symbol)) & (token_info$date_time >= (today - 7))
    , ]
  ch_e7 <- round(100 * (as.numeric(t_exchanges) - as.numeric(e7$sum_exchanges[1])) / as.numeric(t_exchanges), 2)

  e30 <- token_info[
    (tolower(token_info$symbol) == tolower(selected_token$symbol)) & (token_info$date_time >= (today - 30))
    , ]
  ch_e30 <- round(100 * (as.numeric(t_exchanges) - as.numeric(e30$sum_exchanges[1])) / as.numeric(t_exchanges), 2)
  return(
    list(
      "1 D" = c(
        selected_token$price_1, ch_h1, ch_e1
      ),
      "7 D" = c(
        selected_token$price_7, ch_h7, ch_e7
      ),
      "30 D" = c(
        selected_token$price_30, ch_h30, ch_e30
      )
    )
  )
}
