require './input_functions'

# It is suggested that you put together code from your 
# previous tasks to start this. eg:
# 8.1T Read Album with Tracks

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
  attr_accessor :artist, :title, :label, :genre, :tracks

  def initialize(artist, title, label, genre, tracks)
    @artist = artist
    @title = title
    @label = label
    @genre = genre
    @tracks = tracks
  end
end

class Track
  attr_accessor :name, :location, :duration

  def initialize(name, location, duration)
    @name = name
    @location = location
    @duration = duration
  end
end

def read_track(a_file)
  name = a_file.gets.chomp
  location = a_file.gets.chomp
  duration = a_file.gets.chomp
  Track.new(name, location, duration)
end

def read_tracks(a_file, track_count)
  tracks = []
  while track_count > 0
    tracks << read_track(a_file)
    track_count -= 1
  end
  tracks
end

def read_album(a_file)
  artist = a_file.gets.chomp
  title = a_file.gets.chomp
  label = a_file.gets.chomp
  genre = a_file.gets.chomp
  track_count = a_file.gets.chomp.to_i
  tracks = track_count > 0 ? read_tracks(a_file, track_count) : []
  Album.new(artist, title, label, genre, tracks)
end

def read_albums
  filename = read_string("Enter filename: ")
  
  begin
    a_file = File.open(filename, "r")
  rescue Errno::ENOENT
    puts "File not found. Please check the filename and try again."
    return []
  end
  
  a_file = File.open(filename, "r")
  album_count = a_file.gets.chomp.to_i

  albums = []
  while album_count > 0
    albums << read_album(a_file)
    album_count -= 1
  end

  a_file.close
  puts "File read successful"
  albums
end

def display_albums(albums)
  if albums.nil? || albums.empty?
    puts "You need to load albums first"
    return
  end

  puts "\nHow do you want to display?\n1. Display all albums\n2. Display by genre"
  choice = read_integer_in_range("Please enter your choice:", 1, 2)

  case choice
  when 1 then display_all_albums(albums)
  when 2 then display_genre(albums)
  end
end

def display_all_albums(albums)
  i = 0
  while i < albums.length
    puts "\nAlbum ID: #{i + 1}"
    display_album(albums[i])
    i += 1
  end
end

def display_album(album)
  puts "Artist: #{album.artist}"
  puts "Title: #{album.title}"
  puts "Label: #{album.label}"
  puts "Genre: #{album.genre}"
  display_tracks(album.tracks)
end

def display_tracks(tracks)
  if tracks.empty?
    puts "No tracks available in this album."
    return
  end

  puts "There are #{tracks.length} tracks in the album:"
  i = 0
  while i < tracks.length
    puts "Track #{i + 1}:"
    display_track(tracks[i])
    i += 1
  end
end

def display_track(track)
  puts "Name: #{track.name}"
  puts "Location: #{track.location}"
  puts "Duration: #{track.duration}"
end

def display_genre(albums)
  puts "\nSelect genre\n1 - Pop\n2 - Classic\n3 - Jazz\n4 - Rock"
  genre_choice = read_integer_in_range("\nPlease enter your choice:", 1, 4).to_s
  display_albums_by_genre(genre_choice, albums)
end

def display_albums_by_genre(genre, albums)
  i = 0
  while i < albums.length
    if albums[i].genre == genre
      puts "\nAlbum ID: #{i + 1}"
      display_album(albums[i])
    end
    i += 1
  end
end

def play_album(albums)
  if albums.nil? || albums.empty?
    puts "You need to load albums first\n"
    return
  end

  album_id = read_integer_in_range("\nAlbum ID: ", 1, albums.length) - 1
  tracks = albums[album_id].tracks

  if tracks.empty?
    puts "There is no track to play\n"
    return
  end

  puts "There are #{tracks.length} tracks:"
  i = 0
  while i < tracks.length
    puts "#{i + 1}. #{tracks[i].name}"
    i += 1
  end

  choice = read_integer_in_range("\nEnter track you want to play:", 1, tracks.length) - 1
  puts "\nPlaying track #{tracks[choice].name.chomp} from album #{albums[album_id].title}"
  sleep 3
end

def display_menu(albums)
  finished = false
  while !finished
    puts "\nMain Menu:\n1. Read in Albums\n2. Display Albums\n3. Select an Album to play\n5. Exit the Application"
    case read_integer_in_range("Please enter your choice: ", 1, 5)
    when 1 then albums = read_albums
    when 2 then display_albums(albums)
    when 3 then play_album(albums)
    when 5 then finished = true
    else
      puts "Invalid choice"
    end
  end
end

def main
  albums = []
  display_menu(albums)
end

main

