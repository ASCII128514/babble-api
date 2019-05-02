# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
questions = ['Is science or art more essential to humanity?', 'What change would you most like to make for your health', 'What would you love to find at a yard sale?', 'Which celebrity would you most like to see in person?', 'If money were no object what kind if party would you throw?', 'Which American landmark would you most like to see?', 'Which of your personality traits would you like to change?', 'What makes a house a home?', "What's your favorite part of Thanksgiving dinner?", "If you knew you wouldn't get hurt would you rather skydive or view sharks from an underwater cage?", 'What do you wish you were better at saying "no" to?', "What was your grandmother's signiture dish?", 'If you lived to be one hundred would you rather have a sharp mind or a fit body?', "What's your favorite reality TV show?", 'If you could spend the weekend in any city, which would you choose?', 'How will our culture change in the next 100 years?', "What's your favorite dessert?", "What's the most amazing weather you've seen?", 'What was your favorite game to play as a child?']
questions.each do |q|
  task = Task.new(description: q)
  task.save
end
