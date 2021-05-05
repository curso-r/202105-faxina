# leitura de csv e similares ----------------------------------------------

# link para baixar arquivos
# fonte: https://opendatasus.saude.gov.br/dataset/registro-de-ocupacao-hospitalar/resource/f9391f7c-9775-4fac-a3ce-bf384e2674c2
# (pode ser que no dia da aula precise atualizar)
path_csv_leitos <- "https://s3-sa-east-1.amazonaws.com/ckan.saude.gov.br/Leitos/2021-05-03/esus-vepi.LeitoOcupacao.csv"

# cria arquivo temporario
arquivo_temporario <- fs::file_temp("leitos_", ext = ".csv")
# baixa arquivo
httr::GET(
  path_csv_leitos, 
  httr::write_disk(arquivo_temporario, TRUE),
  httr::progress()
)

# alternativa 1: readr::read_csv()
# vantagens: flexível, intuitivo
# desvantagens: lento

dados <- readr::read_csv(arquivo_temporario)

# alternativa 2: data.table::fread()
# vantagens: rapido
# desvantagens: contraintuitivo (para alguns)
dados <- data.table::fread(arquivo_temporario)

# alternativa 3: arrow::read_csv_arrow()
# vantagens: rapido(?), intuitivo, facilita trabalho com Spark, integração com {dplyr}
# desvantagens: muito novo!
dados <- arrow::read_csv_arrow(arquivo_temporario)

# alternativa 4: vroom::vroom()
# vantagens: rapido(!!!), intuitivo
# desvantagens: não lê os dados de verdade, você paga o preço depois
dados <- vroom::vroom(arquivo_temporario)


# comparação naive (não é um benchmark!)
tictoc::tic()
dados <- readr::read_csv(arquivo_temporario)
tictoc::toc()

tictoc::tic()
dados <- data.table::fread(arquivo_temporario)
tictoc::toc()

tictoc::tic()
dados <- arrow::read_csv_arrow(arquivo_temporario)
tictoc::toc()

tictoc::tic()
dados <- vroom::vroom(arquivo_temporario)
tictoc::toc()

# na prática: 
# 
# - use read_csv a menos que você tenha um bom motivo para não usar
# - estude de forma mais profunda alguma das alternativas e siga com ela
# - tenha sempre em mente de que existem pelo menos essas três concorrendo

# deletar arquivo temporario
fs::file_delete(arquivo_temporario)
