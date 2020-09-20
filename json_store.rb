class JSONStore

  attr_accessor :jsons, :store_json

  def initialize()
     @jsons = []
  end

  def store_json(json)
    @jsons << json
  end

end