
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bioloupe

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

<!-- badges: end -->

## Installation

You can install the development version from Github.

``` r
# install.packages("devtools")
devtools::install_github("frequena/bioloupe")
```

## Overview

The package `bioloupe` provides an interface to:

  - [PubTator API](https://www.ncbi.nlm.nih.gov/research/pubtator/)
  - [Biolink API](https://api.monarchinitiative.org/api)

## Examples

### Find biomedical entities of PubMed titles and abstracts

``` r
library(bioloupe)

b <- find_pubtator(pmid = c(23819905, 23819906, 32220312), bioconcept = 'gene')

b[[2]]$dataframe
#> # A tibble: 13 x 8
#>    id       start   end word      category identifier color element 
#>    <chr>    <int> <int> <chr>     <chr>    <chr>      <chr> <chr>   
#>  1 23819906    31    36 CXCL9     Gene     246759     green title   
#>  2 23819906   240   245 CXCL9     Gene     246759     green abstract
#>  3 23819906   333   338 CXCL9     Gene     246759     green abstract
#>  4 23819906   512   517 CXCL9     Gene     246759     green abstract
#>  5 23819906   654   659 CXCL9     Gene     4283       green abstract
#>  6 23819906   669   675 rCXCL9    Gene     246759     green abstract
#>  7 23819906   932   938 rCXCL9    Gene     246759     green abstract
#>  8 23819906  1029  1038 TGF-beta1 Gene     59086      green abstract
#>  9 23819906  1043  1048 CXCR3     Gene     84475      green abstract
#> 10 23819906  1191  1196 CXCL9     Gene     246759     green abstract
#> 11 23819906  1349  1355 rCXCL9    Gene     246759     green abstract
#> 12 23819906  1398  1404 rCXCL9    Gene     246759     green abstract
#> 13 23819906  1588  1593 CXCL9     Gene     246759     green abstract
```

…or retrieve the result as HTML code:

``` r
b[[2]]$abstract_tagged
#> [1] Chemokines have been shown to play an important role in the pathogenesis of pancreatitis, but the role of chemokine <span style="color:green">CXCL9</span> in pancreatitis is poorly understood. The aim of this study was to investigate whether <span style="color:green">CXCL9</span> was a modulating factor in chronic pancreatitis. Chronic pancreatitis was induced in Sprague-Dawley rats by intraductal infusion of trinitrobenzene sulfonic acid (TNBS) and <span style="color:green">CXCL9</span> expression was assessed by immunohistochemistry, Western blot analysis and enzyme linked immunosorbent assay (ELISA). Recombinant human <span style="color:green">CXCL9</span> protein (<span style="color:green">rCXCL9</span>), neutralizing antibody and normal saline (NS) were administered to rats with chronic pancreatitis by subcutaneous injection. The severity of fibrosis was determined by measuring hydroxyproline in pancreatic tissues and histological grading. The effect of <span style="color:green">rCXCL9</span> on activated pancreatic stellate cells (PSCs) in vitro was examined and collagen 1alpha1, <span style="color:green">TGF-beta1</span> and <span style="color:green">CXCR3</span> expression was assessed by Western blot analysis in isolated rat PSCs. Chronic pancreatic injury in rats was induced after TNBS treatment and <span style="color:green">CXCL9</span> protein was markedly upregulated during TNBS-induced chronic pancreatitis. Although parenchymal injury in the pancreas was not obviously affected after <span style="color:green">rCXCL9</span> and neutralizing antibody administration, <span style="color:green">rCXCL9</span> could attenuate fibrogenesis in TNBS-induced chronic pancreatitis in vivo and exerted antifibrotic effects in vitro, suppressing collagen production in activated PSCs. In conclusion, <span style="color:green">CXCL9</span> is involved in the modulation of pancreatic fibrogenesis in TNBS-induced chronic pancreatitis in rats, and may be a therapeutic target in pancreatic fibrosis.
```

### Find biomedical entities from a text

#### Using SciGraph

``` r
abstract_input <- 'Marfan syndrome is a multisystemic genetic condition affecting connective tissue. It carries a reduced life expectancy, largely dependent on cardiovascular complications. More common cardiac manifestations such as aortic dissection and aortic valve incompetence have been widely documented in the literature. Mitral valve prolapse (MVP), however, has remained poorly documented. This article aims at exploring the existing literature on the pathophysiology and diagnosis of MVP in patients with Marfan syndrome, defining its current management and outlining the future developments surrounding it.'

result <- find_scigraph(text = abstract_input) 
result$content
#> # A tibble: 54 x 3
#>    word            category          identifier         
#>    <chr>           <chr>             <chr>              
#>  1 marfan syndrome disease           OMIA:000628-9913   
#>  2 marfan syndrome <NA>              KEGG-ds:H00653     
#>  3 syndrome        gene              NCBIGene:252800    
#>  4 marfan syndrome disease           MONDO:0007947      
#>  5 marfan syndrome disease           ORPHA:558          
#>  6 marfan syndrome disease           OMIA:000628        
#>  7 syndrome        gene              FlyBase:FBgn0003661
#>  8 marfan syndrome disease           OMIM:154700        
#>  9 affected        <NA>              HP:0032320         
#> 10 tissue          anatomical entity WBbt:0005729       
#> # … with 44 more rows
```
