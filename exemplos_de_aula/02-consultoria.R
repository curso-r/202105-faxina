library(magrittr)
library(ggplot2)

# Importação --------------------------------------------------------------

path_excel <- "dados/dados_consultoria.xlsx"

abas <- readxl::excel_sheets(path_excel)

le_uma_aba <- function(aba) {
  readxl::read_excel(path_excel, sheet = aba, skip = 1) %>%
    dplyr::mutate(cidade = aba)
}

le_uma_aba("Campos do Jordão")

indicadores <- purrr::map_dfr(abas, le_uma_aba)

dplyr::glimpse(indicadores)

# Limpeza geral -----------------------------------------------------------------

loc <- readr::locale(decimal_mark = ",")
indicadores_limpo <- indicadores %>%
  # limpa nomes das colunas
  janitor::clean_names() %>%
  dplyr::mutate(
    # porcentagem de texto para número
    dplyr::across(dplyr::starts_with("percent_"), readr::parse_number, locale = loc)/100,
    # ano mes para data
    data = lubridate::ymd(paste0(ano, mes, "01", sep = "-")),
    # id para texto
    id = as.character(id)
  ) %>%
  # retira "percent", numeros e underlines dos nomes
  dplyr::rename_with(~stringr::str_remove_all(., "percent|[0-9_]"))
