# Packs each line of the ASCII art into a numer.
# See progress.rb for the unpacking code.
#
# Originally written by Torsten Becker <torsten.becker@gmail.com> in 2012.


msg = "\
 _____ __ __ ____ __ __ |  |__ _____ 
|  -__|  |  |   _|  |  ||    -|  _  |
|_____|_____|__| |_____||__|__|_____|
"
chars = " -_|"

bin = ['00', '01', '10', '11']

chars.chars.to_a.permutation.each do |perm|
  triplet = []
  
  msg.lines.each do |line|
    num = ''
    
    line.chars.reverse_each do |chr|
      case chr
      when perm[0]
        num += bin[0]
      when perm[1]
        num += bin[1]
      when perm[2]
        num += bin[2]
      when perm[3]
        num += bin[3]
      when perm[4]
        num += bin[4]
      end
    end

    n = num.to_i(2)
    hex = "0x#{n.to_s(16)}"

    if hex.length < n.to_s.length
      triplet << hex
    else
      triplet << n.to_s
    end
  end

  puts "#{triplet.inspect.length} #{triplet.inspect} #{perm.join.inspect}"

end
