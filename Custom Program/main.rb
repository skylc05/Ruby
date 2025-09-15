require 'date'
# Define classes for Room, Guest, and Reservation

class Room
  attr_accessor :number, :type

  def initialize(number, type)
    @number = number
    @type = type
  end
end

class Guest
  attr_accessor :name, :contact

  def initialize(name, contact)
    @name = name
    @contact = contact
  end
end

class Reservation
  attr_accessor :guest_name, :guest_contact, :room_number, :start_date, :end_date

  def initialize(guest_name, guest_contact, room_number, start_date, end_date)
    @guest_name = guest_name
    @guest_contact = guest_contact
    @room_number = room_number
    @start_date = start_date
    @end_date = end_date
  end
end

# Functions to handle reading and writing data from files

def read_rooms
  rooms = []
  if File.exist?('rooms.txt')
    File.open('rooms.txt', 'r') do |file|
      while !file.eof?
        number = file.gets.chomp
        type = file.gets.chomp
        rooms << Room.new(number, type)
      end
    end
  else
    puts "No rooms file found. Please create 'rooms.txt' with room details."
  end
  rooms
end

def read_reservations (guests)
  reservations = []
  if File.exist?('reservations.txt')
    File.foreach('reservations.txt') do |line|
      data = line.chomp.split(',')
      guest = Guest.new(data[0], data[1])
      reservations << Reservation.new(data[0], data[1], data[2], data[3], data[4])
      guests << guest unless guests.any? { |g| g.name == guest.name }
    end
  end
  reservations
end

def write_reservations(reservations)
  File.open('reservations.txt', 'w') do |file|
    reservations.each do |res|
      file.puts("#{res.guest_name},#{res.guest_contact},#{res.room_number},#{res.start_date},#{res.end_date}")
    end
  end
end

# Utility functions

def room_exists?(room_number, rooms)
  rooms.any? { |room| room.number == room_number }
end

# Display functions

def display_rooms(rooms)
  puts "\nAvailable Rooms:"
  rooms.each_with_index do |room, index|
    puts "Room #{index + 1}: Number #{room.number}, Type: #{room.type}"
  end
end

def display_reservations(reservations, guests)
  if reservations.empty?
    puts "\nNo reservations found."
  else
    puts "\nReservations:"
    reservations.each_with_index do |res, index|
      puts "#{index + 1}. Guest: #{res.guest_name} (Contact: #{res.guest_contact})"
      puts "Room: #{res.room_number}"
      puts "Dates: #{res.start_date} to #{res.end_date}"
    end
  end
end

# Reservation functions

def book_room(rooms, reservations, guests)
  puts "Enter Guest Name:"
  guest_name = gets.chomp
  puts "Enter Guest Contact Information:"
  guest_contact = gets.chomp

  existing_reservation = reservations.find { |res| res.guest_contact == guest_contact }

  if existing_reservation
    puts "Warning: A reservation already exists for this phone number (#{guest_contact})."
    puts "Guest: #{existing_reservation.guest_name}, Room: #{existing_reservation.room_number}, Dates: #{existing_reservation.start_date} to #{existing_reservation.end_date}"
    return
  end

  # Check if guest already exists
  existing_guest = reservations.find { |res| res.guest_name == guest_name && res.guest_contact == guest_contact }
  if existing_guest
    reservations.reject! { |res| res.guest_name == guest_name && res.guest_contact == guest_contact }
    puts "Previous reservation for this guest has been deleted."
  end

  puts "Enter Room Number:"
  room_number = gets.chomp
  unless room_exists?(room_number, rooms)
    puts "Invalid room number. Please enter a valid room number from the list."
    return
  end

  # Date input validation
  start_date = nil
  until start_date
    puts "Enter Start Date (YYYY-MM-DD):"
    input_start_date = gets.chomp
    begin
      start_date = Date.parse(input_start_date)
      if start_date < Date.today
        puts "Start date cannot be in the past. Please enter a valid future date."
        start_date = nil
      end
    rescue ArgumentError
      puts "Invalid date format. Please use YYYY-MM-DD format."
    end
  end

  end_date = nil
  until end_date
    puts "Enter End Date (YYYY-MM-DD):"
    input_end_date = gets.chomp
    begin
      end_date = Date.parse(input_end_date)
      if end_date <= start_date
        puts "End date must be after the start date. Please enter a valid end date."
        end_date = nil
      end
    rescue ArgumentError
      puts "Invalid date format. Please use YYYY-MM-DD format."
    end
  end

  # Check if room is available
  if reservations.any? { |res| res.room_number == room_number && !(end_date < Date.parse(res.start_date) || start_date > Date.parse(res.end_date)) }
    puts "Room is already booked for the selected dates."
  else
    reservations << Reservation.new(guest_name, guest_contact, room_number, start_date.to_s, end_date.to_s)
    puts "Reservation successful!"
  end
end



def cancel_reservation(reservations)
  puts "Enter Guest Contact to Cancel Reservation:"
  guest_contact = gets.chomp

  reservations.reject! { |res| res.guest_contact == guest_contact }
  puts "Reservation cancelled successfully!"
end

# Room Availability Checker

def check_room_availability(rooms, reservations)
  puts "Enter Start Date (YYYY-MM-DD):"
  start_date = gets.chomp
  puts "Enter End Date (YYYY-MM-DD):"
  end_date = gets.chomp

  available_rooms = rooms.select do |room|
    reservations.none? do |res|
      res.room_number == room.number && !(end_date < res.start_date || start_date > res.end_date)
    end
  end

  if available_rooms.empty?
    puts "\nNo rooms available for the selected dates."
  else
    puts "\nAvailable Rooms for the selected dates:"
    available_rooms.each do |room|
      puts "Room Number: #{room.number}, Type: #{room.type}"
    end
  end
end

# Login Function

def login
  username = "admin"
  password = "admin"

  puts "\n--- Admin Login ---"
  print "Enter Username: "
  input_username = gets.chomp
  print "Enter Password: "
  input_password = gets.chomp

  if input_username == username && input_password == password
    puts "\nLogin Successful!\n"
    true
  else
    puts "\nInvalid Username or Password. Access Denied.\n"
    false
  end
end

# Menu and Main Program

def display_menu(rooms, reservations, guests)
  finished = false
  while !finished
    puts "\n--- Hotel Management System ---"
    puts "1. Display Rooms"
    puts "2. Display Reservations"
    puts "3. Book a Room"
    puts "4. Cancel a Reservation"
    puts "5. Check Room Availability"
    puts "6. Exit"
    choice = gets.chomp.to_i

    case choice
    when 1
      display_rooms(rooms)
    when 2
      display_reservations(reservations, guests)
    when 3
      book_room(rooms, reservations, guests)
    when 4
      cancel_reservation(reservations)
    when 5
      check_room_availability(rooms, reservations)
    when 6
      write_reservations(reservations)
      finished = true
    else
      puts "Invalid choice. Please try again."
    end
  end
end

def main
  if login
    guests = []
    rooms = read_rooms
    reservations = read_reservations(guests)
    display_menu(rooms, reservations, guests)
  else
    puts "Exiting Program."
  end
end

main

