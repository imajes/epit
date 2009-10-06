class Commodity
  
  TOTAL_CARDS = 29
  VALID_OPTIONS = {"iphone" => 250, "dollars" => 500, "diamonds" => 25000, "stocks" => 10, "friends" => 100000}
  @@WEIGHTINGS = {"iphone" => 4, "dollars" => 10, "diamonds" => 2, "stocks" => 10, "friends" => 2}
  
  attr_accessor :commodities
  
  def initialize
    begin
      @commodities = Marshal.load($cache.get "commodities")
    rescue
      @commodities = {}
    end
    
    @card = get_reader
    if @card.nil? 
      @card = get_reader
    end
  end
  
  def comms
    puts @commodities
  end
  
  def kind
    @commodities[@card]
  end
  
  def score
    item = @commodities[@card] unless @commodities.nil?
    if item.nil?
      item = generate_new
      save_comm(item, @card)
    end
    return VALID_OPTIONS[item]
  end
  
  def generate_new
    poss = []
    @@WEIGHTINGS.each do |r|
      1.upto(r[1]).each do
        poss << r[0]
      end
    end
    
    poss.shuffle!
    return poss.first
  end
  
  def save_comm(item, card)
    p card
    p item
    @commodities[card] = item
    comms
    $cache.set "commodities", Marshal.dump(@commodities)
  end
  
  private
  
  def get_reader
    rv = `python tikirdr/tikitag_reader.py`
    if rv == "No tikitag on the reader\n"
      return nil
    end
    return rv.strip
  end
  
end