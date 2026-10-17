library(tidyverse)
library(countries)
library(maps)

df <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-10-13/frogs_and_toads_amphibiaweb.csv')


df_xenopus <- df |>
  select(amphib_id,
         family,
         genus,
         specificepithet,
         isocc) |>
  filter(genus == "Xenopus")

names_vector <- paste("native_range_", rep(1:28, by = 1), sep = "")
ploidy_series <- c("tropicalis", "laevis", "wittei", "ruwenzoriensis")

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

