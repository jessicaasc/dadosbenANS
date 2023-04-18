# dadosbenANS
 
O pacote para R *dadosbenANS* permite o download e leitura dos arquivos de informações consolidadas de beneficiários provenientes do Sistema de Informações de Beneficiários (SIB/ANS) e do Sistema de Registro de Produtos (RPS/ANS) (disponíveis em: <https://dadosabertos.ans.gov.br/FTP/PDA/informacoes_consolidadas_de_beneficiarios/>). 

## Instalação

Comando para instalar a versão de desenvolvimento:

``` r
install.packages("devtools")
devtools::install_github("jessicaasc/dadosbenANS")
```
## Utilização

O pacote é composto por uma única função que realiza o download dos dados por competêcia, cobertura e tipo de contratação de interesse. 

### Exemplo

```{r example}
library(dadosbenANS)
dados <- getben(ano = "2020", mes = "12", cobertura = "Médico-hospitalar",
                tipo_contrato = "Individual", uf = c("SP","MG"))
```
