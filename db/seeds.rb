# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Task.destroy_all
questions = [
  "What's the hardest thing you've ever done?",
  'Is it more important to be book-smart or street-smart?',
  'Are you mentally or physically tougher?',
  'What did you want to be when you were young?',
  'Would you rather be a great musician, artist, or athlete?',
  'Is it more essential to develop beliefs or gain knowledge?',
  'Do you tend to live in the past, present or future?',
  'What do you dream your life will be like in 10 years?',
  'What are the most important qualities in friends?',
  "What's the strangest thing you've ever eaten?",
  'What three adjectives would your family use to describe you?',
  'Who do you think is the most inspirational person alive today?',
  'What would you try if you had no fear?',
  "What's your dream job?",
  'What one fear would you like to conquer?',
  'What would you most like to learn how to do on a computer?',
  'If you went on a volunteer vacation who would you most like to help',
  'If you could work as an assistant to anyone for a year who would you choose?',
  "What's the funniest advice your mother gave you?",
  'In which activity would you like a lesson from an expert?',
  'What do you miss about childhood?',
  'Which of your personality traits would you like to change?',
  'What do you wish you were better at saying NO to?',
  "What remains undone that you've wanted to get done for years?",
  'What is your favorite quote?',
  'What are your favorite apps?',
  'What is the best thing about Chengdu?',
  'Which book dramatically influenced your life?',
  'What is your proudest accomplishment?',
  'What one goal do you hope to accomplish this year?',
  'Why did you come to Demo Day?'
]

questions.each do |q|
  task = Task.new(description: q)
  task.save
end
