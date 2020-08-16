class Mapper
  attr_accessor :file, :load_file
  attr_reader :calculate_top_level

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
end