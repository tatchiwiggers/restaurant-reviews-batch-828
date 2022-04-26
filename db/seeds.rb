# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts 'cleaning up database...'
Restaurant.destroy_all
puts 'database is clean!'


puts 'Creating restaurants'
100.times do
  restaurant = Restaurant.create!(
    name: Faker::Restaurant.name,
    address: Faker::Address.city,
    rating: rand(1..5),
    chef_name: ['Gordon Ramsey', 'Gido', 'Alain Ducasse', 'Jamie Oliver'].sample
  )
  puts "restaurant #{restaurant.id} is created."
end

puts 'All Done!'
