require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF191970)
BOTTOM_COLOR = Gosu::Color.new(0xFF0F0F4D)
SCREEN_WIDTH = 600
SCREEN_HEIGHT = 800
LOCATION = 400

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
	attr_accessor :bmp

	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end

# Put your record definitions here
class Album
	attr_accessor :title, :artist, :artwork, :tracks

	def initialize (title, artist, artwork, tracks)
		@title = title
		@artist = artist
		@artwork = artwork
		@tracks = tracks
	end
end

class Size
	attr_accessor :leftX, :topY, :rightX, :bottomY

	def initialize(leftX, topY, rightX, bottomY)
		@leftX = leftX
		@topY = topY
		@rightX = rightX
		@bottomY = bottomY
	end
end
class Track
	attr_accessor :name, :location, :size

	def initialize(name, location, size)
		@name = name
		@location = location
		@size = size
	end
end

class MusicPlayerMain < Gosu::Window

	def initialize
	    super 600, 800
	    self.caption = "Music Player"
			@track_font = Gosu::Font.new(25)
	    @album = read_album()
			@track_playing = 0
		playTrack(@track_playing, @album)
	end

  # Put in your code here to load albums and tracks
	def read_track(a_file, idx)
		track_name = a_file.gets.chomp
		track_location = a_file.gets.chomp

		leftX = LOCATION
		topY = 100 * idx + 50
		rightX = leftX + @track_font.text_width(track_name)
		bottomY = topY + @track_font.height()
		size = Size.new(leftX, topY, rightX, bottomY)

		track = Track.new(track_name, track_location, size)
		return track
	end

	def read_tracks(a_file)
		count = a_file.gets.chomp.to_i
		tracks = []
		# --- Read each track and add it into the arry ---
		i = 0
		while i < count
			track = read_track(a_file, i)
			tracks << track
			i += 1
		end
		# --- Return the tracks array ---
		return tracks
	end

	def read_album()
		a_file = File.new("albums.txt", "r")
		title = a_file.gets.chomp
		artist = a_file.gets.chomp
		artwork = ArtWork.new(a_file.gets.chomp)
		tracks = read_tracks(a_file)
		album = Album.new(title, artist, artwork.bmp, tracks)
		a_file.close()
		return album
	end


  # Draws the artwork on the screen for all the albums

	def display_now_playing
		current_track = @album.tracks[@track_playing].name
		now_playing_text = "Now playing - #{current_track}"
		@track_font.draw_text(now_playing_text, 50, 300, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
	end

  def draw_albums (albums)
    # complete this code
		@album.artwork.draw(50, 50 , z = ZOrder::PLAYER, 0.8, 0.8)
		@album.tracks.each do |track, index|
			display_track(track.name, track.size.topY, index == @track_playing)
		end
  end

  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false

  def area_clicked(leftX, topY, rightX, bottomY)
     # complete this code
		 if mouse_x > leftX && mouse_x < rightX && mouse_y > topY && mouse_y < bottomY
			return true
		end
		return false
  end


  # Takes a String title and an Integer ypos
  # You may want to use the following:
  def display_track(title, ypos, is_playing = false)
		@track_font.draw_text(title, LOCATION, ypos, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)  
	end


  # Takes a track index and an Album and plays the Track from the Album

  def playTrack(track, album)
  	 # complete the missing code
  			@song = Gosu::Song.new(album.tracks[track].location)
  			@song.play(false)
    # Uncomment the following and indent correctly:
  	#	end
  	# end
  end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background
		draw_quad(0,0, TOP_COLOR, 0, SCREEN_HEIGHT, TOP_COLOR, SCREEN_WIDTH, 0, BOTTOM_COLOR, SCREEN_WIDTH, SCREEN_HEIGHT, BOTTOM_COLOR, z = ZOrder::BACKGROUND)
	end

# Not used? Everything depends on mouse actions.

	def update
		if not @song.playing?
			@track_playing = (@track_playing + 1) % @album.tracks.length()
			playTrack(@track_playing, @album)
		end
	end

 # Draws the album images and the track list for the selected album

	def draw
		# Complete the missing code
		draw_background
		draw_albums(@album)
		display_now_playing
	end

 	def needs_cursor?; true; end

	# If the button area (rectangle) has been clicked on change the background color
	# also store the mouse_x and mouse_y attributes that we 'inherit' from Gosu
	# you will learn about inheritance in the OOP unit - for now just accept that
	# these are available and filled with the latest x and y locations of the mouse click.

	def button_down(id)
		case id
	    when Gosu::MsLeft
	    	# What should happen here?
				for i in 0..@album.tracks.length() - 1
		    	if area_clicked(@album.tracks[i].size.leftX, @album.tracks[i].size.topY, @album.tracks[i].size.rightX, @album.tracks[i].size.bottomY)
		    		playTrack(i, @album)
		    		@track_playing = i
		    		break
		    	end
		    end
	    end
	end

end

# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0