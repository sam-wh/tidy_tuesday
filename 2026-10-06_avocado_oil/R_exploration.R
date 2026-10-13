library(tidyverse)

df <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-10-06/avocado_oil_bottles.csv')
df_foods <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-10-06/avocado_oil_processed_foods.csv")

# vibe check: idk what does this dataset *look* like?
df |>
  ggplot(aes(x = cost_per_fl_oz, y = c16_1_palmitoleic_pct, color = purity_result)) + 
  geom_point(size = 3)

# I'm only interested how expensive the oil is, how pure it is, whether 
#it's real, and the fatty acids/sterols that were tested. 
df_long <- df |>
  select(
    sample_code,
    cost_per_fl_oz,
    purity_result,
    ends_with("pct")
  ) |>
  pivot_longer(
    cols = ends_with("pct"),
    names_to = "adulterant",
    values_to = "percent"
  )

# vibe check: 
# do any indicators in the adulterated group seem to cluster together? 
df_long |>
  ggplot(aes(x = cost_per_fl_oz, y = percent, group = adulterant,
             color = purity_result)) +
  geom_point() +
  facet_wrap(~adulterant)

# pulling those five oil components out to see what is up
df_long_clustered <- df_long |>
  filter(adulterant %in% c("beta_sitosterol_pct", "c18_1_oleic_pct",
                           "c18_3_linolenic_pct", "campesterol_pct",
                           "stigmasterol_pct"))


# examining the processed foods to see whether I can tell what's been adulterated by the lipids

df_foods_long <- df_foods |>
  select(
    sample_number,
    retail_price_usd,
    authentic,
    ends_with("pct")
  ) |>
  pivot_longer(
      cols = ends_with("pct"),
      names_to = "adulterant",
      values_to = "percent"
    )
    
df_foods_long |>
  ggplot(aes(x = retail_price_usd, y = percent, group = adulterant,
             color = authentic)) +
  geom_point() +
  facet_wrap(~adulterant)



df_foods_long_clustered <- df_foods_long |>
  filter(adulterant %in% c("beta_sitosterol_pct", "c18_1_oleic_pct",
                           "c18_2_linoleic_pct",
                           "campesterol_pct",
                           "stigmasterol_pct"))
