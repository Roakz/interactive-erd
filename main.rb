require_relative 'mapper'

mapper = Mapper.new

mapper.load_file(File.open('test.sql'))

top_level = mapper.calculate_top_level

p top_level