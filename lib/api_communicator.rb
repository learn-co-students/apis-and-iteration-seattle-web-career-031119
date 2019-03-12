require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character_name)
  #make the web request
    character_data = get_character_data(character_name)
    if character_data == {}
      puts "That character doesn't appear in any movies! Please add the name of a Star Wars character."
    else
      films = get_films(character_data)
      film_titles = get_film_titles(films)
    end
end


def get_character_data(character_name)
  response_hash = get_next_page()
  loop do
    response_hash["results"].each {|character_info|
      if character_info["name"].downcase == character_name
        return character_info
        break
      end
    }
    next_page?(response_hash) ? response_hash = get_next_page(response_hash["next"]) : break
  end
    {}
end


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


def next_page?(page)
  return !page["next"].nil?
end


def get_next_page(url = 'http://www.swapi.co/api/people/')
  response_string = RestClient.get(url)
  response_hash = JSON.parse(response_string)
end


def print_movies(films)
  films.each {|film_name|
      puts film_name
    }
end


def show_character_movies(character)
  films = get_character_movies_from_api(character)
  print_movies(films) if films
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
