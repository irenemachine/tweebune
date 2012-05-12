require 'mongo_mapper'
class Category
  include MongoMapper::EmbeddedDocument
  key :text, String
  key :entities, Array
end
