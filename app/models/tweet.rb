require 'mongo_mapper'
class Tweet
  include MongoMapper::EmbeddedDocument
  key :text, String
  #many :entities, Tuple
end
