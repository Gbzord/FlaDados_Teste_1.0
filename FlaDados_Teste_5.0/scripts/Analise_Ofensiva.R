library(ggplot2)
library(dplyr)
library(ggrepel)

analise_of <- readRDS("data_clean/analise_ofensivo.rds")

janitor::clean_names(analise_of)


# ANÁLISE OFENSIVA
cat("Realizando análise ofensiva...")

analise_brasileirao_ofensiva <- analise_of %>%
  mutate(
    eficiencia_finalizacao = round(gols_gls / x_g, 2),
    criatividade_ofensiva = round((assistencias_ast + passes_progressivos_prg_p) / jogos, 1),
    intensidade_ataque = round(assistencias_ast / jogos, 1),
    eficiencia_finalizacao = round(passes_progressivos_prg_p + intensidade_ataque / gols_gls * 100, 1)
  ) %>%
  select(time, gols_gls, x_g, assistencias_ast, passes_progressivos_prg_p, 
         conducao_progressiva_prg_c,jogos,criatividade_ofensiva, intensidade_ataque) %>%
  arrange(desc(gols_gls))


print(analise_brasileirao_ofensiva)


cat(" Análise Ofensiva Efetuada Com Sucesso !")

# VISUALIZAÇÃO 1: xG vs Gols

cat("📈 Criando visualizações...\n")
p1 <- ggplot(analise_brasileirao_ofensiva, aes(x = x_g, y = gols_gls, label = time)) +
  geom_point(aes(size = intensidade_ataque , color = intensidade_ataque), alpha = 0.7) +
  geom_text_repel(size = 3) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", alpha = 0.5) +
  scale_color_gradient2(low = "white", mid = "black", high = "red", midpoint = 1) +
  labs(title = "Relação entre xG e Gols - Brasileirão 2025",
       subtitle = "Tamanho e a cor = eficiência de finalização (Gols/xG)",
       x = "xG Esperado", y = "Gols Marcados",
       color = "Eficiência", size = "Eficiência") +
  theme_minimal() +
  theme(legend.position = "none")
theme(plot.title = element_text(face = "bold"))

print(p1)

ggsave("figs/xg_vs_gols.png", p1, width = 8, height = 5)


# VISUALIZAÇÃO 2: Criatividade vs Intensidade
p2 <- ggplot(analise_brasileirao_ofensiva, aes(x = criatividade_ofensiva, y = intensidade_ataque, label = time)) +
  geom_bar(aes(fill = gols_gls), stat = 'identity') +
  geom_text_repel(size = 3) +
  scale_color_gradient(low = "black", high = "red", name = "Gols") +
  labs(title = "Criatividade vs Intensidade Ofensiva",
       subtitle = "Como os times criam oportunidades",
       x = "Criatividade Ofensiva ",
       y = "Intensidade de Ataque ") +
  theme_minimal()+
  theme(legend.position = "none")

print(p2)

ggsave("figs/criatividade_vs_intensidade.png", p2, width = 8, height = 5)
