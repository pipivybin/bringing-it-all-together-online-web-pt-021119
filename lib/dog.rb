require 'pry'

class Dog

attr_accessor :name, :breed, :id

def initialize(hash)
  @id = hash[:id]
  @name = hash[:name]
  @breed = hash[:breed]
  self
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
  @id = DB[:conn].execute("SELECT id FROM dogs WHERE name = ?", self.name)[0][0]
  self
end

def self.create(hash)
  dogg = self.new(hash)
  dogg.save
  dogg
end

def self.find_by_id(id)
  sql = <<-SQL
  SELECT id, name, breed FROM dogs WHERE id = ?
  SQL
  dogg = DB[:conn].execute(sql, id)[0]

  self.new(id: id, name: dogg[1], breed: dogg[2])

end

def self.find_or_create_by(name:, breed:)
  sql = <<-SQL
  SELECT * FROM dogs WHERE name = ? AND breed = ?
  SQL

  result = DB[:conn].execute(sql, name, breed)[0]

  if result
    self.find_by_id(result[0])
  else
    self.create(name: name, breed: breed)
  end
end

def self.new_from_db(row)
  self.new(id: row[0], name: row[1], breed: row[2])
end

def method_name

end

end
