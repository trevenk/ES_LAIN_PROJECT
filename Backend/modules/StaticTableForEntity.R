StaticTableForEntityUI <- function(id) {
  ns <- NS(id)
  DTOutput(ns('entity_static_table'))
}

StaticTableForEntityServer <- function(id, entity, token) {
  moduleServer(
    id,
    function(input, output, session) {
      if(entity == "traced") {
        theentity <- traced
      } else {
        theentity <- exchanges
      }
      entity_table <- na.exclude(unique(data.frame("name" = theentity$name, "address" = theentity$addres)))
      balance_t <- unlist(lapply(1:nrow(entity_table), function(i) {
        partial <- theentity[(theentity$time == today) & (theentity$name == entity_table$name[i]) & (tolower(theentity$symbol) == tolower(token)),]
        ifelse(nrow(partial) == 0, NA, partial$balance)
      }))
      balance_1 <- unlist(lapply(1:nrow(entity_table), function(i) {
        partial <- theentity[(theentity$time >= today - 1) & (theentity$name == entity_table$name[i]) & (tolower(theentity$symbol) == tolower(token)), ]
        ifelse(nrow(partial) == 0, NA, partial$balance[1])
      }))
      balance_7 <- unlist(lapply(1:nrow(entity_table), function(i) {
        partial <- theentity[(theentity$time >= today - 7) & (theentity$name == entity_table$name[i]) & (tolower(theentity$symbol) == tolower(token)), ]
        ifelse(nrow(partial) == 0, NA, partial$balance[1])
      }))
      balance_30 <- unlist(lapply(1:nrow(entity_table), function(i) {
        partial <- theentity[(theentity$time >= today - 30) & (theentity$name == entity_table$name[i]) & (tolower(theentity$symbol) == tolower(token)), ]
        ifelse(nrow(partial) == 0, NA, partial$balance[1])
      }))
      hard_table <- tibble(
        "name" = entity_table$name,
        "address" = unlist(lapply(1:nrow(entity_table), function(i) {
          HTML(paste0('<a href = "https://etherscan.io/token/', entity_table$address[i], '" title = "Etherscan">',
                      entity_table$address[i], '</a>'))
        })),
      )
      output$entity_static_table <- renderDT({
        datatable(tibble(entity_table, "Qty" = balance_t, "1 D" = balance_1, "7 D" = balance_7, "30 D" = balance_30))
      })
      #
    }
  )
}
