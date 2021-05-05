
# leitura de json ---------------------------------------------------------

# Um arquivo json nada mais é do que uma lista aninhada (lista de listas)
# portanto, para trabalhar com arquivos json precisamos de técnicas
# para trabalhar com listas.
#
# pacotes legais nesse sentido: {purrr} e {rlist}. Nosso foco será purrr

# vamos usar o exemplo do pokemon (curso de webscraping)

path_ditto <- "https://pokeapi.co/api/v2/pokemon/ditto"
# arquivo temporario
arquivo_temp_json <- fs::file_temp("pokemon_", ext = ".json")
# salva em disco
r_poke <- httr::GET(path_ditto, httr::write_disk(arquivo_temp_json, TRUE))

texto_json <- httr::content(r_poke, "text")

# para ler uma string no formato json, usar jsonlite::fromJSON()
json_poke <- jsonlite::fromJSON(texto_json, simplifyDataFrame = FALSE)

# para ler um arquivo .json do seu disco, usar jsonlite::read_json()
json_poke_disco <- jsonlite::read_json(arquivo_temp_json)

# simplificar para data frame o que for possível
json_poke_df <- jsonlite::fromJSON(texto_json, simplifyDataFrame = TRUE)

# veja que essa coluna stat está estranha
json_poke_df$stats %>% 
  tibble::as_tibble()

# investigando o objeto, observamos que uma das colunas é uma tabela
json_poke_df$stats$stat
# equivalente com pluck
json_poke_df %>% 
  purrr::pluck("stats", "stat")

# olha como é no original
json_poke %>% 
  purrr::pluck("stats")

json_poke %>% 
  purrr::pluck("stats", 1, "stat")

# para arrumar isso, podemos usar tidyr::chop() e tidyr::unnest()

json_poke_df %>% 
  purrr::pluck("stats") %>% 
  tibble::as_tibble() %>% 
  tidyr::chop(stat) %>% 
  tidyr::unnest(stat)

# obs: nem sempre é tão fácil!