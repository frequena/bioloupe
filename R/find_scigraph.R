#' #' Find entities using SciGraph API
#' @author Francisco Requena
#' @param text text
#' @param include_category include category
#' @param exclude_category exclude category
#' @param min_length minimum length
#' @param longest_only longest only
#' @param include_abbreviation include abbreviation
#' @param include_acronym include acronym
#' @param include_numbers include numbers
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
#' biolink_api('nlp/annotate, content = 'Marfan syndrome', include_category = 'anatomical entity)
#' }
#'

#' @rdname find_scigraph
#' @export
find_scigraph <- function(text, include_category = NULL,
                             exclude_category = NULL, min_length = 4, longest_only = FALSE,
                             include_abbreviation = FALSE, include_acronym = FALSE,
                             include_numbers = FALSE) {

  check_internet()

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

  result_tbl <- parsed[[1]][6] %>%
    tibble::enframe(value = 'parsed', name = NULL) %>%
    dplyr::mutate(parsed = as.character(parsed),
           parsed = stringr::str_remove(parsed, '<span class="sciCrunchAnnotation" data-sciGraph='),
           parsed = stringr::str_remove(parsed, '/span>')) %>%
    tidyr::separate_rows(parsed, sep = '\\|') %>%
    tidyr::separate(parsed, c('name', 'id', 'category'), sep = ',') %>%
    dplyr::na_if('') %>%
    na.omit()

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
