require 'sinatra'
require 'sinatra/custom_logger'
require 'sinatra/reloader'
require 'logger'
require_relative 'mapper.rb'

set :logger, Logger.new(STDOUT)

get '/' do
  erb :home, :layout => :layout
end

get '/file-to-json-form' do
  erb :upload_form, :layout => :layout
end

post '/file-to-json' do
  begin
    mapper = Mapper.new 
    mapper.load_file(params['file'][:tempfile])
    top_level = mapper.calculate_top_level
    entities = mapper.split_entities
    return [200, mapper.entities_to_json(entities).to_json]
  rescue 
    return [500, {:error => "something went wrong"}.to_json]
  end 
end






