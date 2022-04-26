# INTRO

TODAY WE WILL GO BEYOND THE CRUD ACTIONS THAT YOU HAVE SEEN
SO FAR, IT JUST SO HAPPENS THAT SOMETIMES YOU WANT TO CREATE
OTHER ROUTES, OTHER THAN:
- index
- new
- create
- show
- edit
- update
- destroy

## SET UP -> follow slides
rails new restaurant-reviews --skip-active-storage --skip-action-mailbox
cd restaurant-reviews
git add .
git commit -m "rails new"
hub create
git push origin master

Active Storage facilitates uploading files to a cloud storage
Action Mailbox routes incoming emails to controller-like mailboxes
for processing in Rails.

While its doing that, lets draw our schema! Today we will work with two models
a restaurant model and a review model - so lets draw our restaurant model
first.


## CREATES MODELS -> design database

Restaurants(table)
id
name
rating
address

So lets continue our setup...

# BOOTSTRAP and all slides up to...

# CRUD
so let have a quick recap on what we did yesterday


# 7 ACTIONS
yesterday you were able to generate all 7 crud actions using this
 nice method here called resources...

# 7 ACTIONS - 2
 explain
 so we are going to go beyound these today!

# SCAFFOLD
first thing im gonna do is generate our app using this generator
here called scaffold.

But i wanna start already by saying that you are not allowed to use this.
first bc if you use it you wont code anything!!!
and also because it generates a lot of things a lot of files that we dont want
and wont use in our app - if you use scaffold, we will know and we will have you
start over. OK?

# GO THROUGH THE SLIDE STEP BY STEP
1. comment jbuilder in gemfile
2. rails g scaffold Restaurant name address stars:integer

Lets see what SCAFFOLD GENERATES:
- it created my migration
- it created my model
- the routes
- and we also have the controller - all coded and ready for us
- and we also have the views

3. rails db:migrate


# SEED
- add faker to gem
- bundle install

require 'faker'

puts 'cleaning up database...'
Restaurant.destroy_all
puts 'database is clean!'


puts 'Creating restaurants'
100.times do
  restaurant = Restaurant.create(
    name: Faker::Restaurant.name,
    address: Faker::Address.city,
    stars: rand(1..5)
    )
  puts "restaurant #{restaurant.id} is created."
end

puts 'All Done!'

use rails c to check everything worked!

git add .
git commit -m "seeds 100 restaurants"

So lets boot our app we see what we have!! rails s
so how do we get to all our restaurants?

lets check rails routes!!

DONT USE SCAFFOLD!!!

# BEYOND CRUD - pass

# TOP RESTAURANTS 1 - read

# TOP RESTAURANTS 2
lets go into our rails console and i want you to tell me the query i need to
write to get this information:

find or where?

Restaurant.find_by(rating: 5)
find_by will return one, the first one

Restaurant.where(rating: 5)
where will return multiple records, all that match that condition

# TOP RESTAURANTS 3 - read
I WANT THIS ROUTE HERE IN MY ROUTES:
GET /restaurants/top

And in order to do that we will introduce two new methods:
- collection
- member

collections is a method in rails that allows us to
to create new routes inside the context we are in: in this case here we are
inside of resources restaurants (inside resources)... so this is where we will
create our top restaurants route.


# config/routes.rb
Rails.application.routes.draw do
  resources :restaurants do
    collection do
      get :top
    end
  end
end

SHOW RAILS ROUTES

GO TO http://localhost:3000/restaurants/top
CREATE CONTROLLER - remind them of CONDING IN SILO
- GO TO CONTROLLER FILE

GO TO http://localhost:3000/restaurants/top
WE NEED THE VIEW!!

- create top.html.erb

YOU CAN CALL THE ROUTE ANYTHING... AS LONG AS YOU MATCH ALL THE NAMES
IN THE CONTROLLER AND THE VIEW.

pass all slides until:

# ABOUT THE CHEF - read slide
So lets use member now!

# SEED FILE!!!
chef_name: ['Gordon Ramsey', 'Gido', 'Alain Ducasse', 'Jamie Oliver'].sample

git add .
git commit -m "adds chef name to restaurants and seeds"

# MEMBER
What we want here is to create a page just to see the chef info. every restaraunt
has a chef, right? so lets do that using member:

member do
  # /restaurants/:id/chef
  get :chef
end

CODE THE CONTROLLER - let it break!!!

THEN PUT :CHEF INSIDE BEFORE ACTION


# NESTED RESOURCES
Time to add out reviews model.

# ADDING REVIEWS - read slide


## CREATE 2ND MODEL
Reviews(table)
id
content
restaurant id (references restaurants id)


# MODELS
rails generate model Review content:text restaurant:references
rails db:migrate

# app/models/restaurant.rb
  class Restaurant < ApplicationRecord
    has_many :reviews, dependent: :destroy
  end

# app/models/review.rb
  class Review < ApplicationRecord
    belongs_to :restaurant
  end

# GENERATE THE CONTROLLER
rails g controller reviews

