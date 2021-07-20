class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings_to_show = (params[:ratings] != nil) ? params[:ratings].keys : @all_ratings
    if params[:ratings]
      session[:ratings] = @ratings_to_show
      @rating_hash = Hash[@ratings_to_show.collect { |item| [item, 1] } ]
    elsif session[:ratings]
      @rating_hash = Hash[@ratings_to_show.collect { |item| [item, 1] } ]
      if params[:sort]
        redirect_to movies_path(:ratings => @rating_hash, :sort => params[:sort])
      else
        redirect_to movies_path(:ratings => @rating_hash)
      end
      
    else
      @ratings_to_show =  @all_ratings
    end 
    @movies = Movie.with_ratings(@ratings_to_show)
    @for_title = ""
    if params[:sort] == "title"
      @for_title = "hilite bg-warning"
    end
    @for_release = ""
    if params[:sort] == "release_date"
      @for_release = "hilite bg-warning"
    end
    @movies = @movies.order(params[:sort]) if params[:sort] != ''
  
      
      
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
end
