# Object Oriented Blackjack Game
# Tealeaf Course 1 - Week 2
# Version: 1.0.0
# Author: ClintonJNelson
#require "rubygems"  #allows binding pry
#require "pry"

#TODO: Reduce use of direct instance variable (IV) calls in favor of getter/setter
#TODO: Make dealer's first card not show
#TODO: Reduce multiple-chase-method-calls to simplify the mental tracking
#TODO: Add additional player option
#TODO: I like my card hash, but we'll see if it lasts. Maybe set card values per game
      #and have the game select the appropriate vard values.
      #Deck could still come from Card_Deck, but blackjack_values would be the values.
      #Otherwise, revert back to array.
#TODO: Keep track of money & bets



####################Modules#######################
module PlayerNames
  # Computer player names
  PLAYERNAMES = [ 'Chris', 'Richard', 'Bart', 'Albert', 'Jorge', 'Jay-Ar', 'Thomas',
                  'Steve', 'Nathan', 'Amber', 'Savio', 'Adam', 'Yuchuan', 'Shawn',
                  'Yu', 'Clint', 'Steven', 'Lee', 'Andreas', 'Daniel', 'Joey',
                  'Hyunsoo', 'Matthew', 'Yong', 'Dai', 'Quentin', 'Josh', 'Roy',
                  'James']
end


module DeckConstants
  # Standard 52 card deck & values
  CARD_DECK =   { h2: 2, h3: 3, h4: 4, h5: 5, h6: 6, h7: 7, h8: 8, h9: 9, h10: 10, hj: 10, hq: 10, hk: 10, ha: 11,
                  d2: 2, d3: 3, d4: 4, d5: 5, d6: 6, d7: 7, d8: 8, d9: 9, d10: 10, dj: 10, dq: 10, dk: 10, da: 11,
                  s2: 2, s3: 3, s4: 4, s5: 5, s6: 6, s7: 7, s8: 8, s9: 9, s10: 10, sj: 10, sq: 10, sk: 10, sa: 11,
                  c2: 2, c3: 3, c4: 4, c5: 5, c6: 6, c7: 7, c8: 8, c9: 9, c10: 10, cj: 10, cq: 10, ck: 10, ca: 11}

  # Names for each card
  CARD_NAMES =  { h2: "2 of Hearts", h3: "3 of Hearts", h4: "4 of Hearts", h5: "5 of Hearts", h6: "6 of Hearts", h7: "7 of Hearts", h8: "8 of Hearts", h9: "9 of Hearts", h10: "10 of Hearts", hj: "Jack of Hearts", hq: "Queen of Hearts", hk: "King of Hearts", ha: "Ace of Hearts",
                  d2: "2 of Diamonds", d3: "3 of Diamonds", d4: "4 of Diamonds", d5: "5 of Diamonds", d6: "6 of Diamonds", d7: "7 of Diamonds", d8: "8 of Diamonds", d9: "9 of Diamonds", d10: "10 of Diamonds", dj: "Jack of Diamonds", dq: "Queen of Diamonds", dk: "King of Diamonds", da: "Ace of Diamonds",
                  s2: "2 of Spades", s3: "3 of Spades", s4: "4 of Spades", s5: "5 of Spades", s6: "6 of Spades", s7: "7 of Spades", s8: "8 of Spades", s9: "9 of Spades", s10: "10 of Spades", sj: "Jack of Spades", sq: "Queen of Spades", sk: "King of Spades", sa: "Ace of Spades",
                  c2: "2 of Clubs", c3: "3 of Clubs", c4: "4 of Clubs", c5: "5 of Clubs", c6: "6 of Clubs", c7: "7 of Clubs", c8: "8 of Clubs", c9: "9 of Clubs", c10: "10 of Clubs", cj: "Jack of Clubs", cq: "Queen of Clubs", ck: "King of Clubs", ca: "Ace of Clubs"}
end


module Playing

  # Calculates & udpates player's total points (@points)
  # Returns int
  def total
    @points = 0
    @hand.each{|card| @points += card.value}
    #puts "Mid-calc total is #{@points}"
    if @points > 21
      self.aces
    end
    @points
  end

  # def display
  #   puts ""
  # end

  # Adds a card from deck to player's hand, updates handsym array
  # Takes: Card object // Returns: Interger
  def hit(card)
    @hand.push(card)
    puts "==> Dealer dealt #{@name} #{card.to_s}"
    self.hand_sym
    self.total
  end

  def stay
    return
  end

  def aces
    numaces = 0
    acecards = [:ha, :da, :sa, :ca]
    acecards.each {|sym| numaces += @handsym.count(sym)}

    numaces.times do
      @points -= 10
      #puts "Mid-calc total after adjusting aces is #{@points}"
      break if @points < 21
    end
  end

  def hand_sym
    @handsym = []
    @hand.each{|card| @handsym.push(card.symbol)}
  end

  def break?
    return true if @points > 21
  end

  def reset
    @points = 0
    @hand = []
  end
