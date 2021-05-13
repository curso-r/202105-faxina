library(magrittr)

# Base da receita federal -------------------------------------------------

# Link: https://bit.ly/3jC3KGj

# Baixe e descompacte o arquivo na pasta "dados/" do material

path <- "dados/csv_dados_qsa_cnpj_23-11-20/cnpj_dados_cadastrais_pj.csv"

## nosso objetivo é contar quantas empresas temos por UF e situacao cadastral.
## esse problema faz parte da classe de problemas de "big data" que na verdade
## são vários problemas de "small data" consecutivos

## NAO RODE
# da_rfb_fail <- readr::read_csv(path)
# da_rfb_fail <- data.table::fread(path)

# um teste
readr::read_lines(path, n_max = 10)

# separador é #. Vamos tentar ler só 10000 linhas

dados <- readr::read_delim(path, delim = "#", n_max = 10000)

# opa, deu ruim. Parece que precisamos ver o guess_max

dados <- readr::read_delim(path, delim = "#", n_max = 10000, guess_max = 10000)

# ótimo, leu bonitinho. Se eu quiser resolver o problema para esses 10000 casos:

dados %>% 
  dplyr::count(situacao_cadastral, uf)
# obs: de 10 mil foi pra 77 linhas

# vamos colocar isso em uma função:

sumarizar <- function(dados) {
  dados %>% 
    dplyr::count(situacao_cadastral, uf)
}

# Como eu faço para ler tudo?

# alternativa 1: usando readr ---------------------------------------------

callback <- readr::DataFrameCallback$new(sumarizar)

dados_chunked_fail <- readr::read_delim_chunked(
  path, 
  delim = "#",
  callback, 
  guess_max = 10000
)

# meh. nao deu. Vamos redefinir a função com um parametro a mais

sumarizar_2args <- function(dados, pos) {
  dados %>% 
    dplyr::count(situacao_cadastral, uf)
}

callback_2args <- readr::DataFrameCallback$new(sumarizar_2args)

dados_chunked <- readr::read_delim_chunked(
  path, 
  delim = "#",
  callback_2args, 
  guess_max = 10000
)

# legal! agora preciso sumarizar para obter as contagens finais

resultado <- dados_chunked %>% 
  dplyr::group_by(situacao_cadastral, uf) %>% 
  dplyr::summarise(n = sum(n), .groups = "drop")

# alternativa
resultado <- dados_chunked %>% 
  dplyr::group_by(situacao_cadastral, uf) %>% 
  dplyr::tally(n) %>% 
  dplyr::ungroup()

# alternativa 2: usando vroom ---------------------------------------------

## quer ter mais controle sobre o que você está fazendo?
## codigo adaptado daqui: https://github.com/jtrecenti/vacinaBrasil/blob/master/data-raw/datasus.R


n_rows <- length(vroom::vroom_lines(path)) - 1L
# tamanho de cada chunk (1 milhao)
chunk_size <- 1e6
# quantos chunks?
n_chunks <- ceiling(n_rows / chunk_size)
# vetor de pulos
skips <- chunk_size * seq(0, n_chunks - 1) + 1

# colunas que desejo trabalhar
colunas <- c(
  "situacao_cadastral",
  "uf"
)

estrutura_dados <- vroom::vroom(path, n_max = 100, delim = "#", col_types = "")
nm <- names(estrutura_dados)

# especificando colunas
colunas_spec <- rep("_", length(nm))
colunas_spec[nm %in% colunas] <- "c"
colunas_spec <- paste(colunas_spec, collapse = "")

## exemplo:
vroom::vroom(path, n_max = 100, delim = "#", col_types = colunas_spec)

sumarizar_vroom <- function(skip, path, chunk_size, colunas_spec, colunas) {
  message(skip)
  dados <- vroom::vroom(
    file = path,
    delim = "#",
    skip = skip,
    n_max = chunk_size,
    col_types = colunas_spec,
    col_names = FALSE,
    progress = FALSE
  )
  dados %>%
    purrr::set_names(colunas) %>% 
    dplyr::count(situacao_cadastral, uf)
}

dados_chunked <- purrr::map_dfr(
  skips, 
  sumarizar_vroom, 
  path, 
  chunk_size, 
  colunas_spec,
  colunas
)

resultado <- dados_chunked %>% 
  dplyr::group_by(situacao_cadastral, uf) %>% 
  dplyr::tally(n) %>% 
  dplyr::ungroup()

## mapinha :)

gg <- resultado %>% 
  dplyr::mutate(
    uf = forcats::fct_reorder(uf, n, sum),
    situacao_cadastral = forcats::fct_reorder(situacao_cadastral, n, sum)
  ) %>% 
  ggplot2::ggplot(ggplot2::aes(n, uf, fill = situacao_cadastral)) +
  ggplot2::geom_col()

gg

# perfumaria
gg +
  ggplot2::scale_fill_viridis_d(option = "A", begin = .2, end = .8) +
  ggplot2::scale_x_continuous(labels = scales::number) +
  ggplot2::theme_minimal(12) +
  ggplot2::labs(x = "Quantidade", y = "UF", fill = "Situação") +
  ggplot2::guides(fill = ggplot2::guide_legend(reverse = TRUE)) +
  ggplot2::theme(legend.position = c(.9,.5))

## GG!

# outras alternativas (apenas comentando): 
# {disk.frame}, {arrow}, {RSQLite}, {bigrquery} ------

