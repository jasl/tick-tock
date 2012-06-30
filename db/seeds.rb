# -*- encoding : utf-8 -*-

require 'time'

unless User.where(:email => 'jasl123@126.com').exists?
  puts "Creating the great creator..."
  user = User.create! :email => 'jasl123@126.com',
                      :password => 'aaaaaa',
                      :name => 'Jasl'
  user.state = :admin
  user.update
end

unless User.where(:email => 'demo@demo.com').exists?
  puts "Creating demo user..."
  User.create! :email => 'demo@demo.com',
               :password => 'password',
               :name => '演示者'
end

demo = User.where(:email => 'demo@demo.com').first
if demo.moments.empty?
  puts "Creating demo moments..."
  created_times = []
  1.upto(200) do
    # just a demo, avoid any wrong :-)
    created_times<< Time.new(rand(11) + 2000, rand(11) + 1, rand(28) + 1, rand(22)+1, rand(58)+1, rand(58)+1)
  end
  created_times.sort!

  created_times.each_with_index do |time, i|
    moment = demo.moments.build :note_attributes => {:body => "日记#{i+1}"*100}
    moment.theme = :classic
    moment.year = time.year
    moment.month = time.month
    moment.day = time.day
    moment.time = Time.parse time.strftime "%H:%m"
    moment.save!
  end
end

puts "Demo seed was successfully created."

puts "Demo user:"
puts "- Email: demo@demo.com"
puts "- Password: password"
