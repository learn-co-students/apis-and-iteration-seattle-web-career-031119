require 'rest-client'
require 'json'
require 'pry'

def get_film_apis(character_name, response_hash)
  film_apis = []
  response_hash["results"].each do |character_hash|
    if character_hash["name"].downcase == character_name
      film_apis = character_hash["films"]
    end
  end
  film_apis
end

def get_movie_array(film_apis)
  movie_arr = []
  film_apis.each do |movie_url|
    film_string = RestClient.get(movie_url)
    film_hash = JSON.parse(film_string)
    movie_arr << film_hash
  end
  movie_arr
end

def get_character_movies_from_api(character_name)
  #make the web request

  response_string = RestClient.get('http://www.swapi.co/api/people/')
  response_hash = JSON.parse(response_string)

  film_apis = get_film_apis(character_name, response_hash)

  while film_apis.empty?
    response_string = RestClient.get(response_hash["next"])
    response_hash = JSON.parse(response_string)
    film_apis = get_film_apis(character_name, response_hash)
  end

  get_movie_array(film_apis)

  # iterate over the response hash to find the collection of `films` for the given
  #   `character`
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `print_movies`
  #  and that method will do some nice presentation stuff like puts out a list
  #  of movies by title. Have a play around with the puts with other info about a given film.
end

def create_movie_hash(movie_arr)
    movie_hash = {}
    movie_arr.each { |film|
      movie_hash[film["episode_id"]] = {"title" => film["title"], "year" => film["release_date"][0..3]}
      }
    movie_hash
end

def print_movies(films)
  movie_hash = create_movie_hash(films)
  (1..8).each { |i|
    if movie_hash.has_key?(i)
      puts "Episode #{i}: #{movie_hash[i]["title"]} (#{movie_hash[i]["year"]})"
    end
  }

  # some iteration magic and puts out the movies in a nice list
end

def show_character_movies(character)
  films = get_character_movies_from_api(character)
  print_movies(films)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
