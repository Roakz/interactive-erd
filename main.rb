require 'sinatra'
require 'sinatra/custom_logger'
require 'sinatra/reloader'
require 'logger'
require_relative 'mapper.rb'

set :logger, Logger.new(STDOUT)

post '/file-to-json' do

  mapper = Mapper.new 
  mapper.load_file(params['file'][:tempfile])
  top_level = mapper.calculate_top_level
  entities = mapper.split_entities
  mapper.entities_to_json(entities).to_json
 
end






