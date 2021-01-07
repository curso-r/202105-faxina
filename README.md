
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Configuração inicial

#### Passo 1: Instalar pacotes

``` r
install.packages("remotes")

# instalar pacote da Curso-R
remotes::install_github("curso-r/CursoR")
```

#### Passo 2: Criar um projeto do RStudio

Faça um projeto do RStudio para usar durante todo o curso e em seguida
abra-o.

``` r
install.packages("usethis")
usethis::create_project("caminho_ate_o_projeto/nome_do_projeto")
```

#### Passo 3: Baixar o material

Certifique que você está dentro do projeto criado no passo 2 e rode o
código abaixo.

**Observação**: Assim que rodar o código abaixo, o programa vai pedir
uma escolha de opções. Escolha o número correspondente ao curso de
Faxina!

``` r
# Baixar ou atualizar material do curso
CursoR::atualizar_material()
```

## Slides

| Slide                              | Link                                                                       | Link em PDF                                                                                 |
|:-----------------------------------|:---------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------|
| slides/01-introducao-ao-curso.html | <https://curso-r.github.io/main-faxina/slides/01-introducao-ao-curso.html> | <a href='https://curso-r.github.io/main-faxina/slides/01-introducao-ao-curso.pdf'> PDF </a> |
| slides/02-introducao-faxina.html   | <https://curso-r.github.io/main-faxina/slides/02-introducao-faxina.html>   | <a href='https://curso-r.github.io/main-faxina/slides/02-introducao-faxina.pdf'> PDF </a>   |

## Scripts usados em aula

| script | link |
|:-------|:-----|
