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

def self.find_by_id(id)
  sql = <<-SQL
  SELECT name, breed FROM dogs WHERE id = ?
  SQL
  dogg = DB[:conn].execute(sql, id)[0]
  hash = {}
  hash[:id] = id
  hash[:name] = dogg[1]
  hash[:breed] = dogg[2]
  self.new(hash)
end

def self.find_or_create_by(name:, breed:)
  sql = <<-SQL
  SELECT * FROM dogs WHERE name = ? AND breed = ?
  SQL

  result = DB[:conn].execute(sql, name, breed)[0]

  if result.empty?
    self.new(id: result[0], name: result[1], breed: result[2])
  else
    binding.pry
    self.create(name: result[0], breed: result[1])

  end

end

end
