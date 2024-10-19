require "http"
require "json"
require "dotenv/load"

pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_API_KEY")
gmaps_api_key = ENV.fetch("GMAPS_KEY")

puts "Specify your location"
user_location = gets.chomp

google_maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + gmaps_api_key

google_maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + "Chicago" + "&key=" + gmaps_api_key

lat_long = JSON.parse(HTTP.get(google_maps_url)).fetch("results")[0].fetch("geometry").fetch("location")
lat = lat_long.fetch('lat')
lng = lat_long.fetch('lng')

puts "The lat and long are " + lat.to_s + " ; " + lng.to_s

# Assemble the full URL string by adding the first part, the API token, and the last part together
pirate_weather_url = "https://api.pirateweather.net/forecast/" + pirate_weather_api_key + "/" + lat.to_s + "," + lng.to_s

# Place a GET request to the URL
parsed_response = JSON.parse(HTTP.get(pirate_weather_url))

currently_hash = parsed_response.fetch("currently")

current_temp = currently_hash.fetch("temperature")

# prec_prob = currently_hash.fetch("precipProbability")

puts "Weather summary: " + currently_hash.fetch("summary")
puts "The current temperature is " + current_temp.to_s + " Farenheit."

hour_from_now=0
flag_umbrella = false

for hourly_data in parsed_response.fetch("hourly").fetch("data")
  prec_prob = hourly_data.fetch("precipProbability")
  if prec_prob.to_i>0.1
    flag_umbrella = true
    puts "Precipitation probability, at " + hour_from_now + " hour from now is " + prec_prob.to_s + '%.'
  end
  hour_from_now+=1
end 

if flag_umbrella
  puts "You might want to carry an umbrella!"
else
  puts "You probably won't need an umbrella today."
end
