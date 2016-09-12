def input_students
  students = []
  additional_info = [:hobbies, :country_of_birth, :height]
  while true do
    hash = {}
    puts "Please enter a student name, or to finish, hit return twice."
    name = gets.chomp
      if name.empty?
        break
      end
    hash[:name] = name
    hash[:cohort] = :november
    additional_info.each do |info|
      puts "Please specify #{info.to_s} for #{name}."
      input = gets.chomp
      hash[info] = input
    end
    students << hash
  end
  students
end

def print_header
  puts
  puts "The students of Villians Academy"
  puts "-------------"
end

def prints(students)
  index = 0
  students.each do |student|
    if ((student[:name].split "")[0].downcase == $letter.downcase) || $letter.empty?
      $report << {name: student[:name], cohort: student[:cohort]}
    end
  end
  until index == $report.length do
    student = $report[index]
    if student[:name].length < 12
    $count += 1
    puts "#{$count}. #{student[:name].center(12)} (#{student[:cohort]} cohort)"
    end
    index += 1
  end
end

def print_footer(names)
  print "Overall, we have #{$report.length} great student"
  if $report.length > 1
    print "s"
  end
  if !$letter.empty?
    puts " whose name begins with #{$letter}."
  else
    puts "."
  end
  if $count < $report.length
    print "#{$report.length - $count} student"
    if ($report.length - $count) > 1
      print "s were"
    else
      print " was"
    end
    puts " not listed as their name is more than 12 characters."
  end
end
#nothing happens until we call the methods

students = input_students
if students.length > 0
  puts "Would you like to specify a first letter?  If so, type the letter, otherwise hit return."
  $letter = gets.chomp
  $report = []
  $count = 0
  print_header
  prints(students)
  print_footer(students)
else
  puts "No students have been entered into the system"
end
