Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :restaurants do
    collection do
      # /restaurants/top
      # get 'top', to: 'restaurants#top', as: :top_restaurants
      # after here, go to controller and code top method
      # get :top # generates '/restaurants/top'
      # get '/balances', to: 'balances#controller'
      get :top
    end

    member do
      # /restaurants/:id/chef
      get :chef
    end

    # NESTING:
    # /restaurants/:restaurant_id/reviews
    resources :reviews, only: [:new, :create]
  end
  resources :reviews, only: [:destroy]
end

# COLLECTIONS:
# collections is a method in rails that allows us to
# to create new routes inside the context we are in:
# inside of resources restaurants (inside resources)

# NESTING: ONLY NEST COLLECTION ACTIONS, NEVER MEMBER ACTIONS!
# we are going to nest the route of our reviews inside our restaurants
# because it is related to the restaurant and everytime i create a review
# i need to grab a restaurant id. This id comes from the url.

# DESTROY:
# rails routes | grep reviews
# it is outside of the nesting because it doesnt need an id
# of the restaurant. we only nest when we need an id in the url.
# i dont need a restaurant anymore, all I need is the id of my review

# ONLY NEST COLLECTION ACTIONS!
# https://guides.rubyonrails.org/routing.html