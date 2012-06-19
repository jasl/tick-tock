# -*- encoding : utf-8 -*-

require 'time'

unless User.where(:email => 'demo@demo.com').exists?
  puts "Creating demo user..."
  User.create! :email => 'demo@demo.com',
               :password => 'password',
               :name => '演示者'
end
demo = User.where(:email => 'demo@demo.com').first

unless demo.moments.empty?
  puts "Clearing demo user's' moments..."
  demo.moments.destroy_all
end

puts "Creating demo moments..."
1.upto(200) do |i|
  moment = demo.moments.build :note_attributes => {:body => "日记#{i}"*100}
  # just a demo, avoid any wrong :-)
  year, month, day, time = rand(11) + 2000, rand(11) + 1, rand(28) + 1, Time.parse("#{rand(22)+1}:#{rand(58)+1}:#{rand(58)+1}")
  # p "#{year}-#{month}-#{day} #{time.hour}:#{time.min}:#{time.sec}"
  moment.year = year
  moment.month = month
  moment.day = day
  moment.time = time
  moment.save!
end

puts "Demo seed was successfully created."

puts "Demo user:"
puts "- Email: demo@demo.com"
puts "- Password: password"
