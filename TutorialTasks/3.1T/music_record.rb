require './input_functions'

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

Genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
  attr_accessor :title, :artist, :genre
end

# This function Reads in and returns a single album from the given file, with all its tracks.
# ...for now however, take input from the terminal to enter just the album information.
# Complete the missing lines of code and change the functionality so that the hardcoded 
# values are not used.

def read_album()

  # You could use get_integer_range below to get a genre.
  # You only the need validation if reading from the terminal
  # (i.e when using a file later, you can assume the data in
  # the file is correct)

  # insert lines here - use read_integer_in_range to get a genre
  puts ('Enter Album')
  album_title = read_string("Enter album name:")
  album_artist = read_string("Enter artist name:")
  album_genre = Genre::POP
  album = Album.new()
  album.title = album_title
  album.artist = album_artist
  album.genre = album_genre
  album.genre = read_integer_in_range("Enter Genre between 1 - 4: ", 1, 4)

  return album
end

# Takes a single album and prints it to the terminal 
# complete the missing lines:

def print_album(album)
  puts('Album information is: ')
	puts album.title
  puts album.artist
	puts('Genre is ' + album.genre.to_s)
  puts Genre_names[album.genre] # we will cover this in Week 6!
end

# Reads in an Album then prints it to the terminal

def main()
	album = read_album()
	print_album(album)
end

main if __FILE__ ==$0
