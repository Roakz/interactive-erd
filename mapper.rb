class Mapper
  attr_accessor :file, :load_file
  attr_reader :calculate_top_level, :split_entities, :entities_to_json

  def initialize(params = {})
    @file = params[:file] ? params[:file] : nil
  end

  def load_file(file)
    @file = file
  end

  def calculate_top_level
    
    return false unless @file

    unwanted_key_words = ["CREATE", "SCHEMA", "DATABASE"]
    schema_arr = []
    database_arr = []

    File.foreach(@file) do |line|
      if line.include? "SCHEMA" 
        schema_arr << line
      end
      if line.include? "DATABASE"
        database_arr << line 
      end
      next
    end

    schema_arr.each_with_index do |line, index|
      schema_arr[index] = line.split(' ').reject! {|word| unwanted_key_words.include? word }[0].tr(';', '')
    end unless schema_arr.empty?

    database_arr.each_with_index do |line, index|
      database_arr[index] = line.split(' ').reject! {|word| unwanted_key_words.include? word }[0].tr(';', '')
    end unless database_arr.empty?

    return {:database => database_arr, :schema => schema_arr}
  end

  def split_entities
    return false unless @file
    entities = []
    entity = ""
    skip = true
    File.foreach(@file) do |line|
      if line.include? "TABLE" and line.include? "CREATE"
       entity = line
       skip = false
      end
      next unless !skip
      entity += line unless line == entity
      skip = line.include? ");"
      skip ? entities << entity : next
    end
    entities
  end

  def entities_to_json(entities)
    return_json = {}
    return_json["entities"] = []
    entities.each do |entity|
      return_json["entities"] << {
        "table_name": entity.split(" ")[2],
        "columns": resolve_columns(entity)
      }
    end
    p return_json
  end

  def resolve_columns(entity)
    column_array = []

    column = {}

    count = 0
    entity.each_line do |line|
      next unless count != 0 || entity.split(" ")[0] == "FOREIGN"
      column["name"] = line.split(" ")[0]
      # continue here...
      column["type"] = false
      column["primary_key?"] = false
      column["foreign_key?"] = false
      column_array << column
    end

    return column_array
  end
end