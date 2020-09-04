require_relative '../mapper'
require_relative 'column_list'
require_relative 'ordered_data_type_list'
require_relative 'key_mapping_list'

# This test file uses test.sql and loads it into the Mapper class to use a set of known data to test class output results.

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
      @returned_key_mappings = []
      @result["entities"].each do |entity|
       @returned_key_mappings << entity[:keys]
      end
      expect(@returned_key_mappings).to eq(key_mapping_list)
    end

    it "should contain the correct data types for each column" do
      @returned_array = []
      @result["entities"].each do |entity|
        entity[:columns].each {|column| @returned_array << column["data_type"]}
      end
      expect(@returned_array).to eq(ordered_data_type_list)
    end    

    it "should return a valid json object" do
      expect {JSON.parse(@result.to_json)}.not_to raise_error
    end
  end
  context("entites to json error test") do
    it "should throw an error if invalid data types are given"  do
      @entities = @mapper.split_entities
      @entities[0] = "CREATE TABLE `customers` (\r\n  `customerNumber` STRING NOT NULL,\r\n  `customerName` varchar(50) NOT NULL,\r\n  `contactLastName` varchar(50) NOT NULL,\r\n  `contactFirstName` varchar(50) NOT NULL,\r\n  `phone` varchar(50) NOT NULL,\r\n  `addressLine1` varchar(50) NOT NULL,\r\n  `addressLine2` varchar(50) DEFAULT NULL,\r\n  `city` varchar(50) NOT NULL,\r\n  `state` varchar(50) DEFAULT NULL,\r\n  `postalCode` varchar(15) DEFAULT NULL,\r\n  `country` varchar(50) NOT NULL,\r\n  `salesRepEmployeeNumber` int(11) DEFAULT NULL,\r\n  `creditLimit` decimal(10,2) DEFAULT NULL,\r\n  PRIMARY KEY (`customerNumber`),\r\n  KEY `salesRepEmployeeNumber` (`salesRepEmployeeNumber`),\r\n  CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`salesRepEmployeeNumber`) REFERENCES `employees` (`employeeNumber`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=latin1;\r\n""CREATE TABLE `customers` (\r\n  `customerNumber` int(11) NOT NULL,\r\n  `customerName` varchar(50) NOT NULL,\r\n  `contactLastName` varchar(50) NOT NULL,\r\n  `contactFirstName` varchar(50) NOT NULL,\r\n  `phone` varchar(50) NOT NULL,\r\n  `addressLine1` varchar(50) NOT NULL,\r\n  `addressLine2` varchar(50) DEFAULT NULL,\r\n  `city` varchar(50) NOT NULL,\r\n  `state` varchar(50) DEFAULT NULL,\r\n  `postalCode` varchar(15) DEFAULT NULL,\r\n  `country` varchar(50) NOT NULL,\r\n  `salesRepEmployeeNumber` int(11) DEFAULT NULL,\r\n  `creditLimit` decimal(10,2) DEFAULT NULL,\r\n  PRIMARY KEY (`customerNumber`),\r\n  KEY `salesRepEmployeeNumber` (`salesRepEmployeeNumber`),\r\n  CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`salesRepEmployeeNumber`) REFERENCES `employees` (`employeeNumber`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=latin1;\r\n"
      expect {@mapper.entities_to_json(@entities)}.to raise_exception(InvalidDataType)
    end
  end
end