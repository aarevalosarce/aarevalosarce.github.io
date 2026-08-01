suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tibble)
  library(purrr)
  library(ggforce)
  library(ragg)
})

# ═══════════════════════════════════════════════════════════════
#  DATOS
# ═══════════════════════════════════════════════════════════════
tomas <- tibble(
  toma = c(
    "Los Laureles\nCerro Chu\u00f1o", "Ajuyu",
    "Alto Molle", "La Mula", "El Boro",
    "G\u00e9nesis", "Balmaceda\nOriente",
    "Quetena", "Calame\u00f1os\nUnidos",
    "Alto Andacollo", "Nuevo\nHorizonte",
    "Paloma +\nPaloma Sur",
    "Centinela", "Aguas Saladas", "Fuerza\nGuerrera",
    "Manuel Bulnes", "Vista Hermosa\n(S.Antonio)", "Fundo Miramar",
    "Nuevo Amanecer", "El Esfuerzo",
    "Naciones\nUnidas-Israel", "Los Aromos",
    "Marichihueo\nDignidad", "Sol de\nSeptiembre",
    "Lamparai\u00edso", "Vista Hermosa\n(Lampa)",
    "Melipilla\nPajaritos", "Tres Poniente",
    "Millantu\nRibera Maipo",
    "Manuel Bustos", "Felipe\nCamiroaga",
    "Re\u00f1aca Alto", "Parcela 11", "Mirador\nLos Pinos"
  ),
  comuna = c(
    "Arica","Arica",
    "Alto Hospicio","Alto Hospicio","Alto Hospicio",
    "Antofagasta","Antofagasta",
    "Calama","Calama",
    "Copiap\u00f3","Copiap\u00f3",
    "Vallenar",
    "San Antonio","San Antonio","San Antonio",
    "San Antonio","San Antonio","San Antonio",
    "Cerrillos","Cerrillos",
    "Colina","Colina",
    "Lampa","Lampa","Lampa","Lampa",
    "Maip\u00fa","Maip\u00fa",
    "Puente Alto",
    "Vi\u00f1a del Mar","Vi\u00f1a del Mar",
    "Vi\u00f1a del Mar","Vi\u00f1a del Mar","Vi\u00f1a del Mar"
  ),
  superficie_ha = c(
    59,46,129,85,80,6,3,18,13,47,15,926,
    73,35,9,15,42,55,20,15,17,19,
    30,62,20,12,6,6,42,
    37,25,27,22,22
  ),
  poblacion = c(
    6646,5581,19681,7497,14247,1868,1136,3784,2703,13506,2442,12287,
    10496,4448,1043,1848,5478,5762,7833,2354,7056,2990,
    8189,7291,5586,4145,4670,2865,10089,
    7608,4275,3054,2963,1827
  )
)

# ═══════════════════════════════════════════════════════════════
#  CÁLCULOS
#  Todos los círculos tienen el MISMO radio (R_FIXED).
#  Los puntos dentro codifican la densidad: 1 punto = SCALE hab/ha
# ═══════════════════════════════════════════════════════════════
R_FIXED  <- 3.8    # radio idéntico para todas las tomas
SPACING  <- 10.8   # separación entre centros
N_COLS   <- 5
SCALE    <- 4      # 1 punto = 4 hab/ha  → máx ~95 puntos, mín ~3

tomas <- tomas %>%
  mutate(
    densidad = round(poblacion / superficie_ha, 1),
    n_dots   = pmax(1L, round(densidad / SCALE))
  ) %>%
  arrange(desc(densidad)) %>%
  mutate(
    idx = row_number() - 1L,
    cx  = (idx %% N_COLS) * SPACING,
    cy  = -(idx %/% N_COLS) * SPACING
  )

# ═══════════════════════════════════════════════════════════════
#  PUNTOS - rejection sampling uniforme
# ═══════════════════════════════════════════════════════════════
set.seed(2026)

pts_circulo <- function(n, cx, cy, r, shrink = 0.91) {
  buf <- matrix(nrow = 0L, ncol = 2)
  lim <- r * shrink
  while (nrow(buf) < n) {
    px <- runif(n * 6L, cx - r, cx + r)
    py <- runif(n * 6L, cy - r, cy + r)
    ok <- (px - cx)^2 + (py - cy)^2 <= lim^2
    buf <- rbind(buf, cbind(px[ok], py[ok]))
  }
  df        <- as.data.frame(buf[seq_len(n), ])
  names(df) <- c("x", "y")
  df
}

