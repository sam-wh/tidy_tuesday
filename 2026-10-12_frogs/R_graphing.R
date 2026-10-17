library(showtext)
library(patchwork)

font_add_google(name = "League Spartan", family = "league")
showtext_auto()

# DRAFT MAP of what countries have the most native frog species
base_plot_sp_distribution <- ggplot() +
  geom_sf(data = df_summary, aes(fill = n)) +
  scale_fill_paletteer_c("grDevices::Greens 3") 

base_plot_sp_distribution

base_plot_ploid <- ggplot() +
  geom_sf(data = df_ploidy, aes(fill = iso_a2)) +
  facet_wrap(~specificepithet) 


# making the base plots ---------------------------------------------------

frog_mapper <- function(subspecies) {
  working_df <- df_longer |>
    filter(specificepithet == subspecies)
  
  base_plot <- quick_map(working_df, plot_col = "iso_a2", verbose = FALSE, zoom = "Africa", theme = "Viridis") 
}

plot_laevis <- frog_mapper("laevis") +
  labs(title = "Xenopus laevis (4n)") +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, size = 30, margin = margin( 1 , 1 , 0, 1)), 
        title = element_text(family = "league")
  )

plot_trop <- frog_mapper(ploidy_series[1]) +
  labs(title = "Xenopus tropicalis (2n)") +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, size = 30, margin = margin( 1 , 1 , 0, 1)), 
        title = element_text(family = "league")
  )

plot_wittei <- frog_mapper(ploidy_series[3]) +
  labs(title = "Xenopus wittei (8n)") +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, size = 30, margin = margin( 1 , 1 , 0, 1)), 
        title = element_text(family = "league")
  )

plot_ruw <- frog_mapper(ploidy_series[4]) +
  labs(title = "Xenopus ruwenzoriensis (12n)") +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, size = 30, margin = margin( 1 , 1 , 0, 1)), 
        title = element_text(family = "league")
  )


# cowplotter? I hardly know er --------------------------------------------

base_overplot <- plot_grid(
  plot_trop, plot_laevis, plot_wittei, plot_ruw,
  ncol = 2)

labeller <- function(text, fontface, font_size) {
  ggdraw() +
    draw_label(
      text,
      x = 0,
      fontface = fontface,
      fontfamily = "league",
      size = font_size, 
      hjust = 0) +
  theme(
    plot.margin = margin(0, 0, 0, 0))
}

title_label <- labeller("Chromosomes", "bold", 50)

title <- ggdraw() +
  draw_label(
    "Chromosomes",
    fontface = 'bold', 
    x = 0,
    fontfamily = "league",
    size = 50,
    hjust = 0
    ) +
  theme(
    plot.margin = margin(0, 0, 20, 7)
  )

library(cowplot)
plot_grid(
  title, base_overplot,
  ncol = 1)

plot_trop + plot_laevis + plot_wittei + plot_ruw +
  plot_annotation("Representative Xenopus species and their geographic distribution",
                  caption = "Made by @ssamwh.bsky.social for TidyTuesday 2026 no. 41",
                  theme = theme(plot.title = element_text(size = 40, family = "league", hjust = 0.5),
                                plot.caption = element_text(size = 20, family = "league"))
  )
