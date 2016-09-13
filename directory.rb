@students = []
@report = []
@count = 0
@valid_cohorts = [:january, :february, :march, :april, :may, :june, :july, :august, :september, :october,:november, :december]
@letter = ""

def load_students
  file = File.open("students.csv", "r")
  file.readlines.each do |line|
    name, cohort = line.chomp.split(",")
    @students << {name: name, cohort: cohort.to_sym}
  end
  file.close
end

def interactive_menu
  loop do
    print_menu
    selection = gets.chomp
    case selection
      when "1"
        input_students
      when "2"
        show_students
      when "3"
        save_students
      when "4"
        load_students
      when "9"
        exit
      else
        puts "I don't know what you meant, try again"
    end
  end
end

def print_menu
  puts
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to students.csv"
  puts "4. Load the list from students.csv"
  puts "9. Exit"
end

def input_students
  additional_info = [:cohort, :hobbies, :country_of_birth, :height]
  default_cohort = :november
  while true do
    hash = {cohort: default_cohort}
    puts "Please enter a student name, or to finish, hit return."
    name = gets.delete "\n"
    if name.empty?
      break
    end
    hash[:name] = name
    additional_info.each do |info|
      puts "Please specify #{info.to_s} for #{name}."
      input = gets.delete "\n"
      if info == :cohort
        while true do
          if input.empty?
            puts "Default cohort of #{default_cohort.to_s} has been input."
            puts
            break
          end
          if @valid_cohorts.any? {|x| x == input.downcase.to_sym}
            hash[info] = input.downcase.to_sym
            break
          else
            puts "That is not a valid cohort name.  Please try again, or hit return for the default cohort."
            input = gets.delete "\n"
          end
        end
      else
        hash[info] = input
      end
    end
    @students << hash
    print "Now we have #{@students.length} student"
    puts (@students.length > 1)? "s." : "."
    puts
  end
end

def print_header
  puts
  puts "The students of Villians Academy"
  puts "-------------"
end

def print_student_list
  @students.each do |student|
    if ((student[:name].split "")[0].downcase == @letter.downcase) || @letter.empty?
      @report << {name: student[:name], cohort: student[:cohort]}
    end
  end
  @valid_cohorts.each do |cohort|
    @report.each do |student|
      if student[:name].length < 12 && student[:cohort] == cohort
        @count += 1
        puts "#{@count}. #{student[:name].center(12)} (#{student[:cohort]} cohort)"
      end
    end
  end
end

def print_footer
  print "Overall, we have #{@report.length} great student"
  if @report.length > 1
    print "s"
  end
  puts (!@letter.empty?)? " whose name begins with #{@letter}." : "."
  if @count < @report.length
    print "#{@report.length - @count} student"
    print ((@report.length - @count) > 1)? "s were" : " was"
    puts " not listed as their name is more than 12 characters."
  end
end

def show_students
  if @students.length > 0
    puts "Would you like to specify a first letter?  If so, type the letter, otherwise hit return."
    @letter = gets.delete "\n"
    print_header
    print_student_list
    print_footer
  else
    puts "No students have been entered into the system."
  end
end

def save_students
  file = File.open("students.csv", "w")
  @students.each do |student|
    student_data = [student[:name], student[:cohort]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  file.close
end

interactive_menu
