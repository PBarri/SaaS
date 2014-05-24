class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    session[:sort] = params[:sort]
    session[:direction] = params[:direction]
    session[:ratings] = params[:ratings]
    # will render app/views/movies/show.<extension> by default
  end

  def index
	if session.has_key?(:sort) || session.has_key?(:direction) || session.has_key?(:ratings)
		flash.keep
		@sort = session[:sort]
		@direction = session[:direction]
		@ratings = session[:ratings]
		session.clear
		redirect_to movies_path(:sort => @sort, :direction => @direction, :ratings => @ratings)
	end
    @all_ratings = (params[:all_ratings] != nil) ? params[:all_ratings] : Movie.ratings
    @sort = params[:sort]
    @direction = params[:direction]
    @ratings = (session.has_key?(:ratings)) ? session[:ratings] : params[:ratings]
    @movies_id = (session.has_key?(:movies_ratings)) ? session[:movies_ratings] : Movie.select("id")
    @movies = Movie.all
    if @ratings != nil
		@movies = Array.new
		@movies_id = Array.new
		@all_ratings.each { |k, v|
			@all_ratings[k] = false;
		}
		@ratings.each { |k, v|
			@movies.concat(Movie.where(rating: k).all)
			@movies_id.concat(Movie.select("id").where(rating: k))
			@all_ratings[k] = true;
		}
		session[:movies_ratings] = @movies_id
	end
    if @sort == "title"
		@movies = Movie.order("title" + ' ' + @direction).where(id: @movies_id)
		@titleClass = "hilite"
	elsif @sort == "release_date"
		@movies = Movie.order("release_date" + ' ' + @direction).where(id: @movies_id)
		@releaseClass = "hilite"
	end
	session[:movies_ratings] = @movies_id
	session[:all_ratings] = @all_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
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
    redirect_to movies_path
  end

end
