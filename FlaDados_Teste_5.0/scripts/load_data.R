library(readr)
library(dplyr)
library(janitor)
library(lubridate)


# =========================================================================
# ANÁLISE DEFENSIVA 
# =========================================================================
cat("Data DEFENSIVA")

# Usando tribble para simular a base de dados com PPDA e Press
analise_brasileirao_defensivo <- tribble(
  ~time, ~jogos, ~Press, ~PPDA,
  "Flamengo", 30, 1950, 9.2,
  "Palmeiras", 30, 2010, 8.5,
  "Cruzeiro", 31, 1750, 9.8,
  "Atlético-MG", 30, 1780, 10.1,
  "Fluminense", 31, 1500, 11.5,
  "Botafogo", 31, 2200, 7.9,
  "São Paulo", 31, 1850, 9.9
)%>% janitor::clean_names()

print(head(analise_brasileirao_defensivo))


cat("Data Ofensiva")


analise_brasileirao_ofensivo <- tribble(
  ~time, ~Gols_Gls, ~x_G, ~assistencias_Ast, ~passes_progressivos_PrgP, ~conducao_progressiva_PrgC, ~jogos,
  "Flamengo", 59, 45.0, 59, 1564, 523, 30,
  "Palmeiras", 54, 45.0, 37, 1182, 471, 30 ,
  "Cruzeiro", 44, 41.2, 36, 1062, 477, 31,
  "Atlético-MG", 25, 30.6, 17, 1211, 483, 30,
  "Fluminense", 36, 31.9, 19, 1133, 509, 31,
  "Botafogo", 41, 38.9, 32, 1233, 510, 31,
  "São Paulo", 35, 40.0, 28, 1145, 467, 31
) %>%
  mutate(
    # 1. Criatividade Ofensiva
    criatividade_ofensiva = (assistencias_Ast + passes_progressivos_PrgP) / jogos,
    
    # 2. Intensidade de Ataque
    intensidade_ataque = conducao_progressiva_PrgC + x_G / jogos,
    
    # 3. Eficiência de Finalização
    eficiencia_finalizacao = Gols_Gls / x_G
  )%>% janitor::clean_names()

print(head(analise_brasileirao_ofensivo))


dir.create("data_clean", showWarnings = FALSE)
saveRDS(analise_brasileirao_ofensivo, file = "data_clean/analise_ofensivo.rds")
saveRDS(analise_brasileirao_defensivo, file = "data_clean/analise_defensivo.rds")
