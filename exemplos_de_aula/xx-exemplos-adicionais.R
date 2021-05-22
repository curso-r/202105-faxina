# https://github.com/curso-r/202105-faxina/tree/master/dados

arruma_coluna_json <- function(x){
  x %>%
    str_remove_all(regex('"')) %>%
    str_remove_all(regex('[{]current:')) %>%
    str_remove_all(regex('previous:[}]')) %>%
    str_remove_all(regex("[}{]"))
}

# para mim funcionou:
report <- readr::read_csv2("dados/ReporteReimpresion-Mayo.csv") %>%
  mutate(
    codigo_json = arruma_coluna_json(codigo_json)
  ) %>%
  tidyr::separate(codigo_json, into = c("doc_type", "group_id"), sep = ",",
                  extra = "merge")

# sugestão do Theo:

report2 <- readr::read_csv2(
  "dados/ReporteReimpresion-Mayo.csv",
  locale = locale(encoding = 'ASCII'),
  col_types = cols(
    .default = col_character(),
    Fecha = col_skip(),
    `ID de Recurso` = col_skip()
  ))


indicador <- tibble(
  ano = 2020,
  idade = c(0, 1, 2, 3, 4),
  indicador = c(.2, .4, .5, .3, .2)
)

cidade <- tibble(
  ano = 2020,
  cidade = rep(c("SP", "RJ"), each = 5),
  idade = c(0, 1, 2, 3, 4, 0, 1, 2, 3, 4),
  populacao = rep(c(1000, 2000), each = 5)
)

# jeito 1: join

cidade %>%
  left_join(indicador) %>%
  mutate(
    conta_final = populacao*indicador
  )
