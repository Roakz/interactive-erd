require_relative '../mapper'

RSpec.describe Mapper do

before(:all) do
 @mapper = Mapper.new(:file => File.open("test.sql"))
end

  it "performs a hello world test" do
    expect("hello world!").to eq("hello world!")
  end

  it "returns the databases top level names" do
    top_level_names = @mapper.calculate_top_level
    expect(top_level_names).to eq({:database => [], :schema => ["production", "sales"]})
  end
  
end