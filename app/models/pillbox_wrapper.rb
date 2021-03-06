class PillboxWrapper
  PB_KEY = ENV["pb_key"]

  def self.nokogiri_parse(xml)
    image_ids = Nokogiri::XML(xml).xpath("//image_id").select{|image|image.text!=""}
    if image_ids.any?
      image_id = image_ids.last.text
    else
      image_id = ""
    end
    self.get_image_uri(image_id)
  end 

  def self.request(rxcui)
    base_url = "http://pillbox.nlm.nih.gov/PHP/pillboxAPIService.php?key=" + PB_KEY + "&rxcui="
    request_url = base_url + rxcui
    api_request = URI(URI.encode(request_url))
    api_response = Net::HTTP.get(api_request)
    self.nokogiri_parse(api_response)
  end

  def self.get_image_uri(image_id)
    if image_id == ""
      "/no_image.jpg"
    else
      "http://pillbox.nlm.nih.gov/assets/small/" + image_id + ".jpg"
    end
  end
end
