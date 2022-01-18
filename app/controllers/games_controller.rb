require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    array = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << array[rand(array.length)] }
  end

  def score
    attempt = params[:word]
    if word_exists?(attempt) && word_in_grid(attempt, params[:letters])
      @response = "Congratulations! #{attempt.upcase} is a valid English word."
    elsif !word_exists?(attempt)
      @response = "Sorry but #{attempt.upcase} does not seem to be a valid English word."
    else        
      @response = "Sorry, but #{attempt.upcase} can't be built out of #{params[:letters]}."
    end
  end

  def word_exists?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    user["found"]
  end
  
  def word_in_grid(word, letters)
    array = letters.split(' ')
    word.upcase.split('').each do |letter|
      if array.include?(letter)
        index = array.index(letter)
        array.delete_at(index)
      else
        return false
      end
    end
    true
  end
end
