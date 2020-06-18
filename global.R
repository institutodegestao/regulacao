library(dplyr) # comandos pip
library(DT) # tabelas dinâmicas
library(flexdashboard) # dashboard
library(formattable) # formatações
library(gplots) # gráficos
library(lubridate) # datas
library(plotly) # gráficos
library(reshape2) # transformação de dados

### base 1 = internamentos por paciente
int_pac <- read.csv2('internamento_paciente.csv', sep = ';') # carga

colnames(int_pac) <- c('unidade', 'k_sol', 'k_int', 'k_unidade', 'k_pmr', 'macro', 'geres', 'municipio', 'hospital', 'tipo_leito', 'tipo_leito2', 'esp_leito', 'data_int', 'data_alta', 'dias_alta', 'int_liq', 'int', 'auto_int', 'status_sol', 'data_sol', 'unidade_sol', 'macro2', 'geres2', 'municipio2') # nomes de colunas

# hospital

## tratamentos de datas
int_pac$data_int <- as.Date(int_pac$data_int, format = "%d/%m/%y")
int_pac$data_alta <- as.Date(int_pac$data_alta, format = "%d/%m/%y")
int_pac$data_sol <- as.Date(int_pac$data_sol, format = "%d/%m/%y")
int_pac$int_sol_dia <- ifelse(
  int_pac$data_int == int_pac$data_sol, 1, 0
)

# int_pac <- subset(int_pac, data_int <= '2020-03-28')

## tratamento de fatores
int_pac$esp_leito <- as.factor(int_pac$esp_leito)

## novas colunas e dimensões
int_pac$dias_sol <- int_pac$data_int - int_pac$data_sol
max_dt_int <- max(int_pac$data_int)
max_dt_alta <- max(int_pac$data_alta)

### base 2 = solicitacoes
sol_pac <- read.csv2('solicitacao.csv', sep = ';') # carga

colnames(sol_pac) <- c('unidade', 'k_sol', 'k_pac', 'k_censo', 'nro_sol', 'macro', 'geres', 'municipio', 'prioridade', 'status_sol', 'tipo_leito', 'tipo2', 'esp_leito', 'data_sol', 'risco', 'sol', 'unidade_int', 'hospital_int', 'macro2', 'geres2', 'municipio2') # nomes de colunas

## tratamentos de datas
sol_pac$data_sol <- as.Date(sol_pac$data_sol, format = "%d/%m/%y")

# sol_pac <- subset(sol_pac, data_sol <= '2020-03-28')

## novas colunas e dimensões
max_dt_sol <- max(sol_pac$data_sol)

### base 3 = leitos
leito <- read.csv2('leitos.csv', sep = ';') # carga

# shape_pe <- shapefile("26MUE250GC_SIR.shp")

colnames(leito) <- c('tipo_leito' , 'tipo_leito2', 'esp_leito', 'unidade', 'k_ocup', 'k_unidade', 'data_ocup', 'status_inicial', 'tipo_int', 'status_leito', 'sexo_leito', 'leito', 'leito_oper', 'hospital', 'regiao', 'municipio', 'lat', 'long', 'tipo_leito3', 'tipo_leito4') # nomes de colunas

## tratamentos de datas
leito$data_ocup <- as.Date(leito$data_ocup, format = "%d/%m/%y")

leito <- leito %>% filter(unidade != 2395 & unidade != 2845 & unidade != 2847 & unidade != 2932 & unidade != 3901 & unidade != 5876 & unidade != 6334 & unidade != 6748 & unidade != 6805)

#leito$Estabelecimento.Internamento <- as.factor(leito$Estabelecimento.Internamento)

## listas

list_hosp <- unique(factor(leito$hospital))

# leito <- subset(leito, data_ocup <= '2020-03-28')

## novas colunas e dimensões
min_dt_leito <- min(leito$data_ocup)
max_dt_leito <- max(leito$data_ocup)

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

########
int_total <- read.csv2('internamento_total.csv', sep = ';')

### base 5 = historico_solicitacoes

