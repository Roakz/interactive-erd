class Mapper
  attr_accessor :file, :load_file
  attr_reader :calculate_top_level, :split_entities, :entities_to_json

  def initialize(params = {})
    @file = params[:file] ? params[:file] : nil
    @key_map_array = []
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
      if line.include? " CREATE SCHEMA" 
        schema_arr << line.gsub(/\/\*.[^\*\/]*\*\//, '').tr("`", "")
      end
      if line.include? "CREATE DATABASE"
        database_arr << line.gsub(/\/\*.[^\*\/]*\*\//, '').tr("`", "")
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
      if line.include? "CREATE TABLE"
       entity = line
       skip = false
      end
      next unless !skip
      entity += line unless line == entity
      skip = line.include? ";"
      skip ? entities << entity : next
    end
    entities
  end

  def entities_to_json(entities)
    return_json = {}
    return_json["top_level"] = calculate_top_level
    return_json["entities"] = []
    entities.each do |entity|
      entity_name = entity.split(" ")[2].tr('`', '')
      return_json["entities"] << {
        "table_name": entity_name,
        "columns": resolve_columns(entity_name, entity)
      }
    end
    return_json
  end

  def resolve_columns_skip?(line)
    ["DROP TABLE", "USE", "CREATE TABLE", ";", "REFERENCES", "KEY"].each do |skip_value|
     if line.include? skip_value
       return true
     end
    end
    return true if ["PRIMARY", "FOREIGN", "--"].include? line.split[0]
    return false
  end

  def line_for_data_type(line)
    return line.split[1].gsub(/\([0-9]{1,3}\)?,?[0-9]{0,3}\)|,\z/, '')
  end

  def store_key_mapping_lines(entity, line)
    return unless line.include? "KEY"
    @key_map_array << {:entity => entity, :line => line}
  end

  def resolve_columns(entity_name, entity)
    column_array = []

    entity.each_line do |line|

      store_key_mapping_lines(entity_name, line)

      next if resolve_columns_skip?(line)
  
      column = {}
    
      column["column_name"] = line.split(" ")[0].tr('`', "")
      column["data_type"] = line_for_data_type(line)
      column_array << column
    end
    return column_array
  end
end