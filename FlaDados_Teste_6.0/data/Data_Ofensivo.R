library(dplyr)
library(tidyverse)
library(janitor)
library(stringr)

# --- 1. Dataset FBref do Brasileirão  (MANUAL) ---

analise_brasileirao_ofensivo <- tribble(
  ~time, ~Gols_Gls, ~x_G, ~assistencias_Ast, ~passes_progressivos_PrgP, ~conducao_progressiva_PrgC, ~jogos,
  "Flamengo", 59, 45.0, 59, 1564, 523, 30,
  "Palmeiras", 54, 45.0, 37, 1182, 471, 30 ,
  "Cruzeiro", 44, 41.2, 36, 1062, 477, 31,
  "Atlético-MG", 25, 30.6, 17, 1211, 483, 30,
  "Fluminense", 36, 31.9, 19, 1133, 509, 31,
  "Botafogo", 41, 38.9, 32, 1233, 510, 31,
  "São Paulo", 35, 40.0, 28, 1145, 467, 31
) %>% clean_names()

print(head(analise_brasileirao_ofensivo))