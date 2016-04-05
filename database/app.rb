require 'sqlite3'

db = SQLite3::Database.new('test.sqlite')

# db.execute("INSERT INTO cars (model, price) VALUES('Gelendvagen', 330000)")
db.execute "select * from cars" do |row|
  puts row.join(' ')
end

db.close