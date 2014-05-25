class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
    @sort = session[:sort]
    @direction = session[:direction]
    @ratings = session[:ratings]
  end

  def index
    
    @all_ratings = Movie.ratings
    
    sort = (params[:sort] != nil) ? params[:sort] : session[:sort]
	direction = (params[:direction] != nil) ? params[:direction] : session[:direction]
    @ratings = (params[:ratings] != nil) ? params[:ratings] : session[:ratings]
	@ratings = @all_ratings if @ratings == nil
    
    session[:sort] = sort
    session[:direction] = direction
    session[:ratings] = @ratings
    
    if params[:redirect] != nil
		flash.keep
		redirect_to movies_path(:sort => sort, :direction => direction, :ratings => @ratings)
    end
    
    case sort
    when 'title'
		@titleClass = "hilite"
		@movies = Movie.find_all_by_rating(@ratings.keys, order: sort + ' ' + direction)
	when 'release_date'
		@releaseClass = "hilite"
		@movies = Movie.find_all_by_rating(@ratings.keys, order: sort + ' ' + direction)
	else
		@movies = Movie.find_all_by_rating(@ratings.keys)
	end    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(:sort => session[:sort], :direction => session[:direction], :ratings => session[:ratings])
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path(:sort => session[:sort], :direction => session[:direction], :ratings => session[:ratings])
  end

end
