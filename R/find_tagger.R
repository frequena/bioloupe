



text_input <- 'A kinetic model identifies phosphorylated estrogen receptor-a (ERa) as a critical regulator of ERa dynamics in breast cancer.'

post_text <-   POST(url = 'https://www.ncbi.nlm.nih.gov/CBBresearch/Lu/Demo/RESTful/tmTool.cgi/tmChem/Submit/',
       encode = 'json', body = list('sourcedb' = 'PubMed',
                                    'sourceid' = '1000001',
                                    'text' = text_input))


identifier_request <- content(post_text, as = 'text', encoding = 'UTF-8')


g <- GET(paste0('https://www.ncbi.nlm.nih.gov/CBBresearch/Lu/Demo/RESTful/tmTool.cgi/',
                identifier_request, '/Receive/'))

result <- fromJSON(content(g, as = 'text', encoding = 'UTF-8'))$denotations

result <- result %>%
  rownames_to_column() %>%
  mutate(obj = str_replace(obj, ':', '_')) %>%
  separate(col = obj, sep = '_', into = c('category', 'identifier')) %>%
  mutate(start = .data$span$begin,
         end = .data$span$end) %>%
  select(-rowname, -span) %>%
  mutate(term = paste0(strsplit(text_input, split = '')[[1]][start:end], collapse = '')) %>%
  select(term, category, identifier, start, end)
