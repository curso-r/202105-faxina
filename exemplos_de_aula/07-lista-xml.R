# trabalhando com xml/html ------------------------------------------------

# função mágica do pacote {rvest}: html_table()

wiki_url <- "https://en.wikipedia.org/wiki/List_of_footballers_with_500_or_more_goals"
browseURL(wiki_url)
arquivo_temp_html <- fs::file_temp("goal_", ext = ".html")
r_wiki <- httr::GET(wiki_url, httr::write_disk(arquivo_temp_html, TRUE))

tabela_gols <- r_wiki %>% 
  xml2::read_html() %>%
  # nao se importe com isso por enquanto, 
  # mas isso é tipo uma "regex para html" 
  xml2::xml_find_first("//*[./span[@id='Ranking']]//following-sibling::table") %>%
  rvest::html_table()

# janitor::clean_names() é sua melhor amiga
tabela_gols %>% 
  janitor::clean_names()

# alternativa mais robusta: dplyr::rename_with()  

renomear_stringr <- function(coluna) {
  coluna %>% 
    stringr::str_replace(' ', "_") %>% 
    stringr::str_to_lower()
}

tabela_gols %>% 
  dplyr::rename_with(renomear_stringr)

# obs: internamente, o {janitor} usa janitor::make_clean_names()
# essa funcao tem alguns parametros uteis
renomear_janitor <- function(coluna) {
  janitor::make_clean_names(coluna)
}
tabela_gols %>% 
  dplyr::rename_with(renomear_janitor)

# html em lista -----------------------------------------------------------

# também é possível transformar um html em lista.
# nesse caso, você perde os poderes do xpath, mas ganha os poderes
# do {purrr} e do {rlist}

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

# exercicio para casa
arrumado <- ""


