library(tidyverse)
library(janitor)
library(spData)
library(sf)
library(paletteer)
df <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-10-13/frogs_and_toads_amphibiaweb.csv')

df_xenopus <- df |>
  select(amphib_id,
         family,
         genus,
         specificepithet,
         isocc) |>
  filter(genus == "Xenopus")

names_vector <- paste("native_range_", rep(1:28, by = 1), sep = "")

df_longer <- df_xenopus |>
  separate_wider_delim(cols = isocc,
                       delim = ",",
                       names = names_vector,
                       too_few = "align_start") |>
  pivot_longer(cols = starts_with("native_range"),
               names_to = "native_range",
               values_to = "iso_a2",
               values_drop_na = T
  ) 

# https://r.geocompx.org/solutions/adv-map.html
library(spData)
africa = world |> 
  filter(continent == "Africa") |> 
  left_join(df_longer, by = "iso_a2") |> 
  st_transform("ESRI:102022") |> 
  st_make_valid() |>
  st_collection_extract("POLYGON")

df_summary <- africa |>
  group_by(iso_a2, name_long) |>
  summarise(n = n())

# need to think about how to summarize country by country
df_summary_by_country <- africa |>
  group_by(specificepithet) |>
  summarize(n = n())

# DRAFT MAP of what countries have the most native frog species
base_plot <- ggplot() +
  geom_sf(data = df_summary, aes(fill = n)) +
  scale_fill_paletteer_c("grDevices::Greens 3") 

base_plot
