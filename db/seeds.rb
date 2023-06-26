# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


User.create!(name: "Anupam Dahal",
             email: "mail@anupamdahal.com.np",
             password: "foobar",
             password_confirmation: "foobar",
             admin: true)

User.create!(name: "Example User",
             email: "example@gmail.com",
             password: "foobar",
             password_confirmation: "foobar",
             admin: false)


99.times { |n|
  name = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  User.create!(name: name,
               email: email,
               password: "foobar",
               password_confirmation: "foobar",
               admin: false)
}


# Projects

users = User.take(5)

users.each { |user|
  2.times { |n| 
    project_name = Faker::Nation.capital_city
    project = user.projects.create(name: project_name)
    5.times { |nn|
      task_description = Faker::Lorem.sentence(word_count: 10)
      project.tasks.create(description: task_description)
    }
  }
}
