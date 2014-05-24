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
    @all_ratings = Movie.ratings
    @sort = (session.has_key?(:sort)) ? session[:sort] : params[:sort]
    @direction = (session.has_key?(:direction)) ? session[:direction] : params[:direction]
    @ratings =  (session.has_key?(:ratings)) ? session[:ratings] : params[:ratings]
    session.clear
    @movies = Movie.all
    if @ratings != nil
		@movies = Array.new
		@all_ratings.each { |k, v|
			@all_ratings[k] = false;
		}
		@ratings.each { |k, v|
			@movies.concat(Movie.find_all_by_rating(k))
			@all_ratings[k] = true;
		}
	end
    if @sort == "title"
		@movies = Movie.order("title" + ' ' + @direction).all
		@titleClass = "hilite"
	elsif @sort == "release_date"
		@movies = Movie.order("release_date" + ' ' + @direction).all
		@releaseClass = "hilite"
	end
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
