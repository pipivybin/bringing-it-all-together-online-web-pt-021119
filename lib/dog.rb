require 'pry'

class Dog

attr_accessor :name, :breed
attr_reader :id

def initialize(hash)
  @id = hash[:id]
  @name = hash[:name]
  @breed = hash[:breed]
end

def self.create_table
  sql = <<-SQL
  CREATE TABLE dogs (
    id INTEGER PRIMARY KEY,
    name TEXT,
    breed TEXT
  )
  SQL
  DB[:conn].execute(sql)
end

def self.drop_table
  sql = <<-SQL
  DROP TABLE dogs
  SQL
  DB[:conn].execute(sql)
end

def save
  sql = <<-SQL
  INSERT INTO dogs (name, breed) VALUES (?, ?)
  SQL
  DB[:conn].execute(sql, self.name, self.breed)
  @id = DB[:conn].execute("SELECT id FROM dogs WHERE name = ?", self.name)
  self
end

def self.create(hash)
  dogg = self.new(hash)
  dogg.save
end


end
