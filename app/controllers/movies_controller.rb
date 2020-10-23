class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    if (params[:ratings].nil? && !session[:ratings].nil?) || (params[:sort].nil? && !session[:sort].nil?)
      
      session[:ratings] = params[:ratings] || session[:ratings]
      session[:sort] = params[:sort] || session[:sort]
      redirect_to movies_path(:ratings => session[:ratings], :sort => session[:sort])
    end

    # if !session[:ratings].nil? || !session[:sort].nil?
    #   if !session[:ratings].nil? && session[:sort].nil?
    #     session[:sort] = params[:sort]
    #   elsif session[:ratings].nil? && !session[:sort].nil?
    #     session[:ratings] = Hash[Movie.all_ratings.map {|v| [v,'1']}]
    #   end
    #   redirect_to movies_path(:ratings => session[:ratings], :sort => session[:sort])
    # end

    @ratings_to_show = []
    @sort = params[:sort]
    
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
      filter_ratings = params[:ratings].select {|k, v| v != "0"}
      @ratings_to_show = filter_ratings.keys
    else
      @ratings_to_show = Movie.all_ratings
    end
    # binding.pry

    if !params[:sort].nil?
      session[:sort] = params[:sort]
      @sort = params[:sort]
    end

    
    
    @ratings_to_show = Movie.all_ratings if @ratings_to_show.empty?
    @movies = Movie.with_ratings(@ratings_to_show, @sort)
    
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
