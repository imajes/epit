namespace :game do
  desc "Populate the DB with a new game's worth of data"
  namespace :populate do
    desc "Populate the DB with new game data"
    task :commodities => :environment do
      # require 'populator'
      # require 'faker'
      require 'yaml'
      
      [Card, Player].map(&:delete_all)
      
      config = YAML.load_file('config/game.yml')["config"]
      c = YAML.load_file('db/commodities.yml')
      
      # figure out what commodities we're going to actually do for this game, given 
      # number of cards we have to play with
      card_amt = config["cards"].length
      puts "-- This game will be played with #{card_amt} cards..."
      poss_coms = (card_amt / config["cards_per_commodity"].to_i).floor
      puts "-- That gives us #{poss_coms} possible commodities..."
      max_coms = config["commodities"].to_i > poss_coms ? poss_coms : config["commodities"]
      puts "-- But we're going to use #{max_coms} instead."
      
      play_coms = c.keys.shuffle[1..(max_coms)]
      
      to_create = 0
      
      config["cards"].each do |card|
        next if play_coms.length == 0 ##fixme
        
        # reset the create stack if we're at zero
        to_create = config["cards_per_commodity"] if to_create == 0
        
        Card.create("commodity" => play_coms.first, :value => c[play_coms.first], :number => card)
        puts "Created a #{play_coms.first} card, with a value of #{c[play_coms.first]} and rfid tag of #{card}"
        # take one off, etc
        to_create = to_create - 1 
        # drop what we gotta do 
        play_coms.shift if to_create == 0
      end
    end
  end
end