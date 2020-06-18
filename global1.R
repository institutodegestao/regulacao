library(dplyr) # comandos pip
library(DT) # tabelas dinâmicas
library(flexdashboard) # dashboard
library(formattable) # formatações
library(gplots) # gráficos
library(lubridate) # datas
library(plotly) # gráficos
library(reshape2) # transformação de dados

### base 4 = teste

exame <- read.csv2('extracao_cruzamento1.csv', sep = ';') # carga

#exame <- read.csv2('extracao_cruzamento.csv', sep = ';', encoding = 'UTF-8') # carga

colnames(exame) <- c('id_vig', 'dist_vig', 'dist_ass', 'dist', 'carga', 'pac_reg', 'pac_vig', 'pac_ass', 'data_int', 'idade_vig', 'idade_reg', 'idade_ass', 'sexo_reg', 'esp_leito', 'unidade_reg', 'tipo_leito_reg', 'tipo_leito_reg2', 'status_solicitacao', 'classe_vig', 'exame_vig', 'exame_ass', 'resultado', 'exames', 'evolucao_vig', 'evolucao_ass', 'desfecho', 'paciente')

exameTotal <- exame

exameTotal <- exameTotal %>% distinct(pac_reg, .keep_all= TRUE)

exame <- exame %>% distinct(pac_reg, .keep_all= TRUE)

exameInLin <- nrow(exame)

#exame <- subset(exame, dist < 0.89)
exame <- subset(exame, carga == 'sim')
  
exameFimLin <- nrow(exame)

txExameErro <- percent(1-(exameFimLin/exameInLin),0)
exameErro <- exameInLin - exameFimLin

## tratamentos de datas
exame$data_int <- as.Date(exame$data_int, format = "%d/%m/%y")

## novas colunas e dimensões
max_dt_exame <- max(exame$data_int)
