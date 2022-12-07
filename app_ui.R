carbon_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

# Map Widgets
source_types <- carbon_data %>%
  select(co2, cement_co2, coal_co2, flaring_co2, gas_co2, oil_co2,
         other_industry_co2) %>%
  colnames()

emission_type <- radioButtons(
  inputId = "emission_source",
  label = "Select an Emission Source",
  choices = source_types
)

select_year <- selectInput(
  inputId = "emission_year",
  label = "Select a Year to view",
  choices = 1950:2019
)

# Html pages
overview_page <- tabPanel(
  "Summary",
  
  titlePanel("Introduction"),
  p("By: Emily Ma"),
  
  
  mainPanel(
    p("This interactive website uses CO2 emission data from ",
      a("this repository",
        href = "https://github.com/owid/co2-data/blob/master/owid-co2-codebook.csv",
        inline = T),
      "and is focused on both the sources of CO2 emission and the amount of
          CO2 emission for each major country from 1950 to 2019. The variables that
          are analyzed in this report include CO2 emission sources (cement, coal
          , flaring, gas, oil, and other industries) and the total amount of CO2
          emission by each country since 1950. This report also uses the annual
          percent growth of CO2 emission over the years."),
    p("According to this data set, the country with the highest emission in
          2019 is",
      textOutput(outputId = "highest_emission", inline = T),
      ". The maximum amount of CO2 emitted between 1750 and 2019 was in",
      textOutput(outputId = "max_emission_year", inline = T),
      "and it was in",
      textOutput(outputId = "max_emission_country", inline = T),
      ". For the US, the maximum CO2 emission happened in",
      textOutput(outputId = "us_emission", inline = T),
      ". For the world,",
      textOutput(outputId = "greatest_growth_year", inline = T),
      "had the greatest CO2 annual percent growth, with a",
      textOutput(outputId = "greatest_growth_num", inline = T),
      "% increase compared to the year before."
    ),
    img("Uncontrollable Wildfires due to Rising Temperatures as a Result of Climate Change",
        src = "https://images.theconversation.com/files/399204/original/file-20210506-16-3udsp0.jpg?ixlib=rb-1.1.0&rect=0%2C0%2C4584%2C2889&q=20&auto=format&w=320&fit=clip&dpr=2&usm=12&cs=strip", height="120%", width="120%")
  )
)

map_page <- tabPanel(
  "CO2 All over the World",
  
  titlePanel("World Map of CO2 Emissions"),
  
  sidebarLayout(
    sidebarPanel(
      emission_type,
      select_year,
      p("Select an emission source and a year to see
              how much CO2 was emitted by the selected source all over the world."),
      p("co2 = total CO2 emission"),
      p("cement_co2 = CO2 emissions from cement production"),
      p("coal_co2 = CO2 emissions from coal production"),
      p("flaring_co2 = CO2 emissions from gas flaring"),
      p("gas_co2 = CO2 emission froms gas production"),
      p("oil_co2 = CO2 emissions from oil prooduction"),
      p("other_industry_co2 = CO2 emissions from other industrial
              processes")
    ),
    
    mainPanel(
      p("The following map shows the amount of CO2 emission of the world
              for the selected year and the selected source of emission."),
      plotlyOutput(outputId = "emission_map"),
      p("I chose to focus on an earthwide map in my report because it best 
         displays on a global scale which countries are the main contributors
         of CO2 emission. Which is the greenhouse gas that has spiked immensely 
         in production in the last seven decades due to overpopulation of the
         world, growing industrial processes, the commonality of fuel-driven 
         vehicles, and so much more. Unfortunately, due to the surplus amount
         of CO2, our earth is warming and causing a phenomenon best known as 
         climate change. Gradually heating up the Earth's surface and raising
         global temperatures which is having a severe ripple effect on the health
         of our planet. When analyzing the map however, it's clear to see that
         over the years, the United States has consistently been one of the 
         highest CO2 emitting countries followed by China starting from the 2000s."),
    )
  )
)


ui <- navbarPage(
  "Global CO2 over Time",
  overview_page,
  map_page
)
