library(magrittr)

# import ------------------------------------------------------------------

## http://dados.mj.gov.br/dataset/8ff7032a-d6db-452b-89f1-d860eb6965ff/resource/c2cce323-24c2-4430-8918-e24b2966213c/download/crf2019-dados-abertos.zip
# Baixe e descompacte o arquivo na pasta "dados/" do material

path <- "dados/crf2019-dados-abertos/CRF2019 Dados Abertos.csv"

# claro que vai dar problema
da_sindec <- readr::read_csv2(path)

# quais problemas?
problemas <- readr::problems(da_sindec)
problemas %>% 
  tibble::view()

# vamos ver as linhas
linhas <- readr::read_lines(path)
linhas_bugadas <- linhas[problemas$row + 1]
stringr::str_count(linhas_bugadas, ";")

# GATO NET!!!!
# com espaço
stringr::str_count(linhas_bugadas, "; ")
stringr::str_count(linhas_bugadas, ";") - stringr::str_count(linhas_bugadas, "; ")

# tivemos sorte! nem sempre é assim, mas segue o jogo

linhas[problemas$row + 1] <- stringr::str_remove_all(linhas[problemas$row + 1], "; ")

da_sindec <- linhas %>% 
  paste(collapse = "\n") %>% 
  readr::read_csv2() %>% 
  janitor::clean_names()

da_sindec %>% 
  dplyr::slice(problemas$row + 1) %>% View


# tidy --------------------------------------------------------------------

tibble::glimpse(da_sindec)

## Nosso objetivo será construir um dashboard com 4 visualizações:

# (aquecimento) 1. um grafico de barras de faixa etaria e sexo
# (tranquilo) 2. um mapa de % atendida por uf
# (trabalhoso) 3. um grafico de barras de assuntos mais frequentes
# (fogo no parquinho) 3. um grafico de barras de assuntos mais frequentes

# 1. um grafico de barras de faixa etaria e sexo

da_sindec %>% 
  dplyr::count(faixa_etaria_consumidor, sexo_consumidor)

contagem_sexo_faixa <- da_sindec %>% 
  dplyr::transmute(
    sexo = dplyr::case_when(
      sexo_consumidor %in% c("N", "NULL") ~ NA_character_,
      TRUE ~ sexo_consumidor
    ),
    faixa = dplyr::na_if(faixa_etaria_consumidor, "Nao Informada")
  ) %>% 
  dplyr::count(sexo, faixa)

gg_sexo_faixa <- contagem_sexo_faixa %>% 
  dplyr::mutate(
    faixa = forcats::fct_rev(faixa),
    faixa = forcats::fct_explicit_na(faixa, "(Vazio)")
  ) %>% 
  ggplot2::ggplot(ggplot2::aes(n, faixa, fill = sexo)) +
  ggplot2::geom_col(position = "dodge")

gg_sexo_faixa

# 2. um mapa de % atendida por uf

atendimento_uf <- da_sindec %>% 
  dplyr::group_by(uf) %>% 
  dplyr::summarise(p_atendida = mean(atendida == "S"))

map_uf <- geobr::read_state()
gg_mapa <- map_uf %>% 
  dplyr::left_join(atendimento_uf, c("abbrev_state" = "uf")) %>% 
  ggplot2::ggplot() +
  ggplot2::geom_sf(ggplot2::aes(fill = p_atendida), colour = "black", size = .2)


# 3. um grafico de barras de assuntos mais frequentes

da_sindec %>% 
  dplyr::count(descricao_assunto, sort = TRUE) %>% 
  print(n = 50)

# muitas categorias. Vamos reclassificar? VAMOS!

lista_regex <- list(
  tel = c("Telef"),
  casa = c("TV", "Televis", "Fogão", "Lavar Roupa", "M[oó]ve[il]",
           "Aquecedor", "Eletro", "Barbead", "Colch", "Vestu", " Som",
           "Ferramenta"),
  veiculo = c("Carro", "Moto"),
  escola = c("Escola", "Curso"),
  banco = c("Banco", "Financ", "Seguro", "Crédit", "Capital"),
  essencial = c("Água", "Energia", "Internet"),
  contrato = c("Contrato"),
  servico = c("Servi", "Assist", "Instala")
) %>% 
  # cola com "ou"
  purrr::map(stringr::str_c, collapse = "|") %>% 
  # transforma em regex
  purrr::map(stringr::regex, ignore_case = TRUE)

contagem_tema <- da_sindec %>% 
  dplyr::mutate(tema = dplyr::case_when(
    stringr::str_detect(descricao_assunto, lista_regex$tel) ~ "Telefone",
    stringr::str_detect(descricao_assunto, lista_regex$casa) ~ "Casa",
    stringr::str_detect(descricao_assunto, lista_regex$veiculo) ~ "Veículo",
    stringr::str_detect(descricao_assunto, lista_regex$banco) ~ "Banco/Financeiro",
    stringr::str_detect(descricao_assunto, lista_regex$essencial) ~ "Serviços Essenciais",
    stringr::str_detect(descricao_assunto, lista_regex$servico) ~ "Outros serviços",
    TRUE ~ "Outros"
  )) %>% 
  dplyr::count(tema, sort = TRUE)

