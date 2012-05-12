require 'mongo_mapper'
class User
  include MongoMapper::Document

  key :name, String
  key :since_id, String
  many :tweets
  many :categories
end
