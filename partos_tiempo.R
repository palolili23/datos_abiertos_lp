library(tidyverse)
library(here)
here()


path <- paste0(here(), "/00_datos_crudos/partos/")

files <- fs::dir_ls(path, regexp = "\\.csv$")

files


data_list <- files %>% 
  map(read_csv2) 

names_data <- names(data_list)

names_data <- str_extract(names_data, "[2](.*)[^.csv]")

names_data

data_list <- Map(cbind, data_list, anio = names_data)
data_list <- map2(data_list, cbind, anio = names_data)

data_list %>% pluck(1)
data_list_columns <-
  data_list %>% 
  pluck(1) %>% 
  colnames()

data_list %>% map(data_list_columns, select)

insdata_list %>% 
  select(data_list_columns)

bind_rows(data_list)
