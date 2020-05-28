#' @importFrom curl has_internet
#' @importFrom httr http_type http_error user_agent



check_internet <- function() {

  if (isFALSE(has_internet())) {
    stop("Please check your internet connection")
  }

}

check_response  <- function(resp) {

  if (http_type(resp) != "application/json") stop("API did not return a json format")

  if (http_error(resp)) stop("BioLink API request failed")

  if (resp$status_code < 400) return(invisible())

  if (resp$status_code == 414){
    stop("HTTP failure 414, the request is too large. For large requests, try using web history as described in the rentrez tutorial")
  }

  if (resp$status_code == 502){
    stop("HTTP failure: 502, bad gateway. This error code is often returned when trying to download many records in a single request.  Try using web history as described in the rentrez tutorial")
  }

  message <- httr::content(resp, as="text", encoding="UTF-8")
  stop("HTTP failure: ", resp$status_code, "\n", message, call. = FALSE)
}

ua <- user_agent("bioloupe_package")

pubtator_url <- 'https://www.ncbi.nlm.nih.gov/research/pubtator-api/publications/export/pubtator?pmids='
scigraph_url <- 'https://api.monarchinitiative.org/api'
tagger_url <- 'https://www.ncbi.nlm.nih.gov/CBBresearch/Lu/Demo/RESTful/tmTool.cgi/'
