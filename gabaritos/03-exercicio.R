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

# Julio: minha estratégia foi fazer algumas funções auxiliares que identificam
# o padrão do valor. Dessa forma não importa muito em qual coluna a
# informação aparecia.
# Claro que podem existir soluções diferentes dessa, e talvez até melhores!

pegar_nome <- function(x) {
  # aqui eu peguei o indice, pois se retirasse o acento
  # e usasse str_extract() iria ficar diferente do objetivo
  indice_nome <- x %>%
    abjutils::rm_accent() %>%
    # pega tudo que começa com uma letra maiúscula e depois uma minuscula
    stringr::str_detect("^[A-Z][a-z].+") %>%
    which()
  x[indice_nome]
}
pegar_ratio <- function(x) {
  x %>%
    # pega tudo que começa com 0 ou 1, seguido de um ponto
    # ou ao inves do ponto, acaba (1 caso escroto)
    stringr::str_extract("^[01](\\..*|$)") %>%
    na.omit() %>%
    as.numeric()
}
pegar_anos <- function(x) {
  # limpando o anos
  x %>%
    # note que podem ter 2 tipos de traços...
    stringr::str_extract("^[0-9]{4}[-–].+") %>%
    na.omit() %>%
    as.character()
}
pegar_numeros <- function(x) {
  x %>%
    # sao 2 numeros, entao considero a ordem em que eles aparecem
    # pode ou não começar com um "+"
    stringr::str_extract("^\\+?[0-9]{2,}$") %>%
    na.omit() %>%
    # transforma em numero, retirando o "+" se houver
    readr::parse_number()
}


exercicio <- espalhado %>%
  # tira primeira linha dos títulos
  dplyr::slice(-1) %>%
  # linha em numérico para ficar ordenado quando der group_by()
  dplyr::mutate(linha = as.numeric(linha)) %>%
  janitor::clean_names() %>%
  # empilhando todos os dados, exceto pela linha e pelo rank (x1)
  tidyr::pivot_longer(-c(linha, x1)) %>%
  dplyr::group_by(linha) %>%
  dplyr::summarise(
    # preenche vazio com NA no rank e transforma em numero
    rank = as.integer(dplyr::na_if(dplyr::first(x1), "")),
    # aplica funcao de pegar nome
    player = pegar_nome(value),
    # pega primeiro numero
    total_goals = pegar_numeros(value)[1],
    # pega segundo numero
    total_matches = pegar_numeros(value)[2],
    # pega a razão gols/jogos
    ratio = pegar_ratio(value),
    # pega os anos
    years = pegar_anos(value),
    .groups = "drop"
  ) %>%
  # preenche os ranks vazios
  tidyr::fill(rank) %>%
  dplyr::select(-linha)

# verifica se deu certo!
all.equal(objetivo, exercicio)

