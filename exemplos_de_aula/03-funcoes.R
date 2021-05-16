library(magrittr)

# {janitor} ---------------------------------------------------------------

# O janitor não tem apenas `janitor::clean_names()`. 
# Existem outras funções úteis que Utilizaremos ao longo dos exemplos.

# `janitor::remove_empty()`

# Remove linhas e colunas vazias. Possui os amigos 
# `janitor::remove_empty_cols()` e `janitor::remove_empty_rows()`

da <- tibble::tribble(
  ~a, ~b, ~c,
  NA, 10, NA,
  10, 10, NA,
  NA, NA, NA
)
janitor::remove_empty(da)
janitor::remove_empty(da, "rows")
janitor::remove_empty(da, "cols")

# `janitor::get_dupes()` 
# Identifica duplicatas de colunas.

da <- tibble::tribble(
  ~nome, ~papel, ~salario,
  "Athos", "Professor", 10,
  "Athos", "Consultor", 20,
  "Fernando", "Professor", 30
)

janitor::get_dupes(da)
janitor::get_dupes(da, nome)
janitor::get_dupes(da, nome, papel)

# `janitor::compare_df_cols()`

# Compara as colunas de 2 ou mais bases. Útil quando comparamos bases que 
# deveriam ter o mesmo formato. Também compara os tipos.

da_2020 <- tibble::tribble(
  ~ano, ~coluna_velha, ~salario,
  "2020", "olar", 10,
)
da_2021 <- tibble::tribble(
  ~ano, ~coluna_nova, ~salario,
  2021, "olar", 10,
)

janitor::compare_df_cols(da_2020, da_2021) %>% 
  dplyr::filter(da_2020 != da_2021 | is.na(da_2021) | is.na(da_2020))

da_2020 %>% 
  dplyr::mutate(ano = as.numeric(ano)) %>% 
  dplyr::rename(coluna_nova = coluna_velha) %>% 
  dplyr::bind_rows(da_2021)

# `janitor::adorn_totals()`

# Adiciona totais nas linhas ou colunas de uma tabela. Útil para depois de 
# fazer um sumário. Combina com `janitor::tabyl()`, que também pode ser útil 
# para sumários rápidos.

sumario <- tibble::tribble(
  ~nome, ~papel, ~n, ~prop,
  "Julio", "Professor", 20, .1,
  "Fernando", "Professor", 40, .2,
  "Athos", "Professor", 60, .3,
  "Athos", "Consultor", 80, .4,
)

resultado <- janitor::adorn_totals(sumario, "row") %>% 
  tibble::as_tibble()

abjData::muni %>% tibble::view()

# m <- lm(cyl ~ disp, data = mtcars)
# broom::tidy(m)

# ideia louca, mas interessante
# por democracia, a ideia é util :)

sumario %>% 
  dplyr::group_by(nome) %>% 
  tidyr::nest() %>% 
  dplyr::ungroup() %>% 
  dplyr::mutate(data = purrr::map(data, janitor::adorn_totals, "row")) %>% 
  tidyr::unnest(data)

sumario %>% 
  dplyr::group_by(nome) %>% 
  tidyr::nest() %>% 
  dplyr::ungroup()


# `{tidyr}` e `{dplyr}` ---------------------------------------------------


# As funções a seguir podem te salvar muito código!

# Não esqueça também de usar `across()`, `case_when()`, `separate()` e `unite()` 
# que já foram discutidos no curso de R para ciência de dados II.


# `dplyr::na_if()`
# Substitui por `NA` se bater alguma condição.

vetor <- c("julio", "athos", "fernando", "vazio")
dplyr::na_if(vetor, "vazio")
dplyr::if_else(vetor %in% c("vazio", "-"), NA_character_, vetor)

# otimista
ifelse(vetor %in% c("vazio", "-"), NA, vetor)
# pessimista
dplyr::if_else(vetor %in% c("vazio", "-"), NA, vetor)

# `tidyr::replace_na()`
# Preenche `NA`s de um vetor ou de uma base

