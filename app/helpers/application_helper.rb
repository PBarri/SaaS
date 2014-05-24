module ApplicationHelper

	def sortable(column, title = nil)
		title ||= column.titleize
		direction = (column == params[:sort] && params[:direction] == "ASC") ? "DESC" : "ASC"
		ratings = params[:ratings]
		link_to title, movies_path(:sort => column, :direction => direction, :ratings =>ratings), id: column+"_header"
	end

end
