library(ggplot2)
library(dplyr)
library(ggrepel)

# ANÁLISE OFENSIVA
cat("Realizando análise ofensiva...")

analise_brasileirao_ofensiva <- analise_brasileirao %>%
  mutate(
    eficiencia_finalizacao = round(Gols_Gls / x_G, 2),
    criatividade_ofensiva = round((assistencias_Ast + passes_progressivos_PrgP) / jogos, 1),
    intensidade_ataque = round(assistencias_Ast / jogos, 1),
    eficiencia_finalizacao = round(passes_progressivos_PrgP + intensidade_ataque / Gols_Gls * 100, 1)
  ) %>%
  select(time, Gols_Gls, x_G, assistencias_Ast, passes_progressivos_PrgP, 
         conducao_progressiva_PrgC,jogos,criatividade_ofensiva, intensidade_ataque) %>%
  arrange(desc(Gols_Gls))


print(analise_brasileirao_ofensiva)


cat(" Análise Ofensiva Efetuada Com Sucesso !")

# VISUALIZAÇÃO 1: xG vs Gols
cat("📈 Criando visualizações...\n")
p1 <- ggplot(analise_brasileirao_ofensiva, aes(x = x_G, y = Gols_Gls, label = time)) +
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

cat(" Visualização : Eficiência ofensiva (xG vs Gols)")

# VISUALIZAÇÃO 2: Criatividade vs Intensidade
p2 <- ggplot(analise_brasileirao_ofensiva, aes(x = criatividade_ofensiva, y = intensidade_ataque, label = time)) +
  geom_bar(aes(fill = Gols_Gls), stat = 'identity') +
  geom_text_repel(size = 3) +
  scale_color_gradient(low = "black", high = "red", name = "Gols") +
  labs(title = "Criatividade vs Intensidade Ofensiva",
       subtitle = "Como os times criam oportunidades",
       x = "Criatividade Ofensiva ",
       y = "Intensidade de Ataque ") +
  theme_minimal()+
  theme(legend.position = "none")

print(p2)

cat(" Criatividade vs Intensidade\n")