% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_pubtator.R
\name{find_pubtator}
\alias{find_pubtator}
\title{Find entities using Pubtator API}
\usage{
find_pubtator(pmid, bioconcept = "all", raw_abstract = FALSE)
}
\arguments{
\item{pmid}{pmid}

\item{bioconcept}{bioconcept}

\item{raw_abstract}{raw_abstract}
}
\value{
the results from the search
}
\description{
Find entities using Pubtator API
}
\examples{
\dontrun{
find_pubtator(22894909, bioconcept = 'all')
}
}