dots <- map_dfr(seq_len(nrow(tomas)), function(i) {
  row <- tomas[i, ]
  df  <- pts_circulo(row$n_dots, row$cx, row$cy, R_FIXED)
  df$toma     <- row$toma
  df$densidad <- row$densidad
  df
})

message("Total puntos renderizados: ", nrow(dots),
        "  |  rango: ", min(tomas$n_dots), " – ", max(tomas$n_dots), " por circulo")

# ═══════════════════════════════════════════════════════════════
#  PALETA
# ═══════════════════════════════════════════════════════════════
BG_COLOR    <- "#C9E8F5"
CIRCLE_FILL <- "#FEF6E4"
CIRCLE_EDGE <- "#A8C8DC"
DOT_COLOR   <- "#1B4F72"
TITLE_COLOR <- "#0D2B3E"
SUB_COLOR   <- "#2E6E8E"
META_COLOR  <- "#5A8DA8"
LINE_COLOR  <- "#8BBDD4"

# ═══════════════════════════════════════════════════════════════
#  GRÁFICO
# ═══════════════════════════════════════════════════════════════
p <- ggplot() +
  
  # ── Relleno crema (territorio uniforme)
  geom_circle(
    data = tomas,
    aes(x0 = cx, y0 = cy, r = R_FIXED),
    fill  = CIRCLE_FILL,
    color = CIRCLE_EDGE,
    size  = 0.32
  ) +
  
  # ── Puntos: densidad visual
  geom_point(
    data  = dots,
    aes(x = x, y = y),
    color = DOT_COLOR,
    size  = 0.55, alpha = 0.82, shape = 16
  ) +
  
  # ── Nombre de la toma
  geom_text(
    data      = tomas,
    aes(x = cx, y = cy + R_FIXED + 0.36, label = toma),
    color     = TITLE_COLOR,
    size      = 2.2, vjust = 0, fontface = "bold",
    lineheight = 0.84
  ) +
  
  # ── Densidad numérica bajo el nombre
  geom_text(
    data  = tomas,
    aes(x = cx, y = cy + R_FIXED + 0.16,
        label = paste0(densidad, " hab/ha")),
    color = SUB_COLOR,
    size  = 1.95, vjust = 1
  ) +
  
  # ── Comuna debajo del círculo
  geom_text(
    data  = tomas,
    aes(x = cx, y = cy - R_FIXED - 0.28, label = comuna),
    color     = META_COLOR,
    size      = 1.75, vjust = 1, fontface = "italic"
  ) +
  
  coord_equal(clip = "off") +
  theme_void() +
  theme(
    plot.background  = element_rect(fill = BG_COLOR, color = NA),
    panel.background = element_rect(fill = BG_COLOR, color = NA),
    plot.title       = element_text(
      color = TITLE_COLOR, size = 17, face = "bold",
      hjust = 0, margin = margin(b = 3)),
    plot.subtitle    = element_text(
      color = SUB_COLOR, size = 9,
      hjust = 0, margin = margin(b = 14), lineheight = 1.4),
    plot.caption     = element_text(
      color = META_COLOR, size = 7,
      hjust = 1, margin = margin(t = 8)),
    plot.margin      = margin(t = 22, r = 24, b = 14, l = 24)
  ) +
  labs(
    title    = "Densidad poblacional en las 34 Megatomas de Chile",
    subtitle = paste0(
      "Todos los c\u00edrculos representan la misma superficie relativa.",
      " Cada punto equivale a 4 hab/ha.\n",
      "A mayor n\u00famero de puntos dentro del c\u00edrculo, mayor hacinamiento.",
      " Ordenadas de mayor a menor densidad."
    ),
    caption  = "Fuente: Oficina de Urbanismo Atisba, datos 2025  |  Las \u00daltimas Noticias, 15 abr 2026"
  )

# ═══════════════════════════════════════════════════════════════
#  EXPORTAR - carta portrait 8,5 x 11" @ 300 dpi = 2550 x 3300 px
# ═══════════════════════════════════════════════════════════════
out <- "megatomas_densidad_uniforme.png"

agg_png(out, width = 2550, height = 3300, res = 300, bg = BG_COLOR)
print(p)
invisible(dev.off())

message("Guardado : ", normalizePath(out))
message("Formato  : Carta portrait  8.5 x 11 in  |  300 dpi  |  2550 x 3300 px")
message("Puntos   : ", nrow(dots), " totales  |  rango por circulo: ",
        min(tomas$n_dots), " (", tomas$toma[which.min(tomas$n_dots)], ")",
        " – ", max(tomas$n_dots), " (", tomas$toma[which.max(tomas$n_dots)], ")")
