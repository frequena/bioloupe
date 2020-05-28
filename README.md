
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

find_pubtator(pmid = 22894909, output = 'dataframe')
#> # A tibble: 20 x 6
#>    pmid     start end   word     category identifier
#>    <chr>    <chr> <chr> <chr>    <chr>    <chr>     
#>  1 22894909 70    75    human    Species  9606      
#>  2 22894909 270   276   humans   Species  9606      
#>  3 22894909 281   285   mice     Species  10090     
#>  4 22894909 683   688   human    Species  9606      
#>  5 22894909 901   904   IPW      Gene     3653      
#>  6 22894909 906   911   GRB10    Gene     2887      
#>  7 22894909 913   919   INPP5F   Gene     22876     
#>  8 22894909 924   930   ZNF597   Gene     146434    
#>  9 22894909 1079  1083  ZFAT     Gene     57623     
#> 10 22894909 1085  1093  ZFAT-AS1 Gene     594840    
#> 11 22894909 1095  1100  GLIS3    Gene     169792    
#> 12 22894909 1102  1105  NTM      Gene     50863     
#> 13 22894909 1107  1112  MAGI2    Gene     9863      
#> 14 22894909 1125  1131  LIN28B   Gene     389421    
#> 15 22894909 1229  1234  mouse    Species  10090     
#> 16 22894909 1256  1261  Magi2    Gene     50791     
#> 17 22894909 1295  1299  ZFAT     Gene     57623     
#> 18 22894909 1356  1364  ZFAT-AS1 Gene     594840    
#> 19 22894909 1430  1434  ZFAT     Gene     57623     
#> 20 22894909 1692  1698  humans   Species  9606
```

…or retrieve the result as HTML code:

``` r

find_pubtator(pmid = 32220312, output = 'html')
#> [1] During <span style="color:lime">human</span> evolution, the knee adapted to the biomechanical demands of bipedalism by altering chondrocyte developmental programs. This adaptive process was likely not without deleterious consequences to health. Today, <span style="color:red">osteoarthritis</span> occurs in 250 million <span style="color:lime">people</span>, with risk variants enriched in non-coding sequences near chondrocyte genes, loci that likely became optimized during knee evolution. We explore this relationship by epigenetically profiling joint chondrocytes, revealing ancient selection and recent constraint and drift on knee regulatory elements, which also overlap <span style="color:red">osteoarthritis</span> variants that contribute to disease heritability by tending to modify constrained functional sequence. We propose a model whereby genetic violations to regulatory constraint, tolerated during knee development, lead to adult pathology. In support, we discover a causal enhancer variant (<span style="color:orange">rs6060369</span>) present in billions of <span style="color:lime">people</span> at a risk locus (<span style="color:green">GDF5</span>-<span style="color:green">UQCC1</span>), showing how it impacts <span style="color:lime">mouse</span> knee-shape and <span style="color:red">osteoarthritis</span>. Overall, our methods link an evolutionarily novel aspect of <span style="color:lime">human</span> anatomy to its pathogenesis.
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
