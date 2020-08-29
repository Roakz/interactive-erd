require_relative 'mapper'

mapper = Mapper.new

mapper.load_file(File.open('test.sql'))

top_level = mapper.calculate_top_level

entities = mapper.split_entities

json = mapper.entities_to_json(entities)

p json


