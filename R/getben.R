#' Download das informações consolidadas de beneficiários da ANS
#'
#' Executa o download das informações consolidadas de beneficiários da ANS para o período e UFs de interesse
#'
#' @param ano. Ano de interesse no formato "aaaa".
#' @param mes. Mês de interesse no formato "mm".
#' @param cobertura. Tipo de cobertura de plano do beneficiário - "Médico-hospitalar" ou "Odontológico".
#' @param tipo_contrato. Tipo de contratação do plano do beneficiário - "Empresarial", "Adesão", "Individual".
#' @param autogestao. Parâmetro para exclusão das operadoras que seguem a modalidade de autogestão. Use autogestao = TRUE para incluir essa modalidade.
#' @param uf. UFs de interesse.
#' @examples
#'
#' getben(ano = "2020", mes = "12", cobertura = "Médico-hospitalar", tipo_contrato = "Individual", uf = "SP")
#'
#' getben(ano = "2020", mes = "12", cobertura = "Odontológico", tipo_contrato = "Empresarial", uf = c("MG","SP","RJ"))
#'
#' @import dplyr
#' @import utils
#' @importFrom  magrittr %>%
#' @import stringr
#' @export


getben <- function(ano, mes,cobertura, tipo_contrato, autogestao = FALSE,  uf = "all") {
  temp <- tempfile()

  url <- "http://ftp.dadosabertos.ans.gov.br/FTP/PDA/informacoes_consolidadas_de_beneficiarios/"

  # Check UF
  ufs <- c("AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO")
  if (!all((uf %in% c("all", ufs)))) stop("UF unknow.")

  df <- data.frame()

  for (i in 1:length(uf)) {
    subdir1 <- paste(url,
      ano,
      mes,
      sep = ""
    )
    subdir2 <- paste(subdir1,
      "/",
      "ben",
      ano,
      mes,
      "_",
      uf[i],
      ".zip",
      sep = ""
    )

    utils::download.file(subdir2, temp)
    zip <- utils::unzip(temp, list = T)
    arquivo <- zip$Name
    dados <- read.csv(unz(temp, arquivo), sep = ";")

    if (autogestao == TRUE) {
      dados <- dados %>%
        dplyr::filter(
          COBERTURA_ASSIST_PLAN == cobertura,
          str_detect(DE_CONTRATACAO_PLANO,
                     stringr::str_to_upper(tipo_contrato))
        )
    } else {
      dados <- dados %>%
        dplyr::filter(
          MODALIDADE_OPERADORA != "AUTOGESTÃO",
          COBERTURA_ASSIST_PLAN == cobertura,
          str_detect(DE_CONTRATACAO_PLANO,
                     stringr::str_to_upper(tipo_contrato))
        )
    }

    df <- rbind(df, dados)
  }

  return(df)
}

