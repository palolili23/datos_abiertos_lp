library(rio)
library(tidyverse)
library(here)
library(janitor)
library(tidytext)

## Fuente: https://datos.gob.bo/dataset/indicadores-de-poblacion-segun-departamento-y-municipio-censo-2012/resource/102243d4-f2f4-4cdc-b26c-624eec13028b

colors <- c("#d11141", "#ffc425", "#00b159")

censo <- import(here::here("00_datos_crudos", "indicadores_municipios_cpv-2012_cod.csv"))
colnames(censo)

deptos <- import(here::here("00_datos_crudos", "comunidades.xlsx")) %>% 
  clean_names()
  
deptos <- deptos %>% 
  rename(depto = x1,
         prov = x2) %>% 
  fill(depto, prov) %>% 
  filter(!is.na(codigo))

deptos <- deptos%>% 
  mutate(depto = ifelse(str_detect(depto, "Departamento de Potos"),
                        "Departamento de Potosi", depto))

censo <- censo %>% 
  left_join(deptos, by = c("cod.mun" = "codigo"))

export(censo, here::here("02_datos_limpios", "censo.csv"))

censo %>% 
count(departamento_y_municipio, sort = TRUE)

