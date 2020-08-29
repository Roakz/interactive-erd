require_relative '../mapper'
require_relative 'column_list'

# This test file uses test.sql and loads it into the Mapper class to use a set of known data to test results.

RSpec.describe Mapper do

before(:all) do
 @mapper = Mapper.new(:file => File.open("test.sql"))
end
  context("calculate top level function") do

    it "performs a hello world test" do
      expect("hello world!").to eq("hello world!")
    end
  
    it "returns the databases top level names" do
      @top_level_names = @mapper.calculate_top_level
      expect(@top_level_names).to eq({:database => ["classicmodels"], :schema => []})
    end
  end

  context("split entities function") do 

    before(:all) do
      @result = @mapper.split_entities
    end

    it "should return an array" do
      expect(@result).to be_a(Array)
    end 

    it "should contain all entities" do
      expect(@result.length).to eq(8)
    end
  end
  
  context("entites to json function") do
    
    before(:all) do
      @entities = @mapper.split_entities
      @result = @mapper.entities_to_json(@entities)
    end

    it "should contain the top level objects" do
      expect(@result).to include("top_level")
      expect(@result["top_level"]).to eq({:database => ["classicmodels"], :schema => []})
    end

    it "should contain all entities" do
      expect(@result).to include("entities")
      @returned_array = []
      @result["entities"].each {|obj| @returned_array << obj[:table_name]}
      expect(@returned_array).to contain_exactly(
        "customers",
        "employees",
        "offices",
        "orderdetails",
        "orders",
        "payments",
        "productlines",
        "products"
        
      )
    end

    it "should contain all columns" do
      @returned_array = []
      @result["entities"].each do |obj|
        obj[:columns].each {|column| @returned_array << column["column_name"]}
      end
      expect(@returned_array).to eq(column_list)
    end

    it "should contain the correct key mappings" do
    end
    
  end
end