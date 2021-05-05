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


# Limpeza com informações do cliente --------------------------------------

# Informação 2 - Sobre as séries mensais, o cliente informou que:
# 1) IDs podem ter início e fim distintos.
# 2) A série de meses de um ID não teve ter mês faltante entre seu início e seu fim, 
#    porém, em virtude de problemas técnicos, pode haver perda de informação no meio
#    do processo. Assim, nesses casos, orienta-se substituir o valor faltante pelo 
#    valor do mês anterior.

# Olhando o problema dos meses faltantes
indicadores_limpo %>%
  ggplot(aes(x = data, y = id, colour = id)) +
  geom_point(size = 5) 

# Solução: {padr} + {tidyr} (exemplo com o id 970)
indicadores_limpo %>%
  dplyr::filter(id == 970) %>%
  dplyr::arrange(data) %>%
  padr::pad(interval = "month", group = "id")

indicadores_limpo_com_pad <- indicadores_limpo  %>%
  padr::pad(interval = "month", group = "id")  

# padr::pad() consertou!
indicadores_limpo_com_pad %>%
  ggplot(aes(x = data, y = id, colour = id)) +
  geom_point(size = 5) 

# agora tem que preencher os NAs com fill.
indicadores_limpo_com_pad <- indicadores_limpo_com_pad %>%
  dplyr::arrange(id, data) %>%
  tidyr::fill(agendamento:cidade) %>%
  dplyr::mutate(
    # mes e ano não dá pra preencher com fill diretamente
    mes = as.character(lubridate::month(data)),
    ano = as.character(lubridate::year(data))
  )

indicadores_limpo_com_pad

dplyr::bind_rows(
  indicadores_limpo %>% dplyr::mutate(padded = "nao"),
  indicadores_limpo_com_pad %>% dplyr::mutate(padded = "sim")
) %>%
  ggplot(aes(x = data, y = alocacao, colour = padded)) +
  geom_point(size = 4, alpha = 0.2) +
  geom_line(size = 2) +
  facet_wrap(~id)
