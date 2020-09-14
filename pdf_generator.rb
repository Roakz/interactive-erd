require 'prawn'
require 'prawn/table'

class PdfGenerator

  attr_accessor :generate, :pdf

  def initialize(file)
    @file = File.open(file)
  end

  def generate
    @pdf = Prawn::Document.new
    @pdf.table([["Header1", "Header2"],
                  ["row1 col", "row1 col"],
                  ["row2 col", "row2 col"]])
    return @pdf
  end

end