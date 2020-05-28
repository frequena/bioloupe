
#' #' Find entities using Tagger API
#' @author Francisco Requena
#' @param text_input text
#' @param bioconcept bioconcept
#' @importFrom httr http_type http_error content modify_url GET POST
#' @importFrom tibble enframe rownames_to_column
#' @importFrom dplyr select mutate na_if
#' @importFrom stringr str_replace
#' @importFrom stats na.omit
#' @importFrom rlang .data
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

#' @rdname find_tagger
#' @export


find_tagger <- function(text_input, bioconcept = c('gene_species', 'chemical', 'disease',
                                                   'mutation')) {

text_input <- 'A kinetic model identifies phosphorylated estrogen receptor-a (ERa) as a critical regulator of ERa dynamics in breast cancer.'
bioconcept <- 'gene_species'

list_bioconcepts <- list('GNormPlus' = 'gene_species',
                         'tmChem' = 'chemical',
                         'DNorm' = 'disease',
                         'tmVar' = 'mutation')

bioconcept_selected <- names(list_bioconcepts[list_bioconcepts %in% 'gene_species'])


post_text <- POST(url = paste0(tagger_url, bioconcept_selected, '/submit'),
                  user_agent = ua,
                  encode = 'json',
                  body = list('sourcedb' = 'PubMed',
                              'sourceid' = '1000001',
                              'text' = text_input))


identifier_request <- content(post_text, as = 'text', encoding = 'UTF-8')


g <- GET(paste0('https://www.ncbi.nlm.nih.gov/CBBresearch/Lu/Demo/RESTful/tmTool.cgi/',
                identifier_request, '/Receive/'))

result <- fromJSON(content(g, as = 'text', encoding = 'UTF-8'))$denotations

result <- result %>%
  rownames_to_column() %>%
  mutate(obj = str_replace(.data$obj, ':', '_')) %>%
  separate(col = .data$obj, sep = '_', into = c('category', 'identifier')) %>%
  mutate(start = .data$span$begin,
         end = .data$span$end) %>%
  select(-.data$rowname, -.data$span) %>%
  mutate(term = paste0(strsplit(text_input, split = '')[[1]][.data$start:.data$end], collapse = '')) %>%
  select(.data$term, .data$category, .data$identifier, .data$start, .data$end)

}
