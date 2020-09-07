require 'prawn'

class PdfGenerator

  attr_accessor :generate, :pdf

  def initialize
    @pdf = Prawn::Document.new
  end

  def generate
    @pdf.text "Testing from within class!"
    return @pdf
  end

end