library(tidyverse)

base_bruta <- readxl::read_excel("dados/DadosBO_2021_3(ROUBO DE VEÍCULOS).xls")

base_bruta <- read.delim("dados/DadosBO_2021_3(ROUBO DE VEÍCULOS))_completa.xls", fileEncoding = "UTF-16LE", sep = "\t", header = T, stringsAsFactors = F)
base_bruta <- read.delim("dados/DadosBO_2021_3(ROUBO DE CELULAR).xls", fileEncoding = "UTF-16LE", sep = "\t", header = T, stringsAsFactors = F)


# Quem são as observações da base? ----------------------------------------

# A unidade é o fato? (roubo de carro)

base_bruta %>% 
  count(ANO_BO, NUM_BO, DELEGACIA_CIRCUNSCRICAO, DELEGACIA_NOME)

# A unidade é o carro roubado? (vítima que sofreu o roubo)

base_bruta %>% 
  count(ANO_BO, NUM_BO, DELEGACIA_CIRCUNSCRICAO, DELEGACIA_NOME, PLACA_VEICULO)

# -------------------------------------------------------------------------

