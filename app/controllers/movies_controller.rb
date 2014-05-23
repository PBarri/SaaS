class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    sort = params[:sort]
    ratings = params[:ratings]
    if ratings.is_a?(Array)
		if !ratings.empty?
			ratings.each do |x|
				string = ":rating => x.key AND"
			end
			@movies = Movie.find(string)
		end
    end
    if sort == "title"
		@movies = Movie.order(:order => "title")
		@titleClass = "hilite"
	elsif sort == "release"
		@movies = Movie.find(:order => "release_date")
		@releaseClass = "hilite"
	else    
		@movies = Movie.all
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
