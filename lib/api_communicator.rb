require 'rest-client'
require 'json'
require 'pry'


def get_character_movies_from_api(character_name)
  response_string = RestClient.get("http://www.swapi.co/api/people/")
  response_hash = JSON.parse(response_string)
  page_count = (response_hash["count"]/10.0).ceil
  films_array = []
  page = 1
  while page <= page_count
    response_string = RestClient.get("http://www.swapi.co/api/people/")
    if page > 1
      response_string = RestClient.get(response_hash["next"])
    end
    response_hash = JSON.parse(response_string)
    character_array = response_hash["results"]
    films_array = search_page(character_array, character_name)
    if films_array != []
      page = page_count + 1
    else
      page += 1
    end
  end
  films_array
end

def search_page(character_array, character_name)
  films_array ||= []
  character_array.each do |character_hash|
    if character_hash["name"].downcase == character_name
      films_array = character_hash["films"]
    end
  end
  films_array
end

def print_movies(films)
  title_array = []
  films.each do |film|
    response_string = RestClient.get(film)
    response_hash = JSON.parse(response_string)
    title_array << response_hash["title"]
  end
  if title_array == []
    puts "Character not found."
  else
    puts title_array
  end
  #binding.pry
end

def show_character_movies(character)
  films = get_character_movies_from_api(character)
  print_movies(films)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
