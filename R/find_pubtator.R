#' Find entities using Pubtator API
#'
#' @param pmid text search
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content
#' @importFrom rlang .data
#' @export
#' @rdname find_pubtator
#'
#' @return the results from the search
#' @examples
#' \dontrun{
#' find_pubtator('22894909')
#' }

find_pubtator <- function(pmid){

  base_url <- paste0(pubtator_url, pmid)
  res <- GET(base_url, user_agent = ua)

  b <- content(res, encoding = 'UTF-8')
  b <- strsplit(b, split = '\n', fixed = TRUE)[[1]]
  b <- b[-c(1,2, length(b))]

  result_tbl <- b %>%
    enframe(name = NULL) %>%
    separate(.data$value, sep = '\t', into =c('pmid', 'start', 'end', 'word', 'category', 'identifier'))


  result_tbl
}
