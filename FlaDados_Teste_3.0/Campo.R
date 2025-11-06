# Certifique-se de que o pacote dplyr está carregado
library(dplyr) 

# Dados originais (Mantendo)
analise <- data.frame(
  time = c("Flamengo", "Palmeiras", "Cruzeiro","Botafogo","Fluminense","São Paulo","Atlético-MG"),
  criatividade_ofensiva = c(54.10, 40.63, 35.41 , 40.80 , 37.16 , 37.83 , 40.93),
  intensidade_ataque = c(524.5, 472.5, 478.3 , 511.2 ,510.0 , 468.2 , 484.0), Gols_Gls = c(59, 54, 44, 41, 36 ,35 , 25)
)
print(analise)
str(analise)
# ----------------------------------------------------------------------
# NOVO CÁLCULO DE COORDENADAS: Normalização para usar o campo como Eixo X/Y
# ----------------------------------------------------------------------
max_int <- max(analise$intensidade_ataque)
min_int <- min(analise$intensidade_ataque)
max_cria <- max(analise$criatividade_ofensiva)
min_cria <- min(analise$criatividade_ofensiva)


dados_campo_uefa <- analise %>%
  mutate(
    range_int = max_int - min_int,
    range_cria = max_cria - min_cria,
    
    # NOVO X: Normaliza de 10 a 90 (Dando margem nas bordas)
    x_coordenada_tatico = ifelse(range_int == 0, 50, 
                                 ((intensidade_ataque - min_int) / range_int) * 80 + 10), 
    
    # NOVO Y: Normaliza de 10 a 90 (Dando margem nas bordas)
    y_coordenada_tatico = ifelse(range_cria == 0, 50, 
                                 ((criatividade_ofensiva - min_cria) / range_cria) * 80 + 10),
    
    # Ajuste do tamanho do ponto (mantido)
    tamanho_ponto = 2 + (intensidade_ataque - min(intensidade_ataque)) /
      (max(intensidade_ataque) - min(intensidade_ataque)) * 5
  )

print(dados_campo_uefa %>% filter(time == "Flamengo"))


# Visualização Do Campo (ATUALIZADA)

p_uefa <- ggplot(dados_campo_uefa, aes(x = x_coordenada_tatico, y = y_coordenada_tatico)) +
  # Adiciona o campo de futebol com as dimensões UEFA
  annotate_pitch(
    dimensions = DIMENSOES_UEFA,
    fill = "#377d22",
    colour = "white",
    # O ataque será da esquerda para a direita (X=0 para X=100)
  ) +
  
  # Adiciona Linhas de Referência (Quadrantes Táticos)
  geom_vline(xintercept = 50, linetype = "dashed", color = "white", alpha = 0.5) +
  geom_hline(yintercept = 50, linetype = "dashed", color = "white", alpha = 0.5) +
  
  # Adiciona os dados como pontos (usando as novas coordenadas)
  geom_point(
    aes(size = tamanho_ponto, color = criatividade_ofensiva),
    alpha = 0.8,
    stroke = 1.5
  ) +
  
  # Adiciona os rótulos dos times (usando as novas coordenadas)
  geom_text_repel(
    aes(label = time),
    color = "white",
    size = 4,
    box.padding = 1.0,
    point.padding = 1.0,
    #Nudge desnecessário, a posição agora é significativa
    segment.color = 'gray'
  ) +
  
  # Define a escala de cores (para Criatividade)
  scale_colour_gradient(
    low = "blue",
    high = "red",
    name = "Criatividade Ofensiva"
  ) +
  
  # Define a escala de tamanhos (para Intensidade)
  scale_size(
    name = "Intensidade de Ataque"
  ) +
  
  # Aplica o tema do ggsoccer
  theme_pitch() +
  theme(legend.position = "bottom")+ # Legenda embaixo para não atrapalhar o diagrama
  
  # Adiciona títulos
  labs(
    title = "Diagrama Tático de Performance Ofensiva - Brasileirão",
    subtitle = "Profundidade (X): Intensidade | Largura (Y): Criatividade. Círculo: Gols marcados. Cor: Criatividade."
  ) +
  
  # Ajusta as coordenadas para mostrar o espectro tático completo e remove o coord_flip
  coord_fixed(xlim = c(-5, 105), ylim = c(-5, 105)) 

print(p_uefa)