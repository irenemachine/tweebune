require 'mongo_mapper'
class Category
  include MongoMapper::Document
  key :name, String
end