# ROUTING
# ROUTING - 2 explain the relationship between restaurant and reviews

# config/routes.rb
Rails.application.routes.draw do
  resources :restaurants do
    resources :reviews, only: [ :new, :create ]
  end
end

GO TO RAILS ROUTES

# NEW REVIEW (2) - controller
# app/controllers/reviews_controller.rb
  def new
    # we need @restaurant in our `simple_form_for`
    @review = Review.new
  end

LETS CREATE OUR FORM
<%= simple_form_for @review do |f| %>
  <%= f.input :content %>
  <%= f.submit class: 'btn btn-primary' %>
<% end %>

-->>>>> GO TO NEW.HTML.ERB


# app/controllers/reviews_controller.rb
private

def find_restaurant
  # in our routes for reviews it is :restaurant_id
  @restaurant = Restaurant.find(params[:restaurant_id])
end


# SIMPLE FORM
<!-- app/views/reviews/new.html.erb -->
<%= simple_form_for [ @restaurant, @review ] do |f| %>
  <%= f.input :content %>
  <%= f.submit "Submit review", class: "btn btn-primary" %>
<% end %>

REFRESH LOCALHOST AND INSPECT THE PAGE


GO TO CONTROLLER
# app/controllers/reviews_controller.rb

here we have two actions:

def new
  @review = Review.new
end

def create
end

LETS CODE THE CREATE METHOD!

  def create
    @review = Review.new(review_params)
    @review.restaurant = @restaurant
    @review.save
    redirect_to restaurant_path(@restaurant)
  end

GO TO REVIEWS CONTROLLER

# NEW REVIEW (1)
<!-- app/views/restaurants/show.html.erb -->
<%= link_to 'Leave a review', new_restaurant_review_path(@restaurant) %>

GO GO RESTAURANT SHOW PAGE - CLICK ON "LEAVE REVIEW"
add a review - we dont see anything!!! WHY??

we need to add it to the restaurants show page!

<% @restaurant.reviews.each do |review| %>
  <p><%= review.content %></p>
<% end %>


PASS THE SLIDES UNTIL WE GET TO:
# VALIDATION ERRORS - READ IT
you can see that as for now i can add empty reviews... so lets add
a validation!!

go into rails console and create an empty review.


<!-- app/models/review.rb -->
class Review < ApplicationRecord
  belongs_to :restaurant

  validates :content, presence: true
end

Still if we go on our webpage and create an empty review, we get no feedback!!
let go into our console!!

whawt does this mean?? this means that..
new_review = Review.new
new_review.save
<!-- false -->
new_review.errors.messages

so we need to add and if statement in our controller! and simple form will add
an error msg on the box we dont have to worry about that!
# app/controllers/reviews_controller.rb
NOW IN MY REVIEWS CONTROLLER I HAVE TO SAY:
  if @review.save
    redirect_to restaurant_path(@restaurant)
  else
    render :new
  end



we will stay in the create action but will display the template of the new page
the only difference is that i am not using this instance of @review, which is just
a new review, bc i am not in this action, im still in the create... i am
using the instance of review that failed to save.
and this instance is the one that wasnt saved bc it was blank.

and simple form handles that

if you look at the url, i am no longer in reviews/new... im still in my create
which is my /reviews... if i refresh this page it will break bc this route
is a POST and not a GET.

and simple form handles that, it knows the error and it shows it to us.

So the render basically renders some html, it renders a page.
if THE SAVE fails it will render a new page, and what is this new page?
essentially my form.
this instance of @review has validations and will show errors
renders the "new" route, a new form - we are not redirecting to a new
page, we are rendering the old one.

- add a raise above if @review.save
- in rails console run:
>> @review
=> #<Review id: nil, content: "", restaurant_id: 101, created_at: nil, updated_at: nil>
>> @review.valid?
=> false

# RENDER FORM WITH ERRORS - read

# DESTROY REVIEW

Rails.application.routes.draw do
  resources :restaurants do
    resources :reviews, only: [ :new, :create ]
  end
  resources :reviews, only: [ :destroy ]
end

GO TO REVIEWS CONTROLLER
def destroy
  @review = Review.find(params[:id])
  @review.destroy
  redirect_to restaurant_path(@review.restaurant)
end

<!-- app/views/restaurants/show.html.erb -->

<!-- ... -->

    <li class="list-group-item">
      <%= review.content %>
      <%= link_to "Remove",
                  review_path(review),
                  method: :delete,
                  data: { confirm: "Are you sure?" } %>
    </li>

================================================================================


## migrations!!!! ADDING/REMOVING COLUMNS
- Create a migration:
rails generate migration addAddressToRestaurants address:string

rails generate migration addPriceToRestaurants price:integer
rails generate migration removePriceFromRestaurants price:integer

`TO DESTROY A MIGRATION GENERATED BY MISTAKE:`
rails generate migration dropAddressFromRestaurants address:string (BAD)
rails destroy migration dropAddressFromRestaurants address:string (BAD)

rails c
rails routes