gg_tema <- contagem_tema %>% 
  dplyr::mutate(
    tema = forcats::fct_reorder(tema, n),
    tema = forcats::fct_relevel(tema, "Outros", after = 0L)
  ) %>% 
  ggplot2::ggplot(ggplot2::aes(n, tema)) +
  ggplot2::geom_col()

# ainda tem muito a melhorar, mas vamos seguir.

# 4. uma tabela % atendida por natureza
 
# precisamos juntar a base do sindec com a base da rfb. E agora? kkkkrying

da_sindec_empresas <- da_sindec %>% 
  dplyr::select(str_razao_social, numero_cnpj, atendida) %>% 
  dplyr::mutate(
    cnpj = dplyr::na_if(numero_cnpj, "NULL"),
    cnpj = stringr::str_pad(cnpj, 14, "left", "0")
  )

da_empresa_cnpj <- da_sindec_empresas %>% 
  dplyr::filter(!is.na(cnpj)) %>% 
  dplyr::distinct(cnpj, .keep_all = TRUE)

da_empresa_nm <- da_sindec_empresas %>% 
  dplyr::filter(is.na(cnpj)) %>% 
  dplyr::count(str_razao_social, sort = TRUE)

# vamos tentar recuperar o cnpj na própria base

da_empresa_nm %>% 
  dplyr::anti_join(da_empresa_cnpj, "str_razao_social")

# aff... vamos tentar fazer uma limpeza

limpar <- function(x) {
  x <- x %>% 
    toupper() %>% 
    abjutils::rm_accent() %>% 
    stringr::str_remove_all("[^A-Z ]") %>% 
    stringr::str_replace_all(" S A", " SA") %>% 
    stringr::str_squish()
  
  # da pra adicionar outras coisas aqui
  dplyr::case_when(
    stringr::str_detect(x, "ELETROPAULO") ~ "ELETROPAULO",
    TRUE ~ x
  )
}

aux_cnpj_limpo <- da_empresa_cnpj %>% 
  dplyr::mutate(str_razao_social = limpar(str_razao_social))

da_empresa_nm %>% 
  dplyr::mutate(str_razao_social = limpar(str_razao_social)) %>% 
  dplyr::anti_join(aux_empresa_limpo, "str_razao_social")

# melhorou um pouco, mas nao muito. Vamos usar {fuzzyjoin}!

resultado <- da_empresa_nm %>% 
  dplyr::mutate(str_razao_social = limpar(str_razao_social)) %>% 
  dplyr::anti_join(aux_empresa_limpo, "str_razao_social") %>% 
  fuzzyjoin::stringdist_anti_join(
    aux_empresa_limpo, 
    "str_razao_social", 
    max_dist = 5
  )

sum(resultado$n)

# melhorou bastante!

join <- da_empresa_nm %>% 
  dplyr::mutate(str_razao_social = limpar(str_razao_social)) %>% 
  fuzzyjoin::stringdist_left_join(
    aux_empresa_limpo, 
    "str_razao_social", 
    max_dist = 5, 
    distance_col = "dist"
  )

# mas tem um custo... alguns ficaram ruins. Mas vida que segue
# agora vamos juntar tudo

aux_juntar <- join %>% 
  dplyr::arrange(dist) %>% 
  dplyr::select(str_razao_social = str_razao_social.x, cnpj) %>% 
  dplyr::distinct(str_razao_social, .keep_all = TRUE)

da_sindec_empresas_arrumado <- da_sindec_empresas %>% 
  dplyr::mutate(str_razao_social = limpar(str_razao_social)) %>% 
  dplyr::left_join(aux_juntar, "str_razao_social") %>% 
  dplyr::transmute(
    str_razao_social,
    cnpj = dplyr::coalesce(cnpj.x, cnpj.y),
    atendida
  )

# AGORA precisamos cruzar com a base da RFB. Vamos fazer em chunks!

filtrar_empresas <- function(dados, pos) {
  dados %>% 
    dplyr::semi_join(da_sindec_empresas_arrumado, "cnpj")
}

path_rfb <- "dados/csv_dados_qsa_cnpj_23-11-20/cnpj_dados_cadastrais_pj.csv"

callback <- readr::DataFrameCallback$new(filtrar_empresas)

dados_rfb <- readr::read_delim_chunked(
  path_rfb, 
  delim = "#",
  callback, 
  guess_max = 100000
)

# legal! agora preciso sumarizar para obter os numeros finais

# tab_nat <- qsacnpj::tab_natureza_juridica
tab_nat <- readr::read_rds("dados/case/tab_nat.rds")

tab_natureza <- da_sindec_empresas_arrumado %>% 
  dplyr::inner_join(
    dplyr::select(dados_rfb, cnpj, codigo_natureza_juridica), 
    "cnpj"
  ) %>% 
  dplyr::mutate(codigo_natureza_juridica = as.character(codigo_natureza_juridica)) %>% 
  dplyr::inner_join(
    tab_nat,
    c("codigo_natureza_juridica" = "cod_subclass_natureza_juridica")
  ) %>% 
  dplyr::group_by(nm_subclass_natureza_juridica) %>% 
  dplyr::summarise(
    n = dplyr::n(),
    p_atendida = mean(atendida == "S")
  ) %>% 
  dplyr::filter(n > 10) %>% 
  dplyr::arrange(dplyr::desc(p_atendida))



