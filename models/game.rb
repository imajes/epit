class Game
  
  def initialize
    
  end
  
  def end_game
    
  end
  
  def leaderboard
    scores = []
    
    $players.each do |p|
      d = $cache.get "user_#{p}"
      scores << {d[:name] => d[:current_score]}
    end
    
    scores.sort_by
  end
  
  def save_scores!
    
  end
  
end