sol_hist_nova <- read.csv2('historico_solicitacao_nova.csv', sep = ';') 

colnames(sol_hist_nova) <- c('lk_solicitacao', 'data_sol',  'hr_hist_sol', 'cod_sol', 'status_sol', 'unidade_sol', 'prioridade', 'tipo_leito_sol', 'tipo2_leito_sol', 'esp_leito_sol', 'tipo_leito_reg', 'tipo2_leito_reg', 'esp_leito_reg', 'sol', 'dt_base_sol', 'dt_hist_sol', 'status_hist_sol', 'tempo_sol', 'posicao_fila', 'sol_hist', 'lista', 'lista_dia', 'macro2', 'geres2', 'municipio2')

sol_hist_nova$data_sol <- as.Date(sol_hist_nova$data_sol, format = "%d/%m/%y")
sol_hist_nova$dt_base_sol <- as.Date(sol_hist_nova$dt_base_sol, format = "%d/%m/%y")
sol_hist_nova$dt_hist_sol <- as.Date(sol_hist_nova$dt_hist_sol, format = "%d/%m/%y")

max_dt_base_sol <- max(sol_hist_nova$dt_base_sol)

# sol_hist <- read.csv2('historico_solicitacao.csv', sep = ';') # carga
# 
# colnames(sol_hist) <- c('unidade_sol', 'lk_solicitacao', 'status_hist_sol', 'dt_hist_sol', 'hr_hist_sol', 'dt_fim_sol', 'hr_fim_sol', 'sol_hist', 'tempo_sol', 'tipo_leito_sol', 'esp_leito_sol', 'tipo_leito_reg', 'esp_leito_reg', 'macro1', 'geres1', 'municipio1', 'macro2', 'geres2', 'municipio2') # nomes de colunas
# 
# ## tratamentos de datas
# sol_hist$dt_hist_sol <- as.Date(sol_hist$dt_hist_sol, format = "%d/%m/%y")
# sol_hist$dt_fim_sol <- as.Date(sol_hist$dt_fim_sol, format = "%d/%m/%y")
# 
# ## novas colunas e dimensões
# max_dt_hist_sol <- max(sol_hist$dt_fim_sol)

###################### LEITOS PRIVADOS ##########################
leitos_privados_load <- read.csv2('leitos_privados.csv', sep = ';', encoding = "UTF-8")

leitos_privados <- leitos_privados_load

colnames(leitos_privados) <- c('time_stamp', 'hospital',
                               'uti_adulto_c19_op', 'uti_adulto_c19_oc', 'uti_adulto_c19_lv', 'uti_adulto_c19_bl',
                               'uti_infantil_c19_op', 'uti_infantil_c19_oc', 'uti_infantil_c19_lv', 'uti_infantil_c19_bl',
                               'enf_adulto_c19_op', 'enf_adulto_c19_oc', 'enf_adulto_c19_lv', 'enf_adulto_c19_bl',
                               'enf_infantil_c19_op', 'enf_infantil_c19_oc', 'enf_infantil_c19_lv', 'enf_infantil_c19_bl',
                               'enf_obstetrica_c19_op', 'enf_obstetrica_c19_oc', 'enf_obstetrica_c19_lv', 'enf_obstetrica_c19_bl',
                               'apt_adulto_c19_op', 'apt_adulto_c19_oc', 'apt_adulto_c19_lv', 'apt_adulto_c19_bl',
                               'apt_infantil_c19_op', 'apt_infantil_c19_oc', 'apt_infantil_c19_lv', 'apt_infantil_c19_bl',
                               'apt_obstetrica_c19_op', 'apt_obstetrica_c19_oc', 'apt_obstetrica_c19_lv', 'apt_obstetrica_c19_bl',
                               'ventiladores_operacionais', 'ventiladores_uso', 'ventiladores_livres', 'ventiladores_bloqueados',
                               'uti_nao_c19_lv', 'enf_nao_c19_lv', 'apt_nao_c19_lv')

leitos_privados <- leitos_privados %>% replace(is.na(.), 0)
