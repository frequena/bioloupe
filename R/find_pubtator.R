#' Find entities using Pubtator API
#'
#' @param pmid text search
#' @param output specify the format of the output
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content
#' @importFrom dplyr case_when filter
#' @importFrom stringr str_split
#' @importFrom rlang .data
#' @export
#' @rdname find_pubtator
#'
#' @return the results from the search
#' @examples
#' \dontrun{
#' find_pubtator('22894909')
#' }

find_pubtator <- function(pmid, output = c('dataframe', 'html')){

  # pmid <- 32220312

  base_url <- paste0(pubtator_url, pmid)
  res <- GET(base_url, user_agent = ua)

  b <- content(res, encoding = 'UTF-8')
  b <- strsplit(b, split = '\n', fixed = TRUE)[[1]]

  # Let's see what to do with title
  title <- b[1]
  title <- str_remove(title, paste0(pmid, '\\|t\\|'))
  abstract <- b[2]
  abstract <- str_remove(abstract, paste0(pmid, '\\|a\\|'))
  b <- b[-c(1,2, length(b))]

  result_tbl <- b %>%
    enframe(name = NULL) %>%
    separate(.data$value, sep = '\t', into =c('pmid', 'start', 'end', 'word', 'category', 'identifier'))


  if (output == 'dataframe') {

    final_result <- result_tbl


  } else {


    result_tags <- result_tbl %>% mutate(color =
                                  case_when(category == 'Gene' ~ 'green',
                                            category == 'Species' ~ 'lime',
                                            category == 'Disease' ~ 'red',
                                            category == 'SNP' ~ 'orange',
                                            category == 'Chemical' ~ 'blue')) %>%
      mutate(start = as.integer(.data$start) - nchar(title),
             end = as.integer(.data$end) - nchar(title) - 1,
             element = ifelse(.data$start <= 0, 'title', 'abstract')) %>%
      filter(.data$element == 'abstract') %>%
      mutate(html_tag = paste0('<span style="color:', .data$color, '">', .data$word, '</span>'))


    splitted_abstract <- str_split(abstract, '')[[1]]

    for (i in 1:nrow(result_tags)) {

      tmp_start <- result_tags[i,]$start
      tmp_end <- result_tags[i,]$end
      tmp_html_tag <- result_tags[i,]$html_tag

      splitted_abstract[tmp_start] <- tmp_html_tag
      splitted_abstract[(tmp_start + 1):tmp_end] <- ''

    }

    abstract_tagged <- splitted_abstract %>%
      paste(collapse = '') %>%
      noquote()

    final_result <- abstract_tagged

  }

  return(final_result)

}



