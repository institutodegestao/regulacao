library(dplyr) # comandos pip
library(DT) # tabelas dinâmicas
library(flexdashboard) # dashboard
library(formattable) # formatações
library(gplots) # gráficos
library(lubridate) # datas
library(plotly) # gráficos
library(reshape2) # transformação de dados

leitos_geral <- read.csv2('leito_ncovid.csv', sep = ';', encoding = 'UTF-8')

colnames(leitos_geral) <- c('tipo', 'tipo2', 'esp_leito', 'unidade', 'lk_ocupacao', 'lk_uni_ocup', 'dt_leito', 'situacao', 'tipo_int', 'status', 'sexo_leito', 'leito', 'leito_oper', 'hospital', 'regiao', 'municipio', 'lat', 'lng', 'tipo3', 'tipo4') 
leitos_geral$dt_leito <- as.Date(leitos_geral$dt_leito, format = "%d/%m/%y")

max_dt_leito <- max(leitos_geral$dt_leito)

leitos_uti <- leitos_geral %>% filter(tipo2 == 'UTI')
leitos_enf <- leitos_geral %>% filter(tipo2 == 'ENFERMARIA')

rm(leitos_geral)

### base 2 = historico_solicitacoes

sol_hist_nova <- read.csv2('fila_ncovid.csv', sep = ';') 

colnames(sol_hist_nova) <- c('lk_solicitacao', 'data_sol',  'hr_hist_sol', 'cod_sol', 'status_sol', 'unidade_sol', 'prioridade', 'tipo_leito_sol', 'tipo2_leito_sol', 'esp_leito_sol', 'tipo_leito_reg', 'tipo2_leito_reg', 'esp_leito_reg', 'sol', 'dt_base_sol', 'dt_hist_sol', 'status_hist_sol', 'tempo_sol', 'posicao_fila', 'sol_hist', 'lista', 'lista_dia', 'macro2', 'geres2', 'municipio2')

sol_hist_nova$data_sol <- as.Date(sol_hist_nova$data_sol, format = "%d/%m/%y")
sol_hist_nova$dt_base_sol <- as.Date(sol_hist_nova$dt_base_sol, format = "%d/%m/%y")
sol_hist_nova$dt_hist_sol <- as.Date(sol_hist_nova$dt_hist_sol, format = "%d/%m/%y")

max_dt_base_sol <- max(sol_hist_nova$dt_base_sol)

### base 3 = solicitacoes
sol_pac <- read.csv2('solicitacao_ncovid.csv', sep = ';') # carga

colnames(sol_pac) <- c('k_sol', 'k_pac', 'k_censo', 'nro_sol', 'macro', 'geres', 'municipio', 'unidade', 'prioridade', 'status_sol', 'tipo_leito', 'tipo2', 'esp_leito', 'data_sol', 'risco', 'sol', 'unidade_int', 'hospital_int', 'macro2', 'geres2', 'municipio2') # nomes de colunas

## tratamentos de datas
sol_pac$data_sol <- as.Date(sol_pac$data_sol, format = "%d/%m/%y")

# sol_pac <- subset(sol_pac, data_sol <= '2020-03-28')

## novas colunas e dimensões
max_dt_sol <- max(sol_pac$data_sol)
