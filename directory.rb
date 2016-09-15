#I've had a bit of fun with this, and added the extra functionality of saving / changing the default data
# and checking for 12 characters and duplicates.

require 'CSV'

def setup
  if File.exist?("defaults.csv")
    file, cohort = CSV.read("defaults.csv")[0]
    valid_cohorts = CSV.read("defaults.csv")[1]
    data_list = CSV.read("defaults.csv")[2]
    @filename = file
    @cohort = cohort
    @valid_cohorts = valid_cohorts
    @data_list = data_list
    @students = []
    @letter = ""
  else
    CSV.open("defaults.csv", "wb") do |csv|
      csv << "students.csv,november".parse_csv
      csv << "january,february,march,april,may,june,july,august,september,october,november,december".parse_csv
      csv << "cohort,hobbies,country,height".parse_csv
    end
    setup
  end
end

def try_load_students
  unless ARGV.first.nil?
    @filename = ARGV.first
  end
  if File.exists?(@filename)
    load_students
  else
    puts
    puts "Sorry, #{@filename} doesn't exist"
    exit
  end
end

def load_students
  count = 0
  CSV.foreach(@filename) do |line|
    name, cohort = line
    hash = {name: name, cohort: cohort.to_sym}
    unless @students.any? {|student| student[:name] == hash[:name]}
      @students << hash
      count += 1
    end
  end
  puts
  puts "Loaded #{count} students from #{@filename}"
end

def interactive_menu
  loop do
    print_menu
    selection = STDIN.gets.chomp
    case selection
      when "1"
        input_students
      when "2"
        show_students
      when "3"
        ask_for_file
        save_students
      when "4"
        ask_for_file
        load_students
      when "5"
        specify_letter
      when "6"
        change_defaults "new_cohort"
      when "7"
        change_defaults "filename"
      when "8"
        change_defaults "cohort"
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
  puts "3. Save the list to a file"
  puts "4. Load the list from a file"
  puts "5. Select students by first letter of name"
  puts "6. Add new valid cohort"
  puts "7. Change default backup file"
  puts "8. Change default cohort"
  puts "9. Exit"
end

def input_students
  while true do
    hash = {}
    puts "Please enter a student name, or to finish, hit return."
    name = STDIN.gets.chomp
    if name.empty?
      break
    end
    if !@students.any? {|student| student[:name] == name}
      if name.length < 12
        hash[:name] = name
        hash = additional_info(hash, name)
      else
        puts
        puts "Names must be 12 characters or less.  Please re-enter."
        puts
      end
    else
      puts
      puts "This name already exists.  Please re-enter."
      puts
    end
  end
end

def additional_info hash, name
  @data_list.each do |info|
    puts "Please specify #{info} for #{name}."
    puts "Hit return for the default cohort of #{@cohort}" if info == "cohort"
    input = STDIN.gets.chomp
    input = cohort_check(input) if info == "cohort"
    hash[info.to_sym] = input
  end
  @students << hash
  print "Now we have #{@students.length} student"
  puts (@students.length > 1)? "s." : "."
  puts
end

def cohort_check input
  while true do
    if input.empty?
      input = @cohort.to_sym
      puts "Default cohort of #{@cohort} will be applied."
      puts
      break
    elsif @valid_cohorts.any? {|x| x == input.downcase}
      input = input.downcase.to_sym
      break
    else
      puts "That is not a valid cohort name."
      puts "Please try again, or hit return for the default cohort."
      input = STDIN.gets.chomp
    end
  end
  input
end

def show_students
  if @students.length > 0
    if @letter.empty?
      print_header
      print_student_list
      print_footer
      puts "."
    else
      print_letter
      @letter = ""
    end
  else
    puts "No students have been entered into the system."
  end
end

def print_header
  puts
  puts "The students of Villians Academy"
  puts "-------------"
end

def print_student_list(selection = @students)
  count = 0
  @valid_cohorts.each do |cohort|
    selection.each do |student|
      if student[:cohort] == cohort.to_sym
        count += 1
        puts "#{count}. #{student[:name].center(12)} (#{student[:cohort]} cohort)"
      end
    end
  end
end

def print_letter
  print_header
  selection = @students.select {|student|student[:name][0].downcase == @letter.downcase}
  print_student_list(selection)
  print_letter_footer(selection)
end

def print_footer(selection = @students)
  print "Overall, we have #{selection.length} great student"
  print "s" if selection.length > 1
end

def print_letter_footer(selection)
  print_footer(selection)
  puts " whose name begins with #{@letter}."
end

def ask_for_file
  puts "Please specify a filename, or hit return for the default (#{@filename})"
  file = STDIN.gets.chomp
  if File.exist?(file)
    @filename = file if !file.empty?
  else
    puts "Sorry that file does not exist.  Try again."
  end
end

def save_students
  CSV.open(@filename, "wb") do |csv|
    @students.each do |student|
        csv << [student[:name], student[:cohort]]
    end
  end
  puts "Student data has been saved to #{@filename}"
end

def specify_letter
  puts "Please input the first letter."
  @letter = STDIN.gets.chomp
  show_students
end

def save_defaults
  File.delete("defaults.csv")
  CSV.open("defaults.csv", "wb") do |csv|
    csv << [@filename, @cohort]
    csv << @valid_cohorts
    csv << @data_list
  end
end

def change_defaults default
  case default
  when "filename"
    puts "Please input a new default filename."
    input = STDIN.gets.chomp
    @filename = input
  when "new_cohort"
    puts "Please input a new valid cohort."
    input = STDIN.gets.chomp
    @valid_cohorts << input.to_sym
  when "cohort"
    puts "Please input a new default cohort."
    input = STDIN.gets.chomp
    @cohort = cohort_check(input)
  end
save_defaults
puts "That's been saved.  You'll need to restart for this to take effect"
exit
end

setup
try_load_students
interactive_menu
