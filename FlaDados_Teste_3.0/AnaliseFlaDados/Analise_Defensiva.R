library(ggrepel)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(janitor)
library(stringr)

# ----------------------------------------------------------------------
# CÁLCULO DAS MÉTRICAS DEFENSIVAS
# ----------------------------------------------------------------------

analise_brasileirao_defensiva <- analise_brasileirao_defesa %>%
  mutate(
    # 1. INTENSIDADE DO PRESSING: Pressões por Jogo (Normalizando o total de Press)
    # Quanto maior, mais pressão o time aplica.
    intensidade_pressing = round(Press / MP, 1), 
    
    # 2. EFICIÊNCIA DEFENSIVA (PPDA): Usado diretamente como Eficiência
    # PPDA (Passes por Ação Defensiva). Quanto menor, mais eficiente é a defesa em forçar turnovers.
    eficiencia_defensiva = round(PPDA, 1)  
  ) %>%
  # Selecionar as colunas de interesse
  select(time, PPDA, intensidade_pressing, eficiencia_defensiva) %>% 
  arrange(PPDA)  # Ordenar do menor PPDA (melhor defesa) para o maior

# Exibir a tabela e um insight
print(analise_brasileirao_defensiva)

cat(paste0(
  "INSIGHT: O Flamengo (PPDA de ", 
  analise_brasileirao_defensiva %>% filter(time == "Flamengo") %>% pull(PPDA),
  ") está entre os times com pressing de elite, mas precisa da análise de eventos para refinar a zona de pressão."
))

cat(" Análise Defensiva Efetuada com Sucesso!")

# VISUALIZAÇÃO 3: Análise Defensiva
p3 <- ggplot(analise_brasileirao_defensiva, aes(x = intensidade_pressing, y = PPDA, label = time)) +
  geom_point(aes(size = eficiencia_defensiva, color = PPDA), alpha = 0.7, show.legend = FALSE) +
  geom_text_repel(size = 3) +
  scale_color_gradient(low = "black", high = "red", name = "PPDA") +
  labs(title = "Análise de Pressing e Eficiência Defensiva",
       subtitle = "PPDA mais baixo = defesa mais eficiente | Bolhas menores = melhor",
       x = "Intensidade de Pressing (ações por jogo)",
       y = "PPDA (Passes por Ação Defensiva)") +
  theme_minimal()

print(p3)
