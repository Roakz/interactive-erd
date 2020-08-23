require_relative '../mapper'

# This test file uses test.sql and loads it into the Mapper class to use a set of known data to test results.

RSpec.describe Mapper do

before(:all) do
 @mapper = Mapper.new(:file => File.open("test.sql"))
end
  context("calculate top level") do

    it "performs a hello world test" do
      expect("hello world!").to eq("hello world!")
    end
  
    it "returns the databases top level names" do
      @top_level_names = @mapper.calculate_top_level
      expect(@top_level_names).to eq({:database => [], :schema => ["production", "sales"]})
    end
  end

  context("split entities") do 

    before(:all) do
      @result = @mapper.split_entities
    end

    it "returns an array" do
      expect(@result).to be_a(Array)
    end 

    it "contains the correct amount of entities" do
      expect(@result.length).to eq(9)
    end
  end
end