library(dplyr)
library(tidyverse)
library(janitor)
library(stringr)


# =========================================================================
# ANÁLISE DEFENSIVA 
# =========================================================================
cat("\n--- ANÁLISE DEFENSIVA: Intensidade de Pressing ---\n")

# Usando tribble para simular a base de dados com PPDA e Press
analise_brasileirao_defesa <- tribble(
  ~time, ~MP, ~Press, ~PPDA,
  "Flamengo", 30, 1950, 9.2,
  "Palmeiras", 30, 2010, 8.5,
  "Cruzeiro", 31, 1750, 9.8,
  "Atlético-MG", 30, 1780, 10.1,
  "Fluminense", 31, 1500, 11.5,
  "Botafogo", 31, 2200, 7.9,
  "São Paulo", 31, 1850, 9.9
)
