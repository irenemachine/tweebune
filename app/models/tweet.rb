require 'mongo_mapper'

class Tweet
  include MongoMapper::EmbeddedDocument
  key :text, String, :required
  #many :keywords
  key :category_ids, Set
  many :categories, :in => :category_ids

  embedded_in :user
  SANITIZE_REGEXP = /[^a-zA-Z :.\/]/

    def analysis
      analyze_text = self.text.gsub(SANITIZE_REGEXP, '')

      #check for a valid string analyze_text
      #begin
        entity_result = JSON.parse(@@alchemyObj.TextGetRankedNamedEntities(analyze_text, AlchemyAPI::OutputMode::JSON))
        entity_result["entities"].each do |entity|
          self.store_category(entity["text"])
          #store entity["type"] at some point??
        end
      #rescue
      #end

      #begin
        concept_result = JSON.parse(@@alchemyObj.TextGetRankedConcepts(analyze_text, AlchemyAPI::OutputMode::JSON))
        concept_result["concepts"].each do |concept|
          self.store_category(concept["text"])
        end
      #rescue
      #end

      #begin
        category_result = JSON.parse(@@alchemyObj.TextGetCategory(analyze_text, AlchemyAPI::OutputMode::JSON))
        unless category_result["category"] == "unknown"
          self.store_category(category_result["category"])
        end
      #rescue
      #end

      #keyword_result = JSON.parse(@@alchemyObj.TextGetRankedKeywords(Stopwords.remove(self.text), AlchemyAPI::OutputMode::JSON))
      #keyword_result["keywords"].each do |keyword|
      #  puts "Keywords" + keyword["text"]
      #end

      self
    end

  protected
  def store_category category
    self.categories << Category.find_or_create_by_name(category.titleize)
  end
end
