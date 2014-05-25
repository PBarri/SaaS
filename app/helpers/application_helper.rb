module ApplicationHelper

	def sortable(column, title = nil)
		title ||= column.titleize
		#direction = (column == params[:sort] && params[:direction] == "ASC") ? "DESC" : "ASC"
		ratings = @ratings
		link_to title, movies_path(:sort => column, :ratings =>ratings), id: column+"_header"
	end

end