vetor <- c("julio", "athos", "fernando", NA)
tidyr::replace_na(vetor, "vazio")

da <- tibble::tribble(
  ~col1, ~col2,
  NA, "Julio",
  "Fernando", NA,
  "Julio", "Caio",
  NA, NA
)

da %>% 
  tidyr::replace_na(list(col1 = "vazio", col2 = "NULL"))

arruma_coluna <- function(.x) {
  tidyr::replace_na(.x, "vazio")
}

da %>% 
  dplyr::mutate(
    dplyr::across(
      dplyr::everything(),
      dplyr::na_if, "Julio"
    )
  )

## with()
# da %>% 
#   with(table(col1))

# "recipes"

# `dplyr::coalesce()`
# Pega o primeiro valor não vazio. Útil para joins / correção de base.

da <- tibble::tribble(
  ~col1, ~col2,
  NA, "Julio",
  "Fernando", NA,
  "Julio", "Caio", # cuidado!
  NA, NA
)
da %>% 
  dplyr::mutate(
    col_arrumada = dplyr::coalesce(col1, col2)
  )

# `tidyr::fill()`
# Preenche `NA`, para baixo ou para cima

da <- tibble::tribble(
  ~id, ~col1, ~col2,
  1, NA, "Julio",
  1, "Fernando", NA,
  2, NA, NA,
  2, "Julio", "Caio", # cuidado!
  2, NA, NA
)

da %>% 
  dplyr::group_by(id) %>% 
  tidyr::fill(col1, col2, .direction = "updown") %>% 
  dplyr::ungroup()

da %>% 
  tidyr::fill(col1, col2)


da %>% 
  tidyr::fill(col1, col2)

da %>% 
  tidyr::fill(col1, col2, .direction = "updown")

# `tidyr::drop_na()`
# Retira linhas com `NA` da base

da <- tibble::tribble(
  ~col1, ~col2,
  NA, "Julio",
  "Fernando", NA,
  "Julio", "Caio", # cuidado!
  NA, NA
)
da %>% 
  tidyr::drop_na()

da %>% 
  tidyr::drop_na(col1)

# `tidyr::complete()`
# Completa uma base com combinações faltantes

da <- tibble::tribble(
  ~ano, ~categoria, ~valor,
  "2020", "A", 1,
  "2021", "A", 2,
  "2021", "B", 3
)
da %>% 
  tidyr::complete(
    ano, categoria, 
    fill = list(valor = 100)
  )


# `tidyr::unnest()`
# Serve para lidar com bases cuja coluna é uma __lista__ de vetores/data.frames

# https://www.tidyverse.org/blog/2019/09/tidyr-1-0-0/#nesting

da <- tibble::tibble(
  coluna_normal = c(1, 2),
  coluna_tabela = tibble::tibble(a = c(3, 4), b = c(5, 6))
)
da

str(da)
print(da)
names(da)
tidyr::unnest(da, coluna_tabela)

da <- tibble::tibble(
  coluna_normal = c(1, 2),
  coluna_tabela = list(
    tibble::tibble(a = c(3), b = c(5)),
    tibble::tibble(a = c(4), b = c(6))
  )
)
str(da)
tidyr::unnest(da, coluna_tabela)

tibble::view(da)

# `dplyr::anti_join()`
# Mostra as linhas da base da esquerda que não estão na base da direita. 
# Ideal para arrumar joins de base

da1 <- tibble::tribble(
  ~municipio, ~valor1,
  "Mogi", 1,
  "Osasco", 2
)
da2 <- tibble::tribble(
  ~municipio, ~valor2,
  "Mogi-Mirim", 1,
  "Osasco", 2
)

# lista de dados para arrumar
da1 %>% 
  dplyr::anti_join(da2, "municipio")

# agora deu bom!
da1 %>% 
  dplyr::mutate(municipio = dplyr::case_when(
    municipio == "Mogi" ~ "Mogi-Mirim",
    # ...
    TRUE ~ municipio
  )) %>% 
  dplyr::anti_join(da2, "municipio")

abjutils::rm_accent("ááá")
