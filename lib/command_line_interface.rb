def welcome
  "Hi, Welcome to the Star Wars Interface!"
end

def select_type
  puts "Please select if you would like to search for films or people"
  type = gets.chomp.downcase
end

def get_movie_from_user
  puts "Please enter a movie"
  gets.chomp.downcase
end

def get_character_from_user
  puts "Please enter a character name."
  gets.chomp.downcase
end
