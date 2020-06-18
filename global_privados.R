################# leitos privados ##########
# library(googlesheets4)
# library(googlesheets)
# 
# leitos_privados_load <- read_sheet("https://docs.google.com/spreadsheets/d/1yYrPDrLBSCVbewG1QW63E9-0Q7omvuLPJj_qRFSR7E0/edit?ts=5eb009dc#gid=2104057806")
# 
# gs_download('https://docs.google.com/spreadsheets/d/1yYrPDrLBSCVbewG1QW63E9-0Q7omvuLPJj_qRFSR7E0/export?format=csv')

leitos_privados_load <- read.csv2('leitos_privados.csv', sep = ';')

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

leitos_privados <- leitos_privados %>% arrange(desc(time_stamp))

leitos_privados_uti <- select(leitos_privados, c(time_stamp, hospital, starts_with("UTI")))

leitos_privados_enf <- select(leitos_privados, c(time_stamp, hospital, starts_with("enf")))

leitos_privados_apt <- select(leitos_privados, c(time_stamp, hospital, starts_with("apt")))

leitos_privados_vent <- select(leitos_privados, c(time_stamp, hospital, starts_with("vent")))


<!-- Leitos Privados {data-icon="fa-first-aid"} -->
  <!-- =====================================  -->
  
  <!-- Row {.tabset data-height=600} -->
  <!-- ------------------------------------- -->
  
  <!-- ### UTI -->
  
  <!-- ```{r} -->
  <!-- renderDT({ -->
      <!-- datatable(leitos_privados_uti,  -->
                       <!--           filter = 'top', -->
                       <!--           options = list( -->
                                                        <!-- scrollY = '400px', paging = FALSE, scrollX = TRUE)  -->
                       <!-- ) -->
      <!-- }) -->
  <!-- ``` -->
  
  <!-- ### Enfermaria -->
  
  <!-- ```{r} -->
  <!-- renderDT({ -->
      <!-- datatable(leitos_privados_enf,  -->
                       <!--           filter = 'top', -->
                       <!--           options = list( -->
                                                        <!-- scrollY = '400px', paging = FALSE, scrollX = TRUE)  -->
                       <!-- ) -->
      <!-- }) -->
  <!-- ``` -->
  
  <!-- ### Apartamento -->
  
  <!-- ```{r} -->
  <!-- renderDT({ -->
      <!-- datatable(leitos_privados_apt,  -->
                       <!--           filter = 'top', -->
                       <!--           options = list( -->
                                                        <!-- scrollY = '400px', paging = FALSE, scrollX = TRUE)  -->
                       <!-- ) -->
      <!-- }) -->
  <!-- ``` -->
  
  <!-- ### Ventiladores -->
  
  <!-- ```{r} -->
  <!-- renderDT({ -->
      <!-- datatable(leitos_privados_vent,  -->
                       <!--           filter = 'top', -->
                       <!--           options = list( -->
                                                        <!-- scrollY = '400px', paging = FALSE, scrollX = TRUE)  -->
                       <!-- ) -->
      <!-- }) -->
  <!-- ``` -->