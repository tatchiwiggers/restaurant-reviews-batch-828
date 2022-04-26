class RestaurantsController < ApplicationController
  before_action :find, only: [:show, :edit, :update, :destroy, :chef]

  def index
    @restaurants = Restaurant.all
  end

  def top
    @restaurants = Restaurant.where(rating: 5)
  end

  def chef
    # find the restaurant first (before_action)
    @chef_name = @restaurant.chef_name
  end

  def show
    # @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    # no view (comes from new view)
    @restaurant = Restaurant.new(restaurant_params) 
    @restaurant.save
    redirect_to restaurant_path(@restaurant)
  end

  def edit
    # @restaurant = Restaurant.find(params[:id])
  end

  def update
    # no view (comes from edit view)
    # @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)
    redirect_to restaurant_path(@restaurant)
  end

  def destroy
    # no view (comes from show view)
    # @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    redirect_to restaurants_path
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :rating)
  end

  # before show, edit, update and destroy run this code!
  def find
    @restaurant = Restaurant.find(params[:id])
  end
end

# ActiveModel::ForbiddenAttributesError
# 1:10mins CRUD class
