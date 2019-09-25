class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_reader :word
  attr_reader :guesses
  attr_reader :wrong_guesses
  attr_reader :word_with_guesses

  GUESS_LIMIT = 7
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = '-' * word.length 
  end

  # processes a guess and modifies the instance variables wrong_guesses and guesses accordingly
  def guess(letter)
    if letter == nil || !letter.match(/^[[:alpha:]]$/)
      flash[:message]="Invalid guess."
      raise ArgumentError.new()
    end
    guess = letter.downcase
    # if guess is new
    if !@guesses.include?(guess) && !@wrong_guesses.include?(guess)
      # correct guess
      if @word.downcase.include?(guess)
        @guesses << guess
        arr = (0 ... @word.length).find_all { |i| @word[i,1] == letter }
        arr.each do |i|
          @word_with_guesses[i] = guess
        end
      # incorrect guess  
      else
        @wrong_guesses << guess
      end
      return true
    # existing guessed letter
    else
      return false
    end
  end

  # returns one of the symbols :win, :lose, or :play depending on the current game state
  def check_win_or_lose
    if @wrong_guesses.length >= GUESS_LIMIT
      :lose
    elsif !(@wrong_guesses.length >= GUESS_LIMIT) && !@word_with_guesses.include?('-')
      :win
    else
      :play
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
