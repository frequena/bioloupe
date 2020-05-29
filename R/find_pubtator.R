#' Find entities using Pubtator API
#'
#' @param pmid text search
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content
#' @importFrom dplyr case_when filter slice
#' @importFrom stringr str_split str_detect
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

  #
  # a

  # pmid <- 31366551

  input_vector <- pmid
  pmid <- pmid %>% paste(collapse = ',')


  base_url <- paste0(pubtator_url, pmid)
  res <- GET(base_url, user_agent = ua)

  content_query <- content(res, encoding = 'UTF-8')
  content_query <- strsplit(content_query, split = '\n', fixed = TRUE)[[1]]

  result_list <- list()

  for (i in 1:length(input_vector)) {

    content_tmp <- content_query[content_query %>% str_detect(as.character(input_vector[i]))]

  # Let's see what to do with title
  title <- content_tmp[1]
  title <- str_remove(title, paste0(input_vector[i], '\\|t\\|'))

  abstract <- content_tmp[2]
  abstract <- str_remove(abstract, paste0(input_vector[i], '\\|a\\|'))


  result_tbl <- content_tmp %>%
    enframe(name = NULL) %>%
    slice(3:nrow(.)) %>%
    separate(.data$value, sep = '\t', into =c('pmid', 'start', 'end', 'word', 'category', 'identifier')) %>%
    mutate(color = case_when(category == 'Gene' ~ 'green',
                             category == 'Species' ~ 'lime',
                             category == 'Disease' ~ 'red',
                             category == 'SNP' ~ 'orange',
                             category == 'Chemical' ~ 'blue'),
           start = as.integer(.data$start),
           end = as.integer(.data$end))

  # Tagging title

  tags_title <- result_tbl %>%
    mutate(start = .data$start + 1) %>%
    filter(.data$start < nchar(title)) %>%
    mutate(html_tag = paste0('<span style="color:', .data$color, '">', .data$word, '</span>'))

  splitted_title <- str_split(title, '')[[1]]

  for (j in 1:nrow(tags_title)) {

    tmp_start <- tags_title[j,]$start
    tmp_end <- tags_title[j,]$end
    tmp_html_tag <- tags_title[j,]$html_tag

    splitted_title[tmp_start] <- tmp_html_tag
    splitted_title[(tmp_start + 1):tmp_end] <- ''

  }

  title_tagged <- splitted_title %>%
    paste(collapse = '') %>%
    noquote()


  # Tagging abstract

    result_tags <- result_tbl %>%
      mutate(start = .data$start - nchar(title),
             end = .data$end - nchar(title) - 1,
             element = ifelse(.data$start <= 0, 'title', 'abstract')) %>%
      filter(.data$element == 'abstract') %>%
      mutate(html_tag = paste0('<span style="color:', .data$color, '">', .data$word, '</span>'))


    splitted_abstract <- str_split(abstract, '')[[1]]

    for (k in 1:nrow(result_tags)) {

      tmp_start <- result_tags[k,]$start
      tmp_end <- result_tags[k,]$end
      tmp_html_tag <- result_tags[k,]$html_tag

      splitted_abstract[tmp_start] <- tmp_html_tag
      splitted_abstract[(tmp_start + 1):tmp_end] <- ''

    }

    abstract_tagged <- splitted_abstract %>%
      paste(collapse = '') %>%
      noquote()


    # }

    list_tmp <- list('rm' = list('dataframe' = result_tbl,
                          'abstract_tagged' = abstract_tagged,
                          'title_tagged' = title_tagged))

    names(list_tmp) <- input_vector[i]
    result_list <- append(result_list, list_tmp)
  }

    return(result_list)
}




