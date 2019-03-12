require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character_name)
  #make the web request
    character_data = get_entity_data_by_field("people", "name", character_name)
    if character_data == {}
      puts "That character doesn't appear in any movies! Please add the name of a Star Wars character."
    else
      films = get_films(character_data)
      film_titles = get_film_titles(films)
    end
end

def get_movie_characters_from_api(movie_name)
  #make the web request
    film_data = get_entity_data_by_field("films", "title", movie_name)
    if film_data == {}
      puts "That isn't a star wars movie! Please search for something that exists."
    else
      characters = get_characters(film_data)
      character_names = get_character_names(characters)
    end
end

def get_entity_data_by_field(entity_type, field_name, match_string)
  response_hash = get_page("http://www.swapi.co/api/#{entity_type}/")
  loop do
    response_hash["results"].each {|info|
      if info[field_name].downcase == match_string
        return info
      end
    }
    next_page?(response_hash) ? response_hash = get_page(response_hash["next"]) : break
  end
    {}
end

def show_character_movies(character)
  films = get_character_movies_from_api(character)
  print_movies(films) if films
end

def show_movie_characters(movie)
  characters = get_movie_characters_from_api(movie)
  print_characters(characters) if characters
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?


#PAGINATION FUNCTIONS
def next_page?(page)
  return !page["next"].nil?
end


def get_page(url)
  response_string = RestClient.get(url)
  response_hash = JSON.parse(response_string)
end

#CHARACTER FUNCTIONS
def get_characters(film)
  film["characters"]
end

def get_character_names(characters)
  characters.map {|character|
    character_response_string = RestClient.get(character)
    character_response_hash = JSON.parse(character_response_string)
    character_response_hash["name"]
  }
end

def print_characters(characters)
  characters.each do |character|
    puts character
  end
end

#FILM FUNCTIONS
def get_films(data)
  data["films"]
end

def get_film_titles(films)
  films.map { |movie_url|
    movie_response_string = RestClient.get(movie_url)
    movie_response_hash = JSON.parse(movie_response_string)
    movie_response_hash["title"]
  }
end

def print_movies(films)
  films.each {|film_name|
      puts film_name
    }
end
