require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    @street_address_without_spaces = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the variable @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the variable @street_address_without_spaces.
    # ==========================================================================

    url1 ="http://maps.googleapis.com/maps/api/geocode/json?address="+@street_address_without_spaces

    parsed_data1 = JSON.parse(open(url1).read)

    @latitude = parsed_data1["results"][0]["geometry"]["location"]["lat"]
    @longitude = parsed_data1["results"][0]["geometry"]["location"]["lng"]

    url2= "https://api.darksky.net/forecast/a0a55cf58ab78fcfb636b93d2befb44c/"+@latitude.to_s+","+@longitude.to_s

    parsed_data2 = JSON.parse(open(url2).read)

    @current_temperature = parsed_data2["currently"]["temperature"]
    @current_summary = parsed_data2["currently"]["summary"]
    @summary_of_next_sixty_minutes = parsed_data2["minutely"]["summary"]
    @summary_of_next_several_hours = parsed_data2["hourly"]["summary"]
    @summary_of_next_several_days = parsed_data2["daily"]["summary"]


    render("meteorologist/street_to_weather.html.erb")
  end
end
