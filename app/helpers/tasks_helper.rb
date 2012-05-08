module TasksHelper

def projectSelect()
 out = "<select class=\"span2\">"
 names = ["Nest", "Vacation", "Sick Time"]
 names.each do |name|
   out += "<option value=\"#{name}\">#{name}</option>"
 end
 out += "</select>"
  render :inline => out
end

end
