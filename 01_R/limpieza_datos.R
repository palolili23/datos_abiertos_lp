library(rio)
library(tidyverse)
library(here)
library(janitor)
library(tidytext)

## Fuente: https://datos.gob.bo/dataset/indicadores-de-poblacion-segun-departamento-y-municipio-censo-2012/resource/102243d4-f2f4-4cdc-b26c-624eec13028b

colors <- c("#d11141", "#ffc425", "#00b159")

censo <-
  import(here::here(
    "00_datos_crudos",
    "indicadores_municipios_cpv-2012_cod.csv"
  ))
colnames(censo)
str(censo)

comunidades <- read_csv(here::here("00_datos_crudos", "comunidades.csv")) %>% 
  clean_names() 

comunidades <- comunidades %>% 
  rename(depto = x1,
         provincia = x2) %>% 
  fill(depto, provincia) %>% 
  filter(!is.na(codigo))

comunidades <- comunidades %>% 
  mutate(depto = ifelse(str_detect(depto, "Departamento de Potos"),
                        "Departamento de Potosi", depto),
         depto = str_remove(depto, "Departamento de "),
         provincia = str_remove(provincia, "Provincia "))


censo <- censo %>% 
  left_join(comunidades, by = c("cod.mun" = "codigo")) %>% 
  select(-departamento_y_municipio)

variables_numericas <- 
  
variables_numericas <- censo %>% 
  select(everything(),
         -cod.mun,
         - depto,
         - provincia,
         - municipio,
         - otros_nombres) %>% 
  colnames()

censo <- censo %>% 
  mutate_all(~str_replace(., ",", ".")) %>% 
  mutate_at(.vars = c(variables_numericas), parse_number)

str(censo)

export(censo, here::here("02_datos_limpios", "censo.csv"))

