class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # Default value
    @all_ratings = Movie.mpaa_ratings
    
    session[:ratings] ||= Hash[@all_ratings.map {|rating| [rating, rating]}]
    session[:sort] ||= 'id'
 
    # If the button is clicked
    if params[:sort]
      session[:sort] = params[:sort]
    end
    
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end
 
    if (!params[:sort] || !params[:ratings])
      flash.keep
      redirect_to :sort => session[:sort], :ratings => session[:ratings]
    end
 
      @movies = Movie.where(:rating => session[:ratings].keys).order(session[:sort])
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
