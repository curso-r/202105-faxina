library(magrittr)
library(ggplot2)

# Exercício 1 -------------------------------------------------------------

base_bruta <- read.delim(
  "dados/DadosBO_2021_3(ROUBO DE CELULAR).xls",
  fileEncoding = "UTF-16LE",
  sep = "\t",
  header = TRUE,
  stringsAsFactors = FALSE
) %>%
  tibble::as_tibble()

# Exercício 1

ids <- c("num_bo", "dataocorrencia", "delegacia_nome", "ano_bo")

# b) arrume os nomes da base

base_nomes_arrumados <- base_bruta %>%
  janitor::clean_names()

# a) transforme a base bruta em uma base tidy

ocorrencias <- base_nomes_arrumados %>%
  dplyr::select(ano_bo:delegacia_circunscricao) %>%
  dplyr::distinct()

carros <- base_nomes_arrumados %>%
  dplyr::select(
    num_bo, ano_bo, delegacia_nome,
    # precisamos as colunas de chave
    placa_veiculo:ano_fabricacao) %>%
  dplyr::distinct(placa_veiculo, .keep_all = TRUE) %>%
  dplyr::group_by(num_bo, ano_bo, delegacia_nome) %>%
  tidyr::nest() %>%
  # se houver mais um carro, a gente não quer que eles dupliquem os celulares
  dplyr::rename(
    dados_carros = data
  )

celulares <- base_nomes_arrumados %>%
  dplyr::select(ids, quant_celular, marca_celular) %>%
  dplyr::distinct(.keep_all = TRUE)

crimes_passo1 <- base_nomes_arrumados %>%
  dplyr::select(
    num_bo, ano_bo, delegacia_nome,
    # precisamos as colunas de chave
    especie, rubrica, desdobramento
  ) %>%
  dplyr::distinct() %>%
  tidyr::unite(crime_completo, especie, rubrica, desdobramento, sep = " @@@ ")

crimes_passo_crimes_unidos <- crimes_passo1 %>%
  dplyr::group_by(num_bo, ano_bo, delegacia_nome) %>%
  dplyr::summarise(
    todos_os_crimes = stringr::str_c(crime_completo, collapse = "\n")
  )

crimes_passo_list_column <- crimes_passo1 %>%
  dplyr::group_by(num_bo, ano_bo, delegacia_nome) %>%
  tidyr::nest() %>%
  dplyr::rename(
    rubrica_nested = data
  )

base_tidy <- celulares %>%
  dplyr::left_join(ocorrencias) %>%
  dplyr::left_join(carros) %>%
  dplyr::left_join(crimes_passo_crimes_unidos) %>%
  dplyr::left_join(crimes_passo_list_column)

# Dica: A base não precisa ser perfeita, o mais
# importante é remover as duplicações proporcionadas pela
# pelas rubricas/desdobramentos etc

# c) arrume as colunas de latitude e longitude

arrumar_numero <- function(vetor){
  vetor %>%
    stringr::str_replace_all(",", ".") %>%
    as.numeric()
}

base_tidy_com_lat_lon <- base_tidy %>%
  dplyr::mutate(
    dplyr::across(
      c(latitude, longitude),
      #opcao 1
      arrumar_numero
      #opcao 2
      #readr::parse_number
    )
  )

# Dica 1: as.numeric("1.05") transforma o texto "1.05" no número 1.05
# Dica 2: Essa planilha usa "," como separador decimal

# d) padronize a coluna marca_celular

# Vamos dar uma olhada nas opcoes:
base_tidy_com_lat_lon %>%
  dplyr::count(
    stringr::str_to_upper(marca_celular)
  ) %>%
  dplyr::arrange(n) %>%
  tibble::view()

base_tidy_com_lat_lon_com_marca_padronizada <- base_tidy_com_lat_lon %>%
  dplyr::mutate(
    marca_celular = stringr::str_to_upper(marca_celular),
    marca_celular = dplyr::case_when(
      marca_celular %in% c("SANSUNG", "SAMSUNG") ~ "SAMSUNG",
      marca_celular %in% c("MOTOROLLA", "MOTOROLA") ~ "MOTOROLA",
      TRUE ~ dplyr::na_if(marca_celular, "")
    )
  )

# Dica 1: Use a função dplyr::case_when
# Dica 2: Você pode tentar chegar em uma coluna final
# que tenha apenas marcas escritas assim:
# APPLE, LENOVO, MICROSOFT, ..., OUTROS

# d) (opcional) faça um mapa com pontos usando latitudes e longitudes.
# use como cor a coluna marca_celular (arrumada)

# install.packages("leaflet")

m <- leaflet::leaflet(data = base_tidy_com_lat_lon_com_marca_padronizada) %>%
  leaflet::addTiles() %>%  # Add default OpenStreetMap map tiles
  leaflet::addMarkers(
    lng = ~longitude,
    lat = ~latitude,
    label = ~marca_celular,
    clusterOptions = leaflet::markerClusterOptions()
  )

m
