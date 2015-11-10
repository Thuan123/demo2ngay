# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+15}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now) 
end
users = User.order(:created_at).take(6)
50.times do
  title = "Day la title cua posts"
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content,title: title) }
end
# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

#Auto create comment
Micropost.all.each do |m|
  5.times do |n|
    str = Faker::Lorem.sentence(10)
    i = n+1 
    Comment.create(content: str, micropost_id: m.id, user_id: i )
  end
end