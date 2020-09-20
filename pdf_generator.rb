require 'prawn'
require 'prawn/table'
require 'json'

class PdfGenerator

  attr_accessor :generate, :pdf

  def initialize(json, logger)
    @logger = logger 
    @json = json
    @hash = JSON.parse(@json)
  end

  def generate
    @pdf = Prawn::Document.new
    # take care of the top level stuff before we iterate.
    generate_heading(@pdf, "#{@hash["top_level"]["database"].first} Interactive ERD")
    @pdf.move_down 10
   
    @hash["entities"].each do |entity|
    generate_contents_line(@pdf, entity["table_name"])
    end

    @hash["entities"].each do |entity|
     generate_entity_tables(@pdf, entity["columns"], entity["table_name"])
    end
    return @pdf
  end

  def generate_contents_line(pdf, table_name)
    pdf.text "<link anchor=\"#{table_name}\">#{table_name}</link>", inline_format: true
    pdf.move_down 10
    pdf.stroke_horizontal_rule
    pdf.move_down 10
  end

  def generate_heading(pdf, heading)
    pdf.move_down 50
    pdf.formatted_text_box([
    { :text => heading,
      :size => 25,
      :styles => [:bold] }])
    pdf.stroke_horizontal_rule
  end

  def generate_entity_tables(pdf, entity_columns, table_name)
    table = []
    table << ["Column", "Data type"]
     entity_columns.each do |column|
       table << [column["column_name"], column["data_type"]]
     end
     pdf.start_new_page
     pdf.add_dest "#{table_name}", pdf.dest_xyz(pdf.bounds.absolute_left, pdf.y)
     pdf.text(table_name)
     pdf.move_down 10
     pdf.table(table)
  end
end