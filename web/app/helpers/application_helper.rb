module ApplicationHelper
	def is_valid_name? name
		ex = /^[a-zA-Z\d\s]*$/
    return ex.match(name)
  end
end
