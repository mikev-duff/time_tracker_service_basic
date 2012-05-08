module TasksHelper

def projectSelect()
 names = Array.new
 Project.all.each { |p|  names.push p.name}
 out = "<select class=\"span2\">"
 names.each do |name|
   out += "<option value=\"#{name}\">#{name}</option>"
 end
 out += "</select>"
  render :inline => out
end

end
