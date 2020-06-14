library(tidyverse)
library(janitor)

data_dir <- "00_datos_crudos/partos"

rda_files <- fs::dir_ls(data_dir, regexp = "\\.csv$")

# Importar archivos --------------------------------------------------------------

## El último archivo tiene filas vacias adicionales, una variable extra
## "partos_atendidos_por_provincia" y el nombre de la variable "partos por
## personal de salud" tiene un nombre diferente al resto de variables. Por este
## motivo no podemos usar directamente map_df.

data <- rda_files %>% 
  map(read_csv2, col_types = cols(cod_dep = col_character(),
                                      cod_mun = col_character())) %>% 
  modify_in(7, select, -contains("x"),
            -contains("atendidos_por_prov")) %>% 
  modify_in(7, rename, partos_atendidos_personal_salud = partos_atendidos_por_personal_de_salud_calificado)

data %>% 
  modify(mutate, source = rda_files)

data_completa <- map_dfr(data, bind_rows, .id = "filename")

