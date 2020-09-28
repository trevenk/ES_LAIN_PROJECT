library(aws.s3)
library(stringr)
library(lubridate)
library(jsonlite)
library(r.ETH)

source('../Security/Security.R')


setApiKey(ETHPLORER_KEY)

this_update_time <- today()

tokens <- s3read_using(fromJSON, object = "Lain/Tokens/token_index_card.json", bucket = "andres-crypto-bucket")

token_info_now <- lapply(1:nrow(tokens), function(i) {
  tryCatch({
    sp <- ethplorerGetTokenInfo(address = tokens$address[i], use_key = T, parsed_response = T)
    data.frame(
      "name" = sp$name, "symbol" = sp$symbol, "address" = sp$address, "logo" = ifelse(is.null(sp$image), NA, sp$image),
      "transfers_count" = sp$transfersCount,
      "holders_count" = sp$holdersCount, "website" = ifelse(is.null(sp$website), NA, sp$website),
      "telegram" = ifelse(is.null(sp$telegram), NA, sp$telegram),
      "price" = sp$price$rate,
      "price_1" = sp$price$diff, "price_7" = ifelse(is.null(sp$price$diff7d), NA, sp$price$diff7d),
      "price_30" = ifelse(is.null(sp$price$diff30d), NA, sp$price$diff30d), "marketcap" = sp$price$marketCapUsd,
      "volume" = sp$price$volume24h, "available_supply" = sp$price$availableSupply, "date_time" = this_update_time
    )
  }, error = function(e) {
    data.frame(
      "name" = tokens$name[i], "symbol" = tokens$symbol[i], "address" = tokens$address[i],
      "logo" = NA, "transfers_count" = NA, "holders_count" = NA, "website" = NA, "telegram" = NA,
      "price" = NA, "price_1" = NA, "price_7" = NA, "price_30" = NA, "marketcap" = NA, "volume" = NA,
      "available_supply" = NA, "date_time" = this_update_time
    )
  })
})

token_info_now <- do.call(rbind, token_info_now)

token_info_now$sum_holders <- NA
token_info_now$sum_exchanges <- NA

total <- lapply(1:nrow(token_info_now), function(i) {
  top_holders <- ethplorerGetTopHoldersToken(address = token_info_now$address[i], limit = 100, use_key = T)
  data.frame(do.call(rbind, top_holders$holders), "symbol" = token_info_now$symbol[i])
})


exchanges <- s3read_using(fromJSON, object = "Lain/Exchanges/exchange_index_card.json", bucket = "andres-crypto-bucket")
holders_now <- data.frame("address" = character(), "balance" = numeric(), "share" = numeric(),
                          "symbol" = character(), "type" = character())
exchanges_now  <- data.frame("address" = character(), "balance" = numeric(), "share" = numeric(),
                             "symbol" = character(), "type" = character())
for (i in 1:length(total)) {
  this_token <- total[[i]]
  this_token <- data.frame(apply(this_token, 2, unlist))
  this_token$type <- NA
  this_token$type <- ifelse(this_token$address %in% exchanges$address, 'exchange', 'holder')
  exchanges_sum <- sum(as.numeric(this_token$balance[this_token$type == 'exchange']))
  holders_sum <- sum(as.numeric(this_token$balance[this_token$type == 'holder']))

  token_info_now$sum_exchanges[i] <- exchanges_sum
  token_info_now$sum_holders[i] <- holders_sum
  #
  holders_now <- rbind(holders_now, this_token[this_token$type == "holder", ])
  exchanges_now <- rbind(exchanges_now, this_token[this_token$type == "exchange", ])
}

holders_now$time <- this_update_time
exchanges_now$time <- this_update_time

exchange_update <- data.frame("name" = character(), "address" = character(), "balance" = numeric(), "share" = numeric(),
                              "symbol" = character(), "type" = character(), "time" = character())
for (i in 1:nrow(exchanges)) {
  if(nrow(exchanges_now[exchanges_now$address == exchanges$address[i], ]) == 0) {
    p <- data.frame("address" = NA, "balance" = NA, "share" = NA, "symbol" = NA, "type" = NA, "time" = this_update_time)
  } else {
    p <- data.frame(exchanges_now[exchanges_now$address == exchanges$address[i], ])
  }
  exchange_update <- rbind(
    exchange_update,
    data.frame("name" = exchanges$name[i], p)
  )
}

