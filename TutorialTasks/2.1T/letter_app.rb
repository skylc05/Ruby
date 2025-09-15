 
# put your code here - make sure you use the input_functions to read strings and integers

# Include the functions from the input_functions.rb file
require_relative 'input_functions'

# Gather address label details from the user
# This includes title, first name, last name, house number, street name, suburb, and postcode
def get_label
  title = read_string("Please enter your title: (Mr, Mrs, Ms, Miss, Dr)")
  first_name = read_string("Please enter your first name:")
  last_name = read_string("Please enter your last name:")
  house_number = read_string("Please enter the house or unit number:")
  street_name = read_string("Please enter the street name:")
  suburb = read_string("Please enter the suburb:")
  postcode = read_integer_in_range("Please enter a postcode (0000 - 9999)", 0, 9999)

 # Construct the label string
  label = "#{title} #{first_name} #{last_name}\n#{house_number} #{street_name}\n#{suburb} #{postcode}"
  label
end


# Gather message details from the user
# This includes a subject line and message content
def get_message
  subject = read_string("Please enter your message subject line:")
  content = read_string("Please enter your message content:")

# Construct the message string
  message = "RE: #{subject}\n\n#{content}"
  return message
end

# Print the letter by displaying the label and message
def print_letter(label, message)
  puts label
  puts message
end

# Main program logic
# Gets the label and message from the user, then prints the complete letter
def main
  label = get_label
  message = get_message
  print_letter(label, message)
end

# Call the main function if this file is run directly
main if __FILE__ == $0

