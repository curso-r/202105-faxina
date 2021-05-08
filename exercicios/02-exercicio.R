library(magrittr)
library(ggplot2)

# Exercício 2 -------------------------------------------------------------

path_excel <- "dados/dados_consultoria.xlsx"

abas <- readxl::excel_sheets(path_excel)

le_uma_aba <- function(aba) {
  readxl::read_excel(path_excel, sheet = aba, skip = 1) %>%
    dplyr::mutate(cidade = aba)
}

indicadores <- purrr::map_dfr(abas, le_uma_aba)

loc <- readr::locale(decimal_mark = ",")

indicadores_limpo <- indicadores %>%
  # limpa nomes das colunas
  janitor::clean_names() %>%
  dplyr::mutate(
    # porcentagem de texto para número
    dplyr::across(
      dplyr::starts_with("percent_"),
      readr::parse_number, locale = loc
    ) / 100,
    # ano mes para data
    data = lubridate::ymd(paste0(ano, mes, "01", sep = "-")),
    # id para texto
    id = as.character(id)
  ) %>%
  # retira "percent", numeros e underlines dos nomes
  dplyr::rename_with(~stringr::str_remove_all(., "percent|[0-9_]"))

# Exercício 2 - Sobre os IDs, o cliente informou que deveria ter apenas uma
# linha para cada trinca (id-ano-mes).

# Por conta de uma inconsistência, poderia acontecer de virem duas ou mais
# linhas para o mesma trinca (id-ano-mes).

# O correto é ter apenas uma linha apenas. Eles disseram que a linha com o
# maior valor de agendamento tem mais chance de ser a correta.

# a) retire as duplicatas

# b) quais combinações de id-ano-mês nós temos?
