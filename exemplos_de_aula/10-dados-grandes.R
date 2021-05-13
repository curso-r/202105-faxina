
# Base da receita federal -------------------------------------------------

# Link: https://bit.ly/3jC3KGj

# Baixe e descompacte o arquivo na pasta "dados/" do material
# Obs: é possível ler o arquivo .gz diretamente pelas ferramentas que estamos
# usando, mas vamos usar a descompactada pois vamos ler várias vezes

path <- "dados/empresas.csv"

# NAO RODE
da_rfb <- readr::read_csv(path)


readr::read_lines(path, n_max = 10)
