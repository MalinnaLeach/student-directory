def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  # create an empty array
  students = []
  # get the first names
  name = gets.chomp
  # while the name is not empty, repeat this code
  while !name.empty? do
    # add the student hash to the array
    students << {name: name, cohort: :november}
    puts "Now we have #{students.count} students"
    # get another name from the user
    name = gets.chomp
  end
  # return the array of students
  students
end

def print_header
  puts "The students of Villians Academy"
  puts "-------------"
end

def prints(students)
  students.each do |student|
    if (student[:name].split "")[0].downcase == $letter.downcase
      $report << {name: student[:name], cohort: student[:cohort]}
    end
  end
  $report.each do |student|
    if student[:name].length < 12
    $count += 1
    puts "#{$count}. #{student[:name]} (#{student[:cohort]} cohort)"
    end
  end
end

def print_footer(names)
  print "Overall, we have #{$report.length} great student"
  if $report.length > 1
    print "s"
  end
  if !$letter.empty?
    puts " whose name begins with #{$letter}"
  end
  if $count < $report.length
    print "#{$report.length - $count} student"
    if ($report.length - $count) > 1
      print "s were"
    else
      print " was"
    end
    puts " not listed as their name is more than 12 characters"
  end
end
#nothing happens until we call the methods
students = input_students
puts "Would you like to specify a first letter?  If so, type the letter, otherwise hit return."
$letter = gets.chomp
$report = []
$count = 0
print_header
prints(students)
print_footer(students)
