# put your code here:
class Track
attr_accessor :name, :location
def initialize(name,location)
@name = name
@location = location
end
end

def read_track(a_file)
name = a_file.gets.chomp
location = a_file.gets.chomp
Track.new(name, location)
end

def print_track(track)
puts "Track name: #{track.name}"
puts "Track location: #{track.location}"
end

def main()
a_file = File.new("track.txt", "r") 
read_track(a_file)
print_track(track)
end

main() if __FILE__ == $0 # leave this 
