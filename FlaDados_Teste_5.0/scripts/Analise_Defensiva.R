library(dplyr)
library(ggplot2)
library(ggrepel)

analise_def <- readRDS("data_clean/analise_defensivo.rds")

janitor::clean_names(analise_def)


# ----------------------------------------------------------------------
# CÁLCULO DAS MÉTRICAS DEFENSIVAS
# ----------------------------------------------------------------------

analise_brasileirao_defensiva <- analise_def %>%
  mutate(
    # 1. INTENSIDADE DO PRESSING: Pressões por Jogo (Normalizando o total de Press)
    # Quanto maior, mais pressão o time aplica.
    intensidade_pressing = round(press / jogos, 1), 
    
    # 2. EFICIÊNCIA DEFENSIVA (PPDA): Usado diretamente como Eficiência
    # PPDA (Passes por Ação Defensiva). Quanto menor, mais eficiente é a defesa em forçar turnovers.
    eficiencia_defensiva = round(ppda, 1)  
  ) %>%
  # Selecionar as colunas de interesse
  select(time, ppda, intensidade_pressing, eficiencia_defensiva) %>% 
  arrange(ppda)  # Ordenar do menor PPDA (melhor defesa) para o maior

# Exibir a tabela e um insight
print(analise_brasileirao_defensiva)

cat(paste0(
  "INSIGHT: O Flamengo (PPDA de ", 
  analise_brasileirao_defensiva %>% filter(time == "Flamengo") %>% pull(ppda),
  ") está entre os times com pressing de elite, mas precisa da análise de eventos para refinar a zona de pressão."
))

cat(" Análise Defensiva Efetuada com Sucesso!")

# VISUALIZAÇÃO 3: Análise Defensiva

p3 <- ggplot(analise_brasileirao_defensiva, aes(x = intensidade_pressing, y = ppda, label = time)) +
  geom_point(aes(size = eficiencia_defensiva, color = ppda), alpha = 0.7, show.legend = FALSE) +
  geom_text_repel(size = 3) +
  scale_color_gradient(low = "black", high = "red", name = "PPDA") +
  labs(title = "Análise de Pressing e Eficiência Defensiva",
       subtitle = "PPDA mais baixo = defesa mais eficiente | Bolhas menores = melhor",
       x = "Intensidade de Pressing (ações por jogo)",
       y = "PPDA (Passes por Ação Defensiva)") +
  theme_minimal()

print(p3)
ggsave("figs/pressing_vs_eficiencia_defensiva_por_time.png", p3, width = 8, height = 4)

