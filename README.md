
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

  - [NCBI Text Mining Web
    Services](https://www.ncbi.nlm.nih.gov/research/bionlp/APIs/)
      - [PubTator
        API](https://www.ncbi.nlm.nih.gov/research/pubtator/)
      - [TaggerOne](https://www.ncbi.nlm.nih.gov/research/bionlp/Tools/taggerone/)
  - [Biolink API](https://api.monarchinitiative.org/api)

## Examples

### Find biomedical entities from the abstract of a PMID

``` r
library(bioloupe)

b <- find_pubtator(pmid = c(23819905, 23819906, 32220312))


b[[2]]$abstract_tagged
#> [1] Chemokines have been shown to play an important role in the pathogenesis of <span style="color:red">pancreatitis</span>, but the role of chemokine <span style="color:green">CXCL9</span> in <span style="color:red">pancreatitis</span> is poorly understood. The aim of this study was to investigate whether <span style="color:green">CXCL9</span> was a modulating factor in chronic <span style="color:red">pancreatitis</span>. Chronic <span style="color:red">pancreatitis</span> was induced in <span style="color:lime">Sprague-Dawley rats</span> by intraductal infusion of <span style="color:blue">trinitrobenzene sulfonic acid</span> (TNBS) and <span style="color:green">CXCL9</span> expression was assessed by immunohistochemistry, Western blot analysis and enzyme linked immunosorbent assay (ELISA). Recombinant <span style="color:lime">human</span> <span style="color:green">CXCL9</span> protein (<span style="color:green">rCXCL9</span>), neutralizing antibody and normal saline (NS) were administered to <span style="color:lime">rats</span> with chronic <span style="color:red">pancreatitis</span> by subcutaneous injection. The severity of <span style="color:red">fibrosis</span> was determined by measuring <span style="color:blue">hydroxyproline</span> in pancreatic tissues and histological grading. The effect of <span style="color:green">rCXCL9</span> on activated pancreatic stellate cells (PSCs) in vitro was examined and collagen 1alpha1, <span style="color:green">TGF-beta1</span> and <span style="color:green">CXCR3</span> expression was assessed by Western blot analysis in isolated <span style="color:lime">rat</span> PSCs. <span style="color:red">Chronic pancreatic injury</span> in <span style="color:lime">rats</span> was induced after TNBS treatment and <span style="color:green">CXCL9</span> protein was markedly upregulated during TNBS-induced <span style="color:red">chronic pancreatitis</span>. Although <span style="color:red">parenchymal injury in the pancreas</span> was not obviously affected after <span style="color:green">rCXCL9</span> and neutralizing antibody administration, <span style="color:green">rCXCL9</span> could attenuate fibrogenesis in <span style="color:red">TNBS-induced chronic pancreatitis</span> in vivo and exerted antifibrotic effects in vitro, suppressing collagen production in activated PSCs. In conclusion, <span style="color:green">CXCL9</span> is involved in the modulation of pancreatic fibrogenesis in <span style="color:red">TNBS-induced chronic pancreatitis</span> in <span style="color:lime">rats</span>, and may be a therapeutic target in <span style="color:red">pancreatic fibrosis</span>.
```

…or retrieve the result as HTML code:

``` r


b[[2]]$dataframe
#> # A tibble: 36 x 7
#>    pmid     start   end word                     category identifier  color
#>    <chr>    <int> <int> <chr>                    <chr>    <chr>       <chr>
#>  1 23819906    31    36 CXCL9                    Gene     246759      green
#>  2 23819906    61    73 pancreatitis             Disease  MESH:D0101… red  
#>  3 23819906    85   114 trinitrobenzene sulfoni… Chemical MESH:D0143… blue 
#>  4 23819906   118   122 rats                     Species  10116       lime 
#>  5 23819906   200   212 pancreatitis             Disease  MESH:D0101… red  
#>  6 23819906   240   245 CXCL9                    Gene     246759      green
#>  7 23819906   249   261 pancreatitis             Disease  MESH:D0101… red  
#>  8 23819906   333   338 CXCL9                    Gene     246759      green
#>  9 23819906   374   386 pancreatitis             Disease  MESH:D0101… red  
#> 10 23819906   396   408 pancreatitis             Disease  MESH:D0101… red  
#> # … with 26 more rows
```

### Find biomedical entities from a text

#### Using NCBI Text Mining Web Services

#### Using SciGraph

``` r

abstract_input <- 'Marfan syndrome is a multisystemic genetic condition affecting connective tissue. It carries a reduced life expectancy, largely dependent on cardiovascular complications. More common cardiac manifestations such as aortic dissection and aortic valve incompetence have been widely documented in the literature. Mitral valve prolapse (MVP), however, has remained poorly documented. This article aims at exploring the existing literature on the pathophysiology and diagnosis of MVP in patients with Marfan syndrome, defining its current management and outlining the future developments surrounding it.'

result <- find_scigraph(text = abstract_input) 

result$content
#> # A tibble: 3 x 3
#>   name              id             category             
#>   <chr>             <chr>          <chr>                
#> 1 "\"Tissue"        WBbt:0005729   anatomical entity    
#> 2 connective tissue UBERON:0002384 anatomical entity    
#> 3 tissue            UBERON:0000479 "anatomical entity\""
```
