#' Find entities using Pubtator API
#'
#' @param pmid pmid
#' @param bioconcept bioconcept
#' @param raw_abstract raw_abstract
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
#' find_pubtator(22894909, bioconcept = 'all')
#' }

find_pubtator <- function(pmid, bioconcept = 'all', raw_abstract = FALSE){

  check_internet()


  # pmid <- c(23819905, 23819906, 32220312)
  # bioconcept <- 'gene'
  # c('all', 'gene', 'disease', 'chemical', 'species', 'mutation', 'cellline')

  # pmid <- 'PMC3531190'
  # bioconcept <- 'all'

  # pmid <- 20583161


  input_vector <- pmid
  pmid <- pmid %>% paste(collapse = ',')

  if (bioconcept == 'all') {

    base_url <- paste0(pubtator_url, 'pmids=', pmid)
  } else {

    base_url <- paste0(pubtator_url, 'pmids=', pmid, '&concepts=', bioconcept)
  }

  res <- GET(base_url, user_agent = ua)

  content_query <- content(res, encoding = 'UTF-8')
  content_query <- strsplit(content_query, split = '\n', fixed = TRUE)[[1]]

  result_list <- list()

  for (i in 1:length(input_vector)) {

  content_tmp <- content_query[content_query %>% str_detect(as.character(input_vector[i]))]

  title <- content_tmp[1]
  title <- str_remove(title, paste0(input_vector[i], '\\|t\\|'))
  splitted_title <- str_split(title, '')[[1]]


  abstract <- content_tmp[2]
  abstract <- str_remove(abstract, paste0(input_vector[i], '\\|a\\|'))
  splitted_abstract <- str_split(abstract, '')[[1]]

  result_tbl <- content_tmp %>%
    enframe(name = NULL) %>%
    slice(3:nrow(.)) %>%
    separate(.data$value, sep = '\t', into =c('id', 'start', 'end', 'word', 'category', 'identifier')) %>%
    mutate(color = case_when(category == 'Gene' ~ 'green',
                             category == 'Species' ~ 'lime',
                             category == 'Disease' ~ 'red',
                             category == 'SNP' ~ 'orange',
                             category == 'Chemical' ~ 'blue'),
           start = as.integer(.data$start),
           end = as.integer(.data$end)) %>%
    mutate(element = ifelse(.data$start < nchar(title), 'title', 'abstract'))

  # Tagging title

  tags_title <- result_tbl %>%
    filter(.data$element == 'title')


  if (nrow(tags_title) > 0) {

  tags_title <- tags_title %>%
    mutate(start = .data$start + 1) %>%
    filter(.data$start < nchar(title)) %>%
    mutate(html_tag = paste0('<span style="color:', .data$color, '">', .data$word, '</span>'))


  for (j in 1:nrow(tags_title)) {

    tmp_start <- tags_title[j,]$start
    tmp_end <- tags_title[j,]$end
    tmp_html_tag <- tags_title[j,]$html_tag

    splitted_title[tmp_start] <- tmp_html_tag
    splitted_title[(tmp_start + 1):tmp_end] <- ''

  }

  }

  title_tagged <- splitted_title %>%
    paste(collapse = '') %>%
    noquote()

  # Tagging abstract

  tags_title <- result_tbl %>%
    filter(.data$element == 'title')

  tags_abstract <- result_tbl %>%
    filter(.data$element == 'abstract')

  if (nrow(tags_abstract) > 0) {

    tags_abstract <- tags_abstract %>%
      mutate(start = .data$start - nchar(title),
             end = .data$end - nchar(title) - 1) %>%
      mutate(html_tag = paste0('<span style="color:', .data$color, '">', .data$word, '</span>'))



    for (k in 1:nrow(tags_abstract)) {

      tmp_start <- tags_abstract[k,]$start
      tmp_end <- tags_abstract[k,]$end
      tmp_html_tag <- tags_abstract[k,]$html_tag

      splitted_abstract[tmp_start] <- tmp_html_tag
      splitted_abstract[(tmp_start + 1):tmp_end] <- ''

    }

  }

    abstract_tagged <- splitted_abstract %>%
      paste(collapse = '') %>%
      noquote()

    if (nchar(abstract_tagged) == 0) abstract_tagged <- 'No abstract found'


    if (isFALSE(raw_abstract)) {


      list_tmp <- list('rm' = list('dataframe' = result_tbl,
                                   'abstract_tagged' = abstract_tagged,
                                   'title_tagged' = title_tagged))

    } else {


      list_tmp <- list('rm' = list('dataframe' = result_tbl,
                                   'abstract_tagged' = abstract,
                                   'title_tagged' = title_tagged))


    }



    names(list_tmp) <- input_vector[i]
    result_list <- append(result_list, list_tmp)
  }

    return(result_list)
}
