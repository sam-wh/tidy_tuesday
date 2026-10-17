library(showtext)
library(patchwork)
library(ggtext)

font_add_google(name = "League Spartan", family = "league")
showtext_auto()
title_font <- "league"
body_font <- "league"

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
  
  base_plot <- quick_map(working_df, plot_col = "iso_a2", verbose = FALSE, zoom = "Africa", theme = "Viridis") +
    theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, size = 30, margin = margin( 1 , 1 , 15, 1)), 
        title = element_text(family = "league")
  )
}

plot_laevis <- frog_mapper(ploidy_series[2]) +
  labs(title = "Xenopus laevis (4n)")

plot_trop <- frog_mapper(ploidy_series[1]) +
  labs(title = "Xenopus tropicalis (2n)") 

plot_wittei <- frog_mapper(ploidy_series[3]) +
  labs(title = "Xenopus wittei (8n)") 

plot_ruw <- frog_mapper(ploidy_series[4]) +
  labs(title = "Xenopus ruwenzoriensis (12n)")


# patchwork --------------------------------------------
subtitle = "Frogs from the genus *Xenopus* are commonly used in biological research. These frogs are often polyploid, which means that they contain more than two copies of their entire genome, e.g. a dodecaploid ('12n') animal has twelve (!) copies of its genome."

plot_trop + plot_laevis + plot_wittei + plot_ruw +
  plot_annotation(title = "Representative Xenopus species and their geographic distribution",
                  subtitle = subtitle,
                  caption = "Made by @ssamwh.bsky.social for TidyTuesday 2026 #41, AmphibiaWeb",
                  theme = theme(
                    plot.margin = margin(20,5,5,5),
                    plot.title = element_textbox_simple(
                      margin = margin(b = 5, t = 5),
                      size = 35,
                      face = "bold",
                      hjust = 0.5,
                      halign = 0.5,
                      lineheight = 0.75,
                      family = title_font),
                    plot.subtitle = element_textbox_simple(
                      margin = margin(b = 10, t = 15),
                      size = 20,
                      width = 1,
                      family = body_font,
                      lineheight = 0.8
                    ),
                    plot.caption = element_textbox_simple(
                      size = 20,
                      family = body_font
                    )
                  )
  )