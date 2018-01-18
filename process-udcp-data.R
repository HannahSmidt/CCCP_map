# Task: Download and manipulate UCDP data

download.file(url = "http://ucdp.uu.se/downloads/ged/ged171-csv.zip", destfile = "data-raw/ucdp-data.zip")
unzip(exdir = "data-raw/ucdp-data", zipfile = "data-raw/ucdp-data.zip")

ged171 <- read_csv("data-raw/ucdp-data/ged171.csv")


excluded_dyads <- c("Government of Congo|Zimbabwe|Angola|Uganda") # Governments that are not the ones of the focus cases

focus_country_names <- c("Colombia",
                         "Venezuela",
                         "Rwanda",
                         "Burundi",
                         "DR Congo (Zaire)",
                         "Afghanistan",
                         "Pakistan",
                         "Iraq",
                         "Mexico",
                         "Myanmar (Burma)",
                         "Somalia",
                         "Philippines",
                         "Ukraine",
                         "Nigeria")

focus_dyads <- ged171 %>%
  filter(country %in% focus_country_names) %>%
  select(dyad_name) %>%
  .[[1]] %>%
  unique()


gedDataR <- ged171 %>%
  filter(dyad_name %in% focus_dyads) %>%
  filter(!grepl(excluded_dyads, dyad_name)) %>%
  select(country, year, dyad_name, best, type_of_violence, latitude, longitude) %>%
  rename(type_of_vi = type_of_violence) %>%
  distinct()
