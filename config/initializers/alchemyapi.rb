# Load the AlchemyAPI ruby code.
require "AlchemyAPI"


# Create an AlchemyAPI object.
@@alchemyObj = AlchemyAPI.new


# Load the API key from disk.
#alchemyObj.loadAPIKey "api_key.txt"
@@alchemyObj.loadAPIKey "./config/initializers/api_key.txt"

