class NotOysterError < Exception; end;

class Player
  
  attr_accessor :data, :name, :id
  
  def initialize(id)
    self.id = id.strip
    check_id
    # if we don't find 
    unless find(self.id)
      self.data = {}
    end
      
  end
  
  def check_id
    if self.id.length != 24
      raise NotOysterError
    end
  end
  
  def save!
    to_write = Marshal.dump(self.data)
    $cache.set "user_#{self.id}", to_write
  end
  
  def name=(n)
    self.data[:name] = n
  end
  
  def name
    self.data[:name]
  end
  
  private
  
  def find(id)
    begin
      user = $cache.get "user_#{id}"
    rescue Memcached::NotFound
      return false
    end
    self.data = Marshal.load(user)
    return true
  end
  
end
