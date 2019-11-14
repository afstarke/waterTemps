LI water temps 2019
================
Adam Starke
November 14, 2019

Water temperature stations
--------------------------

Exploring temperature data in the Peconics. 2 USGS guage stations exist with continuous data collection.

``` r
# estuarySites <- whatNWISsites(stateCd = "NY", 
#               # water temp C
#               parameterCd = "00010") %>% 
#   filter(site_tp_cd == "ES") %>% 
#   pull(site_no)

peconicSiteIDs <- c("01304200", "01304562")

dailyTemps <- readNWISdv(siteNumbers = peconicSiteIDs, 
                         startDate = "2013-01-01",
                         endDate = "2019-11-01",
                         statCd = c("00001", "00002", "00003"),
                         parameterCd = "00010") %>% 
  dataRetrieval::renameNWISColumns() 


estuarySiteLocations <- readNWISsite(peconicSiteIDs) %>% 
  st_as_sf(coords = c("dec_long_va", "dec_lat_va"), crs = 4269)

mapview(estuarySiteLocations)
```

![](LI_water_temps_2019_files/figure-markdown_github/cars-1.png)

``` r
dailyTemps <- dailyTemps %>% filter(Wtemp < 100 & Wtemp > -10) 
```

Plots
-----

Data has been collected since 2012, with 2013 being the first 'full' year of data collection.

    ## Joining, by = "site_no"

    ## Warning in bind_rows_(x, .id): Vectorizing 'sfc_POINT' elements may not
    ## preserve their attributes

![](LI_water_temps_2019_files/figure-markdown_github/pressure-1.png)

Anomolies?
----------

How do the temps of 2019 compare with the past? Red ribbon = 2019 temperature range based on daily statistics

``` r
daily_mean_7yr <- temps %>% 
  # filter to get 2012-2018
  filter(year != 2019) %>% 
  # group by site (site is key)
  group_by_key() %>%
  # index by the day of year
  index_by(day_of_year = ~ yday(.)) %>% 
  summarize(temp_mean7yr = mean(Wtemp, na.rm = TRUE),
            temp_max7yr = mean(Wtemp_Max, na.rm = TRUE),
            temp_min7yr = mean(Wtemp_Min, na.rm = TRUE))

daily_mean_7yr %>% ggplot(aes(x = day_of_year, y = temp_mean7yr)) + 
  geom_ribbon(aes(ymax = temp_max7yr, ymin = temp_min7yr), alpha = 0.6) +
  # geom_line(aes(y = temp_min7yr)) +
  # geom_line(aes(y = temp_max7yr)) + 
  geom_ribbon(data = temps %>% filter(year == 2019), 
              aes(y = Wtemp, ymin = Wtemp_Min, ymax = Wtemp_Max), fill = 'red', alpha = 0.6) + 
  theme_minimal() + 
  scale_x_continuous(labels = function(x) format(as.Date(as.character(x), "%j"), "%d-%b")) +
  # scale_x_date(labels = function(x) format(x, "%d-%b")) +
  facet_grid(station_nm ~ .) 
```

    ## Warning: Ignoring unknown aesthetics: y

![](LI_water_temps_2019_files/figure-markdown_github/unnamed-chunk-1-1.png)

``` r
# ggplotly()
```