traced <- s3read_using(fromJSON, object = "Lain/Holders/Traced/traced_info.json", bucket = "andres-crypto-bucket")
#traced$address <- as.character(total[[1]]$address[[1]])
traced_update <- data.frame("address" = character(), "balance" = numeric(), "share" = numeric(),
                            "symbol" = character(), "type" = character(), "time" = character())
the_trace <- traced[!duplicated(cbind(traced$address, traced$name)), ]
for (i in 1:nrow(the_trace)) {
  if(nrow(holders_now[holders_now$address == the_trace$address[i], ]) == 0) {
    p <- data.frame("address" = NA, "balance" = NA, "share" = NA, "symbol" = NA, "type" = NA, "time" = this_update_time)
  } else {
    p <- holders_now[holders_now$address == the_trace$address[i], ]
  }
  traced_update <- rbind(
    traced_update,
    data.frame("name" = the_trace$name, p)
  )
}

traced_update <- data.frame("address" = c(traced$address, traced_update$address),
                            "balance" = c(traced$balance, traced_update$balance),
                            "share" = c(traced$share, traced_update$share), "symbol" = c(traced$symbol, traced_update$symbol),
                            "type" = c(traced$type, traced_update$type),
                            "time" = c(as.character(traced$time), as.character(traced_update$time)),
                            "name" = c(traced$name, traced_update$name))
s3write_using(x = traced_update, write_json, object = "Lain/Holders/Traced/traced_info.json",
              bucket = "andres-crypto-bucket")
old_exchanges <- s3read_using(fromJSON, object = "Lain/Exchanges/exchange_info.json", bucket = "andres-crypto-bucket")
exchange_update <- data.frame("name" = c(old_exchanges$name, exchange_update$name),
                              "address" = c(old_exchanges$address, exchange_update$address),
                              "balance" = c(old_exchanges$balance, exchange_update$balance),
                              "share" = c(old_exchanges$share, exchange_update$share),
                              "symbol" = c(old_exchanges$symbol, exchange_update$symbol),
                              "type" = c(old_exchanges$type, exchange_update$type),
                              "time" = c(as.character(old_exchanges$time), as.character(exchange_update$time)))
s3write_using(x = exchange_update, FUN = write_json, object = "Lain/Exchanges/exchange_info.json",
              bucket = "andres-crypto-bucket")

s3write_using(x = holders_now, FUN = write_json, object = "Lain/Holders/last_holders.json",
              bucket = "andres-crypto-bucket")
old_token <- s3read_using(fromJSON, object = "Lain/Tokens/token_info.json", bucket = "andres-crypto-bucket")
s <- data.frame(
  "name" = c(old_token$name, token_info_now$name), "symbol" = c(old_token$symbol, token_info_now$symbol),
  "address" = c(old_token$address, token_info_now$address), "logo" = c(old_token$logo, token_info_now$logo),
  "transfers_count" = c(old_token$transfers_count, token_info_now$transfers_count),
  "holders_count" = c(old_token$holders_count, token_info_now$holders_count),
  "website" = c(old_token$website, token_info_now$website), "telegram" = c(old_token$telegram, token_info_now$telegram),
  "price" = c(old_token$price, token_info_now$price), "price_1" = c(old_token$price_1, token_info_now$price_1),
  "price_7" = c(old_token$price_7, token_info_now$price_7), "price_30" = c(old_token$price_30, token_info_now$price_30),
  "marketcap" = c(old_token$marketcap, token_info_now$marketcap), "volume" = c(old_token$volume, token_info_now$volume),
  "available_supply" = c(old_token$available_supply, token_info_now$available_supply),
  "date_time" = c(as.character(old_token$date_time), as.character(token_info_now$date_time)),
  "sum_holders" = c(old_token$sum_holders, token_info_now$sum_holders),
  "sum_exchanges" = c(old_token$sum_exchanges, token_info_now$sum_exchanges)
)
s3write_using(x = s, write_json, object = "Lain/Tokens/token_info.json", bucket = "andres-crypto-bucket")



