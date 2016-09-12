def input_students
  students = []
  additional_info = [:cohort, :hobbies, :country_of_birth, :height]
  valid_cohorts = [:january, :february, :march, :april, :may, :june, :july, :august, :september, :october,:november, :december]
  default_cohort = :november
  while true do
    hash = {cohort: default_cohort}
    puts "Please enter a student name, or to finish, hit return twice."
    name = gets.chomp
    if name.empty?
      break
    end
    hash[:name] = name
    additional_info.each do |info|
      puts "Please specify #{info.to_s} for #{name}."
      input = gets.chomp
      if info == :cohort
        while true do
          if input.empty?
            puts "Default cohort of #{default_cohort.to_s} has been input."
            puts
            break
          end
          if valid_cohorts.any? {|x| x == input.to_sym}
            hash[info] = input.to_sym
            break
          else
            puts "That is not a valid cohort name.  Please try again, or hit return for the default cohort."
            input = gets.chomp
          end
        end
      else
        hash[info] = input
      end
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
