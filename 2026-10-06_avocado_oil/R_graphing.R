library(ggthemes)
library(paletteer)
library(cowplot)

# I don't want my facet names to look insane, so character vector to rename
# the indicators to their government names 
fatty_acid_names <- c("beta_sitosterol_pct" = "Beta-Sitosterol",
                      "c18_1_oleic_pct" = "Oleic acid",
                      "c18_2_linoleic_pct" = "Linoleic acid (C18:2)",
                      "c18_3_linolenic_pct" = "Linoleic acid (C18:3)",
                      "campesterol_pct" = "Campesterol",
                      "stigmasterol_pct" = "Stigmasterol")

title_oil = "Indicators of adulteration in avocado oils"
title_food = "Indicators of adulteration in avocado oil-fried foods"
xlab = "Cost per fl. oz."
ylab = "Percent"
caption = "For TidyTuesday 2026 #40, by @ssamwh.bsky.social"
legend_title = "Purity"

plot_oil <- df_long_clustered |> 
  ggplot(aes(x = cost_per_fl_oz, y = percent, color = purity_result)) +
  geom_point(size = 2) +
  facet_wrap(~adulterant, labeller = as_labeller(fatty_acid_names)) +
  labs(
    title = title_oil,
    x = xlab,
    y = ylab,
    color = legend_title
    ) +
  scale_color_paletteer_d("yarrr::google", labels = c("Adulterated", "Pure", "Suspected")) +
  theme_pander() +
  theme(plot.margin = margin(0.5,0.5,0.5,0.5, "cm"),
        plot.caption.position = "plot")
    

plot_foods <- df_foods_long_clustered |>
  ggplot(aes(x = retail_price_usd, y = percent, color = authentic)) +
  geom_point(size = 2) +
  facet_wrap(~adulterant, labeller = as_labeller(fatty_acid_names)) +
  labs(
    title = title_food,
    x = "Retail Price",
    y = ylab,
    color = Authenticity,
    caption = caption) +
  scale_color_paletteer_d("yarrr::google", labels = c("Not Authentic", "Authentic")) +
  theme_pander() +
  theme(plot.margin = margin(0.5,0.5,0.5,0.5, "cm"),
        plot.caption.position = "plot")
  
plot_grid(plot_oil, plot_foods)

