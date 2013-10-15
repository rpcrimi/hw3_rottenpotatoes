class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if !session.has_key?(:ratings) #check if there is a cookie and if not set up so checkboxes are checked
      session[:ratings] = {"G" => 1, "PG" => 1, "PG-13" => 1, "R" => 1}
    else
      if params.has_key?(:ratings) #set session ratings to params ratings
        session[:ratings] = params[:ratings]
      end
    end
    if !params.has_key?(:ratings) #make sure the params are not empty and set to session
      params[:ratings] = session[:ratings]
    end
    if params.has_key?(:sort_by) #set session order to params order
      session[:order] = params[:sort_by]
    end

    @movies = Movie.find_all_by_rating(session[:ratings].keys, :order => session[:order])
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
