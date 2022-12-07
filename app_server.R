# Set up ---------------------------------------------------------------------
carbon_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")
shapefile <- map_data("world")

# Summary Values -------------------------------------------------------------
highest_emission <- carbon_data %>%
  filter(year == 2019) %>%
  filter(country != "World" & country != "Asia" & country != "Africa") %>%
  filter(co2 == max(co2)) %>%
  pull(country)

max_emission <- carbon_data %>%
  select(year, country, co2) %>%
  filter(country != "World" & country != "Asia" & country != "Africa") %>%
  slice_max(co2)

max_emission_year <- max_emission %>%
  pull(year)

max_emission_country <- max_emission %>%
  pull(country)

us_emission <- carbon_data %>%
  filter(country == "United States") %>%
  filter(co2 == max(co2)) %>%
  pull(year)

greatest_growth <- carbon_data %>%
  select(year, country, co2_growth_prct) %>%
  filter(country == "United States") %>%
  slice_max(co2_growth_prct)

greatest_growth_year <- greatest_growth %>%
  pull(year)

greatest_growth_num <- greatest_growth %>%
  pull(co2_growth_prct)

# Data for charts ------------------------------------------------------------
co2_emission_data <- carbon_data %>%
  select(country, year, co2, cement_co2, coal_co2, flaring_co2,
         gas_co2, oil_co2, other_industry_co2) %>%
  filter(year >= 1950) %>%
  rename(region = country)

# Blank theme for the map
blank_theme <- theme_bw() +
  theme(
    axis.line = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    plot.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank()
  )

server <- function(input, output) {
  # Emission Map
  output$emission_map <- renderPlotly({
    selected_year <- input$emission_year
    filtered_data <- co2_emission_data %>%
      filter(year == selected_year) %>%
      select(region, input$emission_source)
    mapping_data <- shapefile %>%
      select(lat, long, group, region) %>%
      left_join(filtered_data, by = "region")
    
    emission_map <- ggplot(mapping_data) +
      geom_polygon(
        mapping = aes_string(x = "long", y = "lat", group = "group",
                             fill = input$emission_source),
        color = "gray", size = 0.3) +
      ggtitle("CO2 Emission of the World") +
      labs(fill = "CO2 Emission, in Million Tonnes") +
      blank_theme +
      theme(plot.title = element_text(size = 25)) +
      easy_center_title() +
      coord_quickmap()
    
    ggplotly(emission_map)
  })
  
  # Summary Values
  output$highest_emission <- renderText({
    return(highest_emission)
  })
  
  output$max_emission_year <- renderText({
    return(max_emission_year)
  })
  
  output$max_emission_country <- renderText({
    return(max_emission_country)
  })
  
  output$us_emission <- renderText({
    return(us_emission)
  })
  
  output$greatest_growth_year <- renderText({
    return(greatest_growth_year)
  })
  
  output$greatest_growth_num <- renderText({
    return(greatest_growth_num)
  })
}

