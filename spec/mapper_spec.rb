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

    it "returns entities correctly as expected" do 
      expect(@result[0]).to eq("CREATE TABLE production.categories (\r\n\tcategory_id INT IDENTITY (1, 1) PRIMARY KEY,\r\n\tcategory_name VARCHAR (255) NOT NULL\r\n);\r\n")
      expect(@result[8]).to eq("CREATE TABLE production.stocks (\r\n\tstore_id INT,\r\n\tproduct_id INT,\r\n\tquantity INT,\r\n\tPRIMARY KEY (store_id, product_id),\r\n\tFOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,\r\n\tFOREIGN KEY (product_id) REFERENCES production.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE\r\n);")
    end
  end
end