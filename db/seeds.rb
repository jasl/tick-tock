# -*- encoding : utf-8 -*-

unless User.where(:email => 'demo@demo.com').exists?
  puts "Creating demo user..."
  User.create! :email => 'demo@demo.com',
               :password => 'password',
               :name => '演示者'
end
demo = User.where(:email => 'demo@demo.com').first

unless demo.moments.empty?
  puts "Clearing demo user's' moments..."
  demo.moments.clear
end

puts "Creating demo moments..."
1.upto(200) do |i|
  demo.moments.create :note_attributes => {:body => "日记#{i}"}
end

puts "Demo seed was successfully created."

puts "Demo user:"
puts "- Email: demo@demo.com"
puts "- Password: password"
