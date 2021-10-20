class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word, :guesses, :wrong_guesses, :word_with_guesses, :count

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = ''
    @count = 0
    for i in 1..word.size
	    @word_with_guesses.concat('-')
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

  def is_letter(guess_letter)
    if (guess_letter >= 'a' && guess_letter <= 'z') || (guess_letter >= 'A' && guess_letter <= 'Z')
      return true
    else
      return false
    end
  end

  def guess(guess_letter)
    raise ArgumentError if guess_letter == '' or guess_letter==nil or !is_letter(guess_letter)
    guess_letter=guess_letter.downcase
    if guesses.include? guess_letter or wrong_guesses.include? guess_letter
      return false
    elsif word.include? guess_letter
      for i in 0..word.size-1
        if guess_letter == word[i]
          word_with_guesses[i] = guess_letter
        end
      end
      @guesses = guess_letter
      @count += 1
      return true
    elsif !word.include? guess_letter 
      @wrong_guesses = guess_letter
      @count += 1
      return true   
    end
  end

  def check_win_or_lose()
    if word_with_guesses == word
      return :win
    elsif @count >= 7
      return :lose
    else
      return :play
    end
  end

end
