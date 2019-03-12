#!/usr/bin/env ruby

require_relative "../lib/api_communicator.rb"
require_relative "../lib/command_line_interface.rb"

welcome
type = select_type

if type == "people"
  character = get_character_from_user
  show_character_movies(character)
elsif type == "films"
  film = get_movie_from_user
  show_movie_characters(film)
else
  puts "Invalid type selection!"
end