end


####################Class Defs#####################
class Deck < Array
  include DeckConstants
  attr_accessor :numdecks
  attr_reader :deck

  # Sets num of decks. Builds a new un-shuffled deck (card sym array).
  def initialize(numdecks = 1)
    @numdecks = numdecks
    @deck = []
    @numdecks.times do |_|
      DeckConstants::CARD_DECK.each {|k, v| @deck.push(Card.new(k))}
    end
    mix!
  end

  public   #----------Public Methods----------
  def to_s
    "the deck has the following cards: \n #{@deck}"
  end

  # Make a new card stack of 1+ decks. Takes: int // Returns: array of card obj
  def newdeck(d = 8)
    if d.between?(1, 8)
      @numdecks = d.to_int
      @deck = Array.new
      @numdecks.times {|_| DeckConstants::CARD_DECK.each {|k, v| @deck.push(Card.new(k))}}
    else
      return nil
    end
    deck
  end

  # Shuffling the deck array
  def mix!
    @deck.shuffle!
  end

  # Drawing a card from end of deck. // Returns: Card object
  def draw
    @deck.pop
  end
end


class Card
  include DeckConstants
  attr_accessor :symbol, :name, :value

  def initialize (s)
    @symbol = s
    @name = DeckConstants::CARD_NAMES[s]
    @value = DeckConstants::CARD_DECK[s]
  end

  # Tell card information
  def to_s
    "the #{name} worth #{value} points"
  end
end


class Blackjack
  attr_accessor :name

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @count = 0
    play
  end

  # Flowpath of the blackjack game
  def play
    self.welcome
    played = false  # This helps pick the right output - just starting?

    while self.playagain(played)
      played = true
      self.prepdeck
      self.deal
      self.gameupdate([@dealer, @player])
      self.playerplay
      if @player.break?
        self.decidegame
        next
      end
      self.dealerplay
      self.decidegame
    end
  end

  # Deciding if will play again
  def playagain(played = false)
    played ? (puts "Would you like to play again?") : (puts "Welcome to the game, #{name}. Would you like to play?")
    @player.name = "You"

    loop do
      puts "(please answer 'yes' or 'no')"
      answer = gets.chomp
      case answer.downcase
        when 'yes'
          self.resetgame
          return true
        when 'no'
          puts 'Please come again soon!'
          exit
      end
    end
  end

  def welcome
    puts "Welcome to the Blackjack Table! \n This is a 1-player table playing with 2 decks"
    puts "What's your name?"
    @name = gets.chomp
    @player.name = @name
  end

  def prepdeck
    @deck = Deck.new(2)
  end

  def deal
    2.times do |_|
      @player.hit(@deck.draw)
      @dealer.hit(@deck.draw)
    end
  end

  def dealerplay
    while @dealer.hit?(@player.points)
      @dealer.hit(@deck.draw)
      puts "#{@dealer.name} now has #{@dealer.points} points."
      break if @dealer.break?
    end
  end

  def playerplay
    until @player.break?
      puts "What would you like to do? (Enter 'Hit' or 'Stay')"
      answer = gets.chomp
      case answer.downcase
        when "hit"
          @player.hit(@deck.draw)
          self.display(@player)
          break if @player.break?
        when "stay"
          break
      end
    end
  end

  def gameupdate(players)
    puts "\n\nCurrent Standings:"
    players.each do |player|
      self.display(player)
    end
  end

  def display(person)
    puts "\n#{person.name}: "
    person.hand.each{|e| puts "\t #{e}"}
    puts "\t Points: #{person.points} \n \n"
  end

  # Deciding & announcing winner
  def decidegame
    case
      when @dealer.break?
        puts "The Dealer has broke - You Win!"
      when @player.break?
        puts "You broke! The dealer wins."
      when @dealer.points > @player.points
        puts "The dealer wins with #{@dealer.points} over your #{@player.points}"
      when @dealer.points < @player.points
        puts "You win with #{@player.points} over the dealer's #{@dealer.points}"
      when @dealer.points == @player.points
        puts "It's a tie(ie: a push)! You both get your bets back."
      else
        puts "The program has become confused & doesn't know what's going on..."
    end
    return
  end

  # Reset players & screen
  def resetgame
    @player.reset
    @dealer.reset
    @count +=1
    system('clear')
    puts "\n\n_________________Round #{@count}_______________________"
  end
end


class Player
  include Playing
  attr_accessor :name, :hand, :points

  def initialize
    @hand = []
  end
end


class Dealer
  include Playing
  attr_accessor :name, :hand, :points

  def initialize
    @name = "The Dealer"
    @hand = []
  end

  def hit?(playerpoints)
    (self.total < 17) || (self.total < playerpoints) ? true : false
  end
end


game = Blackjack.new
