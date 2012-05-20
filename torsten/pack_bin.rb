# Packs the ASCII art into a hex or base-36 number.
# See progress.rb for the unpacking code.
#
# Originally written by Torsten Becker <torsten.becker@gmail.com> in 2012.


HD = false

if HD
  msg = "\
.-----.--.--.----.--.--.|  |--.-----.
|  -__|  |  |   _|  |  ||    <|  _  |
|_____|_____|__| |_____||__|__|_____|
"
  chars = " -_|.<\n"
  bin = ['000', '001', '010', '011', '100', '101', '110', '111']

else
  msg = "\
 _____ __ __ ____ __ __ |  |__ _____ 
|  -__|  |  |   _|  |  ||    -|  _  |
|_____|_____|__| |_____||__|__|_____|
"
  chars = " -_|"
  bin = ['00', '01', '10', '11']
end

best = [99]

chars.chars.to_a.permutation.each do |perm|
  num = ''
  msg.chars.reverse_each do |chr|
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
      when perm[5]
        num += bin[5]
      when perm[6]
        num += bin[6]
      end
  end
  n = num.to_i(2)

  # ber = [n].pack'w'
  # puts "#{ber.length} 0x#{n.to_s 16} #{perm.join.inspect}"
  # puts "#{ber} #{perm.join.inspect} #{n}"
  
  # hex = n.to_s 16
  # puts "#{hex.length} 0x#{hex} #{perm.join.inspect}"
  
  hex = n.to_s 36
  
  if hex.length <= best[0]
    best = [hex.length, hex, perm.join]
    puts best.inspect
  end
  
end
