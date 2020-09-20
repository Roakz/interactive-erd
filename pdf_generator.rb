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
    @logger.error(@hash)

    @pdf = Prawn::Document.new
  
    pdf.add_dest "top-link", pdf.dest_xyz(pdf.bounds.absolute_left, pdf.y)

    generate_heading(@pdf, "#{@hash["top_level"]["database"].first} Interactive ERD")
    @pdf.move_down 10
   
    @hash["entities"].each do |entity|
    generate_contents_line(@pdf, entity)
    end

    @hash["entities"].each do |entity|
     generate_entity_tables(@pdf, entity)
    end
    return @pdf
  end

  def generate_contents_line(pdf, entity)
    pdf.text "<link anchor=\"#{entity["table_name"]}\"><strong>#{entity["table_name"]}</strong></link>", inline_format: true
    pdf.move_down 10

    include_key_links(entity)

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

  def generate_entity_tables(pdf, entity)
    table = []
    table << ["Column", "Data type"]

    entity["columns"].each do |column|
      table << [column["column_name"], column["data_type"]]
    end

    pdf.start_new_page
    pdf.add_dest "#{entity["table_name"]}", pdf.dest_xyz(pdf.bounds.absolute_left, pdf.y)
    pdf.text "<strong>#{entity["table_name"]}</strong>", inline_format: true
    pdf.move_down 10
    pdf.table(table)
    pdf.move_down 10

    include_key_links(entity)

    pdf.move_down 10
    pdf.text "<link anchor=\"top-link\"><strong>Back to top</strong></link>", inline_format: true
  end

  def include_key_links(entity)
    if entity["keys"] && entity["keys"].empty? == false
      entity["keys"].each do |key_obj|
        if key_obj["type"] == "foreign"
          pdf.text "<link anchor=\"#{key_obj["ref_table"]}\">  - #{key_obj["ref_table"]}</link>", inline_format: true
        end
      end
    end
  end

end