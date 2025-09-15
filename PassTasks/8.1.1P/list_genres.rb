
# put the genre names array here:
$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

def main()
  index = 1
  while index < $genre_names.length
    puts "#{index} #{$genre_names[index]}"
    index += 1
  end

end

main()
