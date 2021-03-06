
<!-- README.md is generated from README.Rmd. Please edit that file -->

<div class="figure">

<img src="https://raw.githubusercontent.com/allisonhorst/stats-illustrations/master/rstats-artwork/tidydata_3.jpg" alt="Imagem de Allison Horst." width="100%" />
<p class="caption">
Imagem de Allison Horst.
</p>

</div>

> Quando trabalhamos com dados tidy (arrumados), podemos utilizar as
> **mesmas ferramentas**, de formas **similares**, em bases de dados
> diferentes…

> … porém, quando trabalhamos com bases de dados untidy (desarrumadas),
> muitas vezes precisamos **reinventar a roda**: desenvolvemos uma
> solução que muitas vezes é difícil de **iterar ou reutilizar**.

– (tradução livre, thanks to [Beatriz Milz](beatrizmilz.com/))

## Informações importantes

-   [Clique
    aqui](https://github.com/curso-r/main-faxina/raw/master/material_do_curso.zip)
    para baixar o material do curso.

-   Os **pacotes necessários** no curso e o código para instalação estão
    disponíveis [neste
    link](https://curso-r.github.io/main-faxina#pacotes-necess%C3%A1rios).

-   Nosso livro **Ciência de Dados em R**: <https://livro.curso-r.com/>

-   Nosso blog: <https://curso-r.com/blog/>

## Dúvidas

Fora do horário de aula ou monitoria:

-   perguntas gerais sobre o curso deverão ser feitas no Classroom.

-   perguntas sobre R, principalmente as que envolverem código, deverão
    ser enviadas no [nosso fórum](https://discourse.curso-r.com/).

## Slides

| slide                              | link                                                                       | pdf                                                                       |
|:-----------------------------------|:---------------------------------------------------------------------------|:--------------------------------------------------------------------------|
| slides/01-introducao-ao-curso.html | <https://curso-r.github.io/main-faxina/slides/01-introducao-ao-curso.html> | <https://curso-r.github.io/main-faxina/slides/01-introducao-ao-curso.pdf> |
| slides/02-introducao-faxina.html   | <https://curso-r.github.io/main-faxina/slides/02-introducao-faxina.html>   | <https://curso-r.github.io/main-faxina/slides/02-introducao-faxina.pdf>   |
| slides/03-integracao.html          | <https://curso-r.github.io/main-faxina/slides/03-integracao.html>          | <https://curso-r.github.io/main-faxina/slides/03-integracao.pdf>          |

## Scripts utilizados em aula

Aqui colocamos scripts utilizados em aula que são novos ou que são
versões modificadas do material básico da aula.

| script                       | link                                                                                    |
|:-----------------------------|:----------------------------------------------------------------------------------------|
| 01-exemplo\_ssp\_micro.R     | <https://curso-r.github.io/202105-faxina/exemplos_de_aula/01-exemplo_ssp_micro.R>       |
| 02-consultoria.R             | <https://curso-r.github.io/202105-faxina/exemplos_de_aula/02-consultoria.R>             |
| 03-funcoes.R                 | <https://curso-r.github.io/202105-faxina/exemplos_de_aula/03-funcoes.R>                 |
| 04-pdf-pdftools.R            | <https://curso-r.github.io/202105-faxina/exemplos_de_aula/04-pdf-pdftools.R>            |
| 05-pdf-tabulizer.R           | <https://curso-r.github.io/202105-faxina/exemplos_de_aula/05-pdf-tabulizer.R>           |
| 06-lista-json.R              | <https://curso-r.github.io/202105-faxina/exemplos_de_aula/06-lista-json.R>              |
| 07-lista-xml.R               | <https://curso-r.github.io/202105-faxina/exemplos_de_aula/07-lista-xml.R>               |
| 08-consultoria-continuacao.R | <https://curso-r.github.io/202105-faxina/exemplos_de_aula/08-consultoria-continuacao.R> |
| 09-csv-comparacoes.R         | <https://curso-r.github.io/202105-faxina/exemplos_de_aula/09-csv-comparacoes.R>         |
| 10-dados-grandes-rfb.R       | <https://curso-r.github.io/202105-faxina/exemplos_de_aula/10-dados-grandes-rfb.R>       |
| 11-case-rfb-sindec.R         | <https://curso-r.github.io/202105-faxina/exemplos_de_aula/11-case-rfb-sindec.R>         |
| 12-case-rfb-sindec-dash.Rmd  | <https://curso-r.github.io/202105-faxina/exemplos_de_aula/12-case-rfb-sindec-dash.Rmd>  |
| xx-exemplos-adicionais.R     | <https://curso-r.github.io/202105-faxina/exemplos_de_aula/xx-exemplos-adicionais.R>     |

## Lição de casa

| nome                      | link                                                              |
|:--------------------------|:------------------------------------------------------------------|
| exercicios/01-exercicio.R | <https://curso-r.github.io/main-faxina/exercicios/01-exercicio.R> |
| exercicios/02-exercicio.R | <https://curso-r.github.io/main-faxina/exercicios/02-exercicio.R> |
| exercicios/03-exercicio.R | <https://curso-r.github.io/main-faxina/exercicios/03-exercicio.R> |

## Trabalho final

O trabalho final consiste em construir um projeto em R que utiliza os
conceitos que aprendemos no curso, partindo de uma base de dados untidy
como entrada e apresentando um (ou mais) scripts que a entrada em uma
base **tidy**.

Com o objetivo de tornar o trabalho mais divertido e útil para a
comunidade, de preferência, use uma base de dados que esteja pública
(que possa ser acessada por qualquer pessoa, sem restrição). Você pode,
por exemplo, escolher uma fonte de dados que você tem interesse em
trabalhar. Se não tiver ideia do que escolher, seguem algumas sugestões:

-   [Algum dos microdados do
    IDEB](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados)
-   [Dados de ocupação
    hospitalar](https://opendatasus.saude.gov.br/dataset/registro-de-ocupacao-hospitalar/resource/f9391f7c-9775-4fac-a3ce-bf384e2674c2)
-   [Alguma das bases disponíveis na
    SSP](http://www.ssp.sp.gov.br/transparenciassp/Consulta.aspx) que
    não tenham sido trabalhadas no curso.

**O que devo entregar?**

Uma pasta contendo três itens:

-   A base de dados em formato bruto OU um script de acesso a essa base,
    fazendo um download por exemplo. Esse segundo caso só deve ser usado
    caso a base que você pretenda utilizar ultrapasse **50 MB**. Caso
    você queira usar uma base maior, pedimos que ela **1 GB**.

-   Um ou mais scripts R que transformem a sua base bruta e untidy em
    uma (ou mais) base(s) tidy. O(s) seu(s) script(s) deve(m)
    necessariamente:

    -   Ler os dados brutos;
    -   Manipular uma coluna do tipo texto;
    -   Salvar uma base de dados ao final do script que esteja no
        formato tidy “aumentado” que apresentamos no começo do curso, no
        formato `.rds`.

-   Um arquivo Rmarkdown (.Rmd) contendo uma descrição do que foi feito
    e uma análise simples da base tidy (por exemplo, um gráfico). Não
    faça a leitura dos arquivos brutos nesse documento.

    -   **Obs**: Se você não se sentir confortável com o formato
        `RMarkdown`, pode mandar um arquivo `.docx` (editado no
        Microsoft Word), um arquivo `.txt`, ou comentários (bem
        detalhados) nos script(s) `.R` enviado(s).

**O que é importante conter na descrição do que foi feito?**

-   Uma introdução, que consiste num texto descrevendo o que o seu
    código fará, respondendo no mínimo três perguntas: Por que a base
    pode ser considerada untidy? Como você organizou os seus arquivos
    pra transforma-la em uma base tidy? Que tipo de análise a sua base
    tidy possibilita?

A entrega pode ser feita anexando a pasta `.zip`, ou então enviando um
link da pasta no Google Drive (atenção: permita que qualquer pessoa
possa ler os arquivos).

As pessoas que fizerem os três trabalhos mais legais receberão **bolsas
da Curso-R**!

**Observação**: Caso você entregue o trabalho, entendemos que concorda
em apresentar um link para o seu trabalho na página do curso. Caso você
não se sinta confortável com essa possibilidade, pedimos que nos avise
no momento da entrega através dos comentários.

A **data limite** de entrega é 24/06/2021, às 23:59. Os resultados serão
avaliados até o dia 25/07/2021.

## Trabalhos finais premiados

(em breve)

## Material extra

Referências extras comentadas nas aulas.

| Aula | Tema          | Descrição                                                                                                                            |
|-----:|:--------------|:-------------------------------------------------------------------------------------------------------------------------------------|
|    0 | organizacao   | [Pacote targets para organização de projetos](https://docs.ropensci.org/targets/)                                                    |
|    0 | organizacao   | [Livro sobre pacote targets](https://books.ropensci.org/targets/)                                                                    |
|    0 | organizacao   | [Pacote drake (que foi substituído pelo targets)](https://docs.ropensci.org/drake/)                                                  |
|    0 | janitor       | [Pacote janitor no livro da curso-r](https://livro.curso-r.com/11-1-arrumando-banco-de-dados-o-pacote-janitor.html)                  |
|    1 | organizacao   | [Slides de pacotes](https://curso-r.github.io/main-pacotes/slides/index.html)                                                        |
|    1 | organizacao   | [Livro Zen do R](https://curso-r.github.io/zen-do-r/)                                                                                |
|    1 | organizacao   | [Livro R Packages](https://r-pkgs.org/)                                                                                              |
|    1 | leitura       | [Tentar achar o encoding](https://readr.tidyverse.org/reference/encoding.html)                                                       |
|    1 | exemplo       | [Exemplo de pacote](https://github.com/jtrecenti/vacinaBrasil)                                                                       |
|    1 | leitura       | [Artigo do Hadley sobre Tidy Data](https://www.jstatsoft.org/article/view/v059i10)                                                   |
|    2 | exemplo       | [Exemplo de pacote com automação](https://github.com/abjur/falrec)                                                                   |
|    2 | organizacao   | [Exemplo de documentação de dados](https://r-pkgs.org/data.html#documenting-data)                                                    |
|    2 | leitura       | [Como instalar o rJava](https://cimentadaj.github.io/blog/2018-05-25-installing-rjava-on-windows-10/installing-rjava-on-windows-10/) |
|    3 | organizacao   | [Parse de datas](https://readr.tidyverse.org/reference/parse_datetime.html)                                                          |
|    3 | Bases grandes | [Pacote disk.frame](https://diskframe.com/)                                                                                          |
|    3 | Bases grandes | [Pacote arrow](https://arrow.apache.org/docs/r/)                                                                                     |
|    3 | Bases grandes | [Pacote rsqlite](https://rsqlite.r-dbi.org/)                                                                                         |
|    3 | Bases grandes | [Pacote dbplyr](https://dbplyr.tidyverse.org/)                                                                                       |
|    3 | Bases grandes | [Pacote dtplyr](https://dtplyr.tidyverse.org/)                                                                                       |
|    3 | Bases grandes | [Pacote bigrquery](https://bigrquery.r-dbi.org/)                                                                                     |
|    3 | Bases grandes | [Post: Como acessar a base de dados de CNPJ da receita federal](https://blog.curso-r.com/posts/2021-04-01-acessar-cnpj/)             |
|    3 | Bases grandes | [Base dos dados](https://github.com/basedosdados/mais#usando-em-r)                                                                   |
|    3 | Bases grandes | [Video do Base dos dados: Aprenda a acessar dados públicos em R](https://www.youtube.com/watch?v=M9ayiseIjvI)                        |
|    3 | outros        | [Live da Curso-R - Novo pipe \|&gt;](https://www.youtube.com/watch?v=RPSLFU_5OGk)                                                    |
|    3 | outros        | [Pacote stringdist](https://github.com/markvanderloo/stringdist)                                                                     |

## Dados

| nome                                                                      | link                                                                                                               |
|:--------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------|
| BasedeDadosInfopenJunhode2020.xlsx                                        | <https://curso-r.github.io/202105-faxina/dados/BasedeDadosInfopenJunhode2020.xlsx>                                 |
| case/atendimento\_uf.rds                                                  | <https://curso-r.github.io/202105-faxina/dados/case/atendimento_uf.rds>                                            |
| case/contagem\_sexo\_faixa.rds                                            | <https://curso-r.github.io/202105-faxina/dados/case/contagem_sexo_faixa.rds>                                       |
| case/contagem\_tema.rds                                                   | <https://curso-r.github.io/202105-faxina/dados/case/contagem_tema.rds>                                             |
| case/da\_sindec\_empresas\_arrumado.rds                                   | <https://curso-r.github.io/202105-faxina/dados/case/da_sindec_empresas_arrumado.rds>                               |
| case/dados\_rfb.rds                                                       | <https://curso-r.github.io/202105-faxina/dados/case/dados_rfb.rds>                                                 |
| case/map\_uf.rds                                                          | <https://curso-r.github.io/202105-faxina/dados/case/map_uf.rds>                                                    |
| case/tab\_nat.rds                                                         | <https://curso-r.github.io/202105-faxina/dados/case/tab_nat.rds>                                                   |
| crf2019-dados-abertos/CRF2019 Dados Abertos.csv                           | <https://curso-r.github.io/202105-faxina/dados/crf2019-dados-abertos/CRF2019%20Dados%20Abertos.csv>                |
| csv\_dados\_qsa\_cnpj\_23-11-20/cnpj\_dados\_cadastrais\_pj.csv           | <https://curso-r.github.io/202105-faxina/dados/csv_dados_qsa_cnpj_23-11-20/cnpj_dados_cadastrais_pj.csv>           |
| csv\_dados\_qsa\_cnpj\_23-11-20/cnpj\_dados\_cnae\_secundario.csv         | <https://curso-r.github.io/202105-faxina/dados/csv_dados_qsa_cnpj_23-11-20/cnpj_dados_cnae_secundario.csv>         |
| csv\_dados\_qsa\_cnpj\_23-11-20/cnpj\_dados\_socios\_pj.csv               | <https://curso-r.github.io/202105-faxina/dados/csv_dados_qsa_cnpj_23-11-20/cnpj_dados_socios_pj.csv>               |
| csv\_dados\_qsa\_cnpj\_23-11-20/tab\_cnae.csv                             | <https://curso-r.github.io/202105-faxina/dados/csv_dados_qsa_cnpj_23-11-20/tab_cnae.csv>                           |
| csv\_dados\_qsa\_cnpj\_23-11-20/tab\_cnpj\_entes\_publicos.csv            | <https://curso-r.github.io/202105-faxina/dados/csv_dados_qsa_cnpj_23-11-20/tab_cnpj_entes_publicos.csv>            |
| csv\_dados\_qsa\_cnpj\_23-11-20/tab\_codigo\_municipios\_siafi.csv        | <https://curso-r.github.io/202105-faxina/dados/csv_dados_qsa_cnpj_23-11-20/tab_codigo_municipios_siafi.csv>        |
| csv\_dados\_qsa\_cnpj\_23-11-20/tab\_natureza\_juridica.csv               | <https://curso-r.github.io/202105-faxina/dados/csv_dados_qsa_cnpj_23-11-20/tab_natureza_juridica.csv>              |
| csv\_dados\_qsa\_cnpj\_23-11-20/tab\_qualificacao\_responsavel\_socio.csv | <https://curso-r.github.io/202105-faxina/dados/csv_dados_qsa_cnpj_23-11-20/tab_qualificacao_responsavel_socio.csv> |
| csv\_dados\_qsa\_cnpj\_23-11-20/tab\_situacao\_cadastral.csv              | <https://curso-r.github.io/202105-faxina/dados/csv_dados_qsa_cnpj_23-11-20/tab_situacao_cadastral.csv>             |
| dados\_consultoria.xlsx                                                   | <https://curso-r.github.io/202105-faxina/dados/dados_consultoria.xlsx>                                             |
| dados\_rfb\_small.csv                                                     | <https://curso-r.github.io/202105-faxina/dados/dados_rfb_small.csv>                                                |
| DadosBO\_2021\_3(ROUBO DE CELULAR).xls                                    | <https://curso-r.github.io/202105-faxina/dados/DadosBO_2021_3(ROUBO%20DE%20CELULAR).xls>                           |
| DadosBO\_2021\_3(ROUBO DE VEÍCULOS))\_completa.xls                        | <https://curso-r.github.io/202105-faxina/dados/DadosBO_2021_3(ROUBO%20DE%20VE%CDCULOS))_completa.xls>              |
| DadosBO\_2021\_3(ROUBO DE VEÍCULOS).xls                                   | <https://curso-r.github.io/202105-faxina/dados/DadosBO_2021_3(ROUBO%20DE%20VE%CDCULOS).xls>                        |
| ReporteReimpresion-Mayo.csv                                               | <https://curso-r.github.io/202105-faxina/dados/ReporteReimpresion-Mayo.csv>                                        |

## Redes sociais da Curso-R

Instagram: <https://www.instagram.com/cursoo_r/>

Twitter: <https://twitter.com/curso_r>

Youtube: <https://www.youtube.com/c/CursoR6/featured>

Linkedin: <https://www.linkedin.com/company/curso-r/>

Facebook: <https://www.facebook.com/cursodeR>
