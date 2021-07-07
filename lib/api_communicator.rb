require 'rest-client'
require 'json'
require 'pry'

Numeral_lookup = {
  1 => "I",
  2 => "II",
  3 => "III",
  4 => "IV",
  5 => "V",
  6 => "VI",
  7 => "VII",
  8 => "VIII"
  }

def get_film_apis(character_name, response_hash)
  film_apis = []
  response_hash["results"].each do |character_hash|
    if character_hash["name"].downcase == character_name
      film_apis = character_hash["films"]
    end
  end
  film_apis
end

def get_movie_array(movie_urls)

  movie_arr = []
  movie_urls.each do |movie_url|
    film_string = RestClient.get(movie_url)
    film_hash = JSON.parse(film_string)
    movie_arr << film_hash
  end
  movie_arr
end


def get_character_movies_from_api(character_name)

  url = 'http://www.swapi.co/api/people/'
  film_apis = {}

  while film_apis.empty?
    response_string = RestClient.get(url)
    response_hash = JSON.parse(response_string)
    film_apis = get_film_apis(character_name, response_hash)
    url = response_hash["next"]

    if response_hash["next"] == nil && film_apis.empty?
      puts "That character is not in Star Wars, you dolt."
      break
    end

  end
  get_movie_array(film_apis)
end

def create_movie_hash(films)
  #so we can put stuff in order
  movie_hash = {}
  films.each do |film|
    movie_hash[film["episode_id"]] = {"title" => film["title"], "year" => film["release_date"][0..3]}
  end
  movie_hash
end

def print_movies(films)
  movie_hash = create_movie_hash(films)
  (1..8).each do |episode_num|
    if movie_hash.has_key?(episode_num)
      puts "Episode #{Numeral_lookup[episode_num]}: #{movie_hash[episode_num]["title"]} (#{movie_hash[episode_num]["year"]})"
    end
  end
end

def show_character_movies(character)
  films = get_character_movies_from_api(character)
  print_movies(films)
  true
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
