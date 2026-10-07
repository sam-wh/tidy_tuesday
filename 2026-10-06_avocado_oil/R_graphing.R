library(ggthemes)
library(paletteer)
library(extrafont)

# I don't want my facet names to look insane, so character vector to rename
# the indicators to their government names 
fatty_acid_names <- c("beta_sitosterol_pct" = "Beta-Sitosterol",
                      "c18_1_oleic_pct" = "Oleic acid",
                      "c18_3_linolenic_pct" = "Linoleic acid",
                      "campesterol_pct" = "Campesterol",
                      "stigmasterol_pct" = "Stigmasterol")

title = "Five indicators are sufficient to suggest adulterated avocado oil"
xlab = "Cost per fl. oz."
ylab = "Percent"
caption = "For TidyTuesday 2026 #40, by @ssamwh.bsky.social"
legend_title = "Purity"
loadfonts(device ="win")

df_long_clustered |> 
  ggplot(aes(x = cost_per_fl_oz, y = percent, color = purity_result)) +
  geom_point(size = 2) +
  facet_wrap(~adulterant, labeller = as_labeller(fatty_acid_names)) +
  labs(
    title = title,
    x = xlab,
    y = ylab,
    color = legend_title,
    caption = caption) +
  scale_color_paletteer_d("yarrr::google", labels = c("Adulterated", "Pure", "Suspected")) +
  theme_pander(base_family = "Hanken Grotesk") +
  theme(plot.margin = margin(0.5,0.5,0.5,0.5, "cm"),
        plot.caption.position = "plot")
    

