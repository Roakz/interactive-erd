require 'sinatra'
require 'sinatra/custom_logger'
require 'sinatra/reloader'
require 'logger'
require_relative 'mapper.rb'
require_relative 'pdf_generator.rb'
require_relative 'json_store.rb'

set :logger, Logger.new(STDOUT)

json_store = JSONStore.new

get '/' do
  erb :home, :layout => :layout
end

get '/pdf-test' do
  content_type 'application/pdf'
  pdf_generator = PdfGenerator.new(json_store.jsons.last, logger) 
  pdf = pdf_generator.generate
  pdf.render
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
    store_json(mapper.entities_to_json(entities).to_json, json_store)
    200
  rescue 
    return [500, {:error => "something went wrong"}.to_json]
  end 
end

def store_json(json, json_store)
  json_store.store_json(json)
end






