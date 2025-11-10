library(ggplot2)
library(ggrepel)
library(dplyr)
library(ggsoccer)


analise_of <- readRDS("data_clean/analise_ofensivo.rds")
print(analise_of)

plot_diagrama_tatico <- function(analise_of, 
                                 time_col = "time",
                                 criatividade_col = "criatividade_ofensiva", 
                                 intensidade_col = "intensidade_ataque",
                                 gols_col = "gols_gls",
                                 titulo = "Diagrama Tático de Performance Ofensiva",
                                 subtitulo = "Profundidade (X): Intensidade | Largura (Y): Criatividade. Círculo: Gols marcados. Cor: Criatividade.",
                                 cor_baixa = "blue",
                                 cor_alta = "red") {

  
  
  # Verificar se as colunas necessárias existem
  colunas_necessarias <- c(time_col, criatividade_col, intensidade_col, gols_col)
  if (!all(colunas_necessarias %in% names(analise_of))) {
    stop("Colunas necessárias não encontradas no dataframe")
  }
  
  dimencoes_campo <- list(
    length = 105,
    width = 68,
    penalty_box_length = 16.5,
    penalty_box_width = 40.32,
    six_yard_box_length = 5.5,
    six_yard_box_width = 18.32,
    penalty_spot_distance = 11,
    goal_width = 7.32,
    origin_x = 0,
    origin_y = 0
  )
  
  # Cálculo das coordenadas normalizadas
  max_int <- max(analise_of[[intensidade_col]])
  min_int <- min(analise_of[[intensidade_col]])
  max_cria <- max(analise_of[[criatividade_col]])
  min_cria <- min(analise_of[[criatividade_col]])
  
  dados_campo <- analise_of %>%
    mutate(
      range_int = max_int - min_int,
      range_cria = max_cria - min_cria,
      
      # Coordenada X: Intensidade de Ataque (10 a 90)
      x_coordenada_tatico = ifelse(range_int == 0, 50, 
                                   ((.data[[intensidade_col]] - min_int) / range_int) * 80 + 10),
      
      # Coordenada Y: Criatividade Ofensiva (10 a 90)
      y_coordenada_tatico = ifelse(range_cria == 0, 50, 
                                   ((.data[[criatividade_col]] - min_cria) / range_cria) * 80 + 10),
      
      # Tamanho do ponto baseado na intensidade
      tamanho_ponto = 2 + (.data[[intensidade_col]] - min_int) / (max_int - min_int) * 5
    )
  
  
  
  
  ### Visualização Campo ###
  p <- ggplot(dados_campo, aes(x = x_coordenada_tatico, y = y_coordenada_tatico)) +
    
    # Campo de futebol UEFA
    annotate_pitch(
      dimensions = dimencoes_campo,
      fill = "#377d22",
      colour = "white"
    ) +
    
    # Linhas de referência (quadrantes táticos)
    geom_vline(xintercept = 50, linetype = "dashed", color = "white", alpha = 0.5) +
    geom_hline(yintercept = 50, linetype = "dashed", color = "white", alpha = 0.5) +
    
    # Pontos dos times
    geom_point(
      aes(size = tamanho_ponto, color = .data[[criatividade_col]]),
      alpha = 0.8,
      stroke = 1.5
    ) +
    
    # Rótulos dos times
    geom_text_repel(
      aes(label = .data[[time_col]]),
      color = "white",
      size = 4,
      box.padding = 1.0,
      point.padding = 1.0,
      segment.color = 'gray'
    ) +
    
    # Escalas
    scale_colour_gradient(
      low = cor_baixa,
      high = cor_alta,
      name = "Criatividade Ofensiva"
    ) +
    
    scale_size(
      name = "Intensidade de Ataque",
      range = c(3, 8)  # Tamanho mínimo e máximo dos pontos
    ) +
    
    # Tema e formatação
    theme_pitch() +
    theme(legend.position = "none") +
    
    # Títulos
    labs(
      title = titulo,
      subtitle = subtitulo,
      x = NULL,
      y = NULL
    ) +
    
    coord_fixed(xlim = c(-5, 105), ylim = c(-5, 105))
    
  
  return(p)
  
}
plot_diagrama_tatico(analise_of)

