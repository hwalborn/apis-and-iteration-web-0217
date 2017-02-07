require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)
  result_length = 2
  while result_length != 1
    character_hash = get_and_parse('https://swapi.co/api/people/?search=' + character)
    film_api_arr = find_char_info(character_hash)
    result_length = character_hash["count"]
    if (result_length > 1)
        puts "More than one result, try again. Type exit to exit out of the program."
        character = gets.chomp.downcase
    elsif character == "exit"
        exit
    elsif (result_length < 1)
        puts "No results found. Try again. Type exit to exit out of the program."
        character = gets.chomp.downcase
    end
  end

  #Iterate through API to make the urls Hashes
  film_api_arr.map!{|url|
    url = get_and_parse(url)
  }

end

#make web requests
def get_and_parse(api)
  gotten = RestClient.get(api)
  return JSON.parse(gotten)
end

#return film array
def find_char_info(char_hash)
  char_hash['results'][0]['films']
end


def parse_character_movies(films_hash)
  return_arr = []
  films_hash.each_with_index {|film, index|
    return_arr << "#{index + 1} #{film['title']}"
  }

  return_arr.each{|film| puts film}
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end

#get_character_movies_from_api("Luke Skywalker")
## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
