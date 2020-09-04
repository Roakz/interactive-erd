require './lib/data_types.rb'
require 'json'

class InvalidDataType < StandardError
  def message
    "SQL file contains an invalid data type!"
  end
end

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

  def resolve_entity_keys(entity)
    @return_array = []
    entity.each_line do |line|
      next unless line.include? "KEY"
      if line.split[0] == "PRIMARY"
        @extracted_line = line[/\(\W*[a-zA-Z]*\W*(,\W*[a-zA-Z]*\W*)*\)|\)$/]
        if @extracted_line
          @extracted_line = @extracted_line.gsub(/[^\w,]/, '')
          if @extracted_line.split(',').length == 1
            @return_array << {:column_name => @extracted_line, :type => "primary"}
          else
            @extracted_line.split(',').each {|column| @return_array << {:column_name => column, :type => "primary"}}
          end
        end
      end
      if line.include? 'FOREIGN'
        segmented_line = line.split
        segmented_line.reject! {|word| ["CONSTRAINT", "FOREIGN", "KEY", "REFERENCES"].include? word}.reject!.with_index {|v, i| i == 0}
        @return_array << {
          :column_name => segmented_line[0].gsub(/[^\w]/, ''),
          :type => "foreign",
          :ref_table => segmented_line[1].gsub(/[^\w]/, ''),
          :ref_col => segmented_line[2].gsub(/[^\w]/, '')
        }
      end
    end
   @return_array
  end

  def entities_to_json(entities)
    return_json = {}
    return_json["top_level"] = calculate_top_level
    return_json["entities"] = []
    entities.each do |entity|
      entity_name = entity.split(" ")[2].tr('`', '')
      return_json["entities"] << {
        "table_name": entity_name,
        "columns": resolve_columns(entity_name, entity),
        "keys": resolve_entity_keys(entity)
      }
    end
    return return_json
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

  def validate_data_type!(data_type)
    [data_type, data_type.upcase, data_type.capitalize].each {|variation| return true if data_types.include? variation} 
    return false
  end

  def line_for_data_type(line)
    @result = line.split[1].gsub(/\([0-9]{1,3}\)?,?[0-9]{0,3}\)|,\z/, '')
    if validate_data_type!(@result) == false
     raise InvalidDataType
    else
      return @result
    end
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