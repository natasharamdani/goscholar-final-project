class Gopay < ActiveResource::Base
  self.site = "http://localhost:8083"
  self.include_format_in_path = false
end
