library(magrittr)

# Exercicio 1 -------------------------------------------------------------

wiki_url <- "https://en.wikipedia.org/wiki/List_of_footballers_with_500_or_more_goals"
arquivo_temp_html <- fs::file_temp("goal_", ext = ".html")
r_wiki <- httr::GET(wiki_url, httr::write_disk(arquivo_temp_html, TRUE))

# alternativa 1
tabela_gols <- r_wiki %>% 
  xml2::read_html() %>%
  xml2::xml_find_first("//*[./span[@id='Ranking']]//following-sibling::table") %>%
  rvest::html_table()

objetivo <- tabela_gols %>% 
  janitor::clean_names()

# alternativa 2
lista_gols <- r_wiki %>% 
  xml2::read_html() %>% 
  xml2::as_list()

linhas <- lista_gols %>% 
  # eu achei isso aqui caçando no html do site
  # /html/body/div[3]/div[3]/div[5]/div[1]/table[2]
  purrr::pluck("html", "body", 5, 10, 14, 1, 18, "tbody") %>% 
  purrr::set_names(seq_along(.))

empilhado <- linhas %>% 
  # operacao dificil!
  purrr::map_dfr(~tibble::enframe(as.character(unlist(.x))), .id = "linha") %>% 
  dplyr::mutate(value = stringr::str_squish(value))

espalhado <- empilhado %>% 
  tidyr::pivot_wider(
    names_from = name, values_from = value,
    names_sep = "_"
  )


# Exercício (desafio): A partir da base `espalhado`, 
# escreva um script que chega na base `objetivo`.

