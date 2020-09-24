library(aws.s3)
library(stringr)
library(lubridate)
library(jsonlite)

source('../Security/Security.R')

library(r.ETH)
setApiKey(ETHPLORER_KEY)

tokens <- data.frame('t' = c('kai', 'enj', 'akro', 'band', 'ocean', 'rsr', 'mitx', 'sushi', 'ampl', 'comp', 'toko', 'dia', 'coval'),
                    'a' = c(
                      '0xbd6467a31899590474ce1e84f70594c53d628e46', '0xf629cbd94d3791c9250152bd8dfbdf380e2a3b9c',
                      '0x8ab7404063ec4dbcfd4598215992dc3f8ec853d7', '0xba11d00c5f74255f56a5e366f4f77f5a186d7f55',
                      '0x7AFeBBB46fDb47ed17b22ed075Cde2447694fB9e', '0x8762db106b2c2a0bccb3a80d1ed41273552616e8',
                      '0x4a527d8fc13c5203ab24ba0944f4cb14658d1db6', '0x6b3595068778dd592e39a122f4f5a5cf09c90fe2',
                      '0xd46ba6d942050d489dbd938a2c909a5d5039a161', '0xc00e94cb662c3520282e6f5717214004a7f26888',
                      '0x0c963a1b52eb97c5e457c7d76696f8b95c3087ed', '0x84cA8bc7997272c7CfB4D0Cd3D55cd942B3c9419',
                      '0x3d658390460295fb963f54dc0899cfb1c30776df'
                    ))
token_info_now <- lapply(1:nrow(tokens), function(i) {
  sp <- ethplorerGetTokenInfo(address = tokens$a[i], use_key = T, parsed_response = T)
  data.frame(
    "name" = sp$name, "symbol" = sp$symbol, "address" = sp$address, "logo" = ifelse(is.null(sp$image), NA, sp$image),
    "transfers_count" = sp$transfersCount,
    "holders_count" = sp$holdersCount, "website" = ifelse(is.null(sp$website), NA, sp$website),
    "telegram" = ifelse(is.null(sp$telegram), NA, sp$telegram),
    "price" = sp$price$rate,
    "price_1" = sp$price$diff, "price_7" = ifelse(is.null(sp$price$diff7d), NA, sp$price$diff7d),
    "price_30" = ifelse(is.null(sp$price$diff30d), NA, sp$price$diff30d), "marketcap" = sp$price$marketCapUsd,
    "volume" = sp$price$volume24h, "available_supply" = sp$price$availableSupply, "date_time" = now(tzone = 'UTC')
  )
})

token_info_now <- do.call(rbind, token_info_now)

token_info_now$sum_holders <- NA
token_info_now$sum_exchanges <- NA

total <- lapply(1:nrow(token_info_now), function(i) {
  top_holders <- ethplorerGetTopHoldersToken(address = token_info_now$address[i], limit = 100, use_key = T)
  data.frame(do.call(rbind, top_holders$holders), "symbol" = token_info_now$symbol[i])
})


exchanges <- fromJSON("../../exchange_index_card.json")
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
}
