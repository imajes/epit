class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string    :identifier
      t.integer   :score
      t.integer   :given_to
      t.timestamp :given_at
      t.string    :last_set
      t.timestamp :last_at
      t.timestamps 
    end
  end

  def self.down
    drop_table :players
  end
end
