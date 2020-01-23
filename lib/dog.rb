class Dog
  attr_accessor :name, :breed, :id

  def initialize(id: nil, breed:, name:)
    @id = id
    @breed = breed
    @name = name
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      )    ;
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS dogs;
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)    ;
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end

  def self.create(hash)
    dog = self.new(name: hash[:name], breed: hash[:breed])
    dog.save
  end

  def self.new_from_db(row)
    dog = self.new(name: row[1], breed: row[2])
    dog.id = row[0]
    dog
  end

  def self.find_by_id(id)
    sql = <<-SQL
      SELECT * FROM dogs
      WHERE id = ?
      ;
    SQL
    self.new_from_db(DB[:conn].execute(sql, id)[0])
  end

  def self.find_or_create_by
    sql = <<-SQL
      SELECT * FROM dogs
      WHERE
      ;
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
  end
end
