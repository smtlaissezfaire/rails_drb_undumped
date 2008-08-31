class AddUserData < ActiveRecord::Migration
  def self.up
    truncate_table :users
    
    100_000.times do |i|
      puts "* Creating user #{i+1}"
      User.create!(:first_name => "Scott", :last_name => "Taylor")
    end
  end

  def self.down
    truncate_table :users
  end
  
  def self.truncate_table(table_name)
    execute("TRUNCATE TABLE `#{table_name}`")
  end
end
