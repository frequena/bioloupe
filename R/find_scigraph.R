#' #' Find entities using SciGraph API
#' @author Francisco Requena
#' @param text text to annotate
#' @param include_category include category
#' @param exclude_category exclude category
#' @param min_length minimum length of characters to annotate
#' @param longest_only if two or more words overlap, take only the longest one
#' @param include_abbreviation consider abbreviations in the text
#' @param include_acronym consider acronyms in the text
#' @param include_numbers consider numbers in the text
#' @importFrom httr http_type http_error content modify_url GET
#' @importFrom tibble enframe
#' @importFrom dplyr select mutate na_if
#' @importFrom stats na.omit
#' @importFrom magrittr %>%
#' @importFrom stringr str_remove str_match_all
#' @importFrom tidyr separate separate_rows
#' @importFrom jsonlite fromJSON
#' @return the results from the search
#' @examples
#' \dontrun{
#' find_scigraph(text = 'Marfan syndrome the gene DLL', include_category = 'anatomical entity')
#' }
#'

#' @rdname find_scigraph
#' @export
find_scigraph <- function(text, include_category = NULL,
                             exclude_category = NULL, min_length = 4, longest_only = FALSE,
                             include_abbreviation = FALSE, include_acronym = FALSE,
                             include_numbers = FALSE) {

  check_internet()

  # text <- 'Marfan syndrome is a multisystemic genetic condition affecting connective tissue. It carries a reduced life expectancy, largely dependent on cardiovascular complications. More common cardiac manifestations such as aortic dissection and aortic valve incompetence have been widely documented in the literature. Mitral valve prolapse (MVP), however, has remained poorly documented. This article aims at exploring the existing literature on the pathophysiology and diagnosis of MVP in patients with Marfan syndrome, defining its current management and outlining the future developments surrounding it.'

  # resource <- 'nlp/annotate'
  # text <- abstract_input
  # # Test
  # args <- list(content = abstract_input)
  # url <- 'https://api.monarchinitiative.org/api/nlp/annotate'
  # resp <- GET(url,  query = list(content = abstract_input))

  # resource = 'nlp/annotate'

  # stopifnot(!is.null(content), 'Content argument can not be empty')


  args <- list(content = text, include_category = include_category,
               exclude_category = exclude_category, min_length = min_length,
               longest_only = longest_only, include_abbreviation = include_abbreviation,
               include_acronym = include_acronym, include_numbers = include_numbers)


  url <- modify_url(scigraph_url, path = 'api/nlp/annotate')


  resp <- GET(url, user_agent = ua, query = args)

  check_response(resp)


  parsed <- jsonlite::fromJSON(content(resp, as = "text", encoding = 'UTF-8'), simplifyVector = TRUE)


  parsed <- parsed %>% stringr::str_match_all('("(.*?)")')
  parsed <- parsed[[1]][,1]

  result_tbl <- parsed %>%
    enframe(value = 'parsed', name = NULL) %>%
    separate_rows(.data$parsed,sep =  '\\|') %>%
    filter(!str_detect(.data$parsed, 'sciCrunchAnnotation')) %>%
    tidyr::separate(.data$parsed, c('word', 'identifier', 'category'), sep = ',') %>%
    select(.data$word, .data$category, .data$identifier) %>%
    mutate(word = tolower(str_remove(.data$word, '"')),
           category = tolower(str_remove(.data$category, '"'))) %>%
    dplyr::na_if('')
    # na.omit()
    #


  structure(
    list(
      # content = ifelse(output_type == 'dataframe', as.data.frame(parsed), parsed),
      content = result_tbl,
      path = url,
      response = resp
    ),
    class = "biolink_api"
  )

}
