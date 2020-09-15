require 'prawn'
require 'prawn/table'

class PdfGenerator

  attr_accessor :generate, :pdf

  def initialize(json, logger)
    @logger = logger 
    @json = json
  end

  def generate
    @pdf = Prawn::Document.new
    generate_heading(@pdf, "Entity Name")
    pdf.move_down 50
    # generate_entity_table(@pdf)
    return @pdf
  end

  def generate_heading(pdf, heading)
    pdf.move_down 50
    pdf.formatted_text_box([
    { :text => heading,
      :size => 50,
      :styles => [:bold] }])
    pdf.stroke_horizontal_rule
  end

  def generate_entity_table(pdf)
    pdf.table([["Header1", "Header2"],
                  ["row1 col", "row1 col"],
                  ["row2 col", "row2 col"]])
  end

end