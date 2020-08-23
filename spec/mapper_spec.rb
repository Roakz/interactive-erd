require_relative '../mapper'

RSpec.describe Mapper do
  it "performs a hello world test" do
    expect("hello world!").to eq("hello world!")
  end
end