# Packs the ASCII art using a naiive integer-based arithmetic compression
# with equal size buckets (so that the unpacker is less code).
# See #unzip and progress.rb for the unpacking code.
#
# Originally written by Torsten Becker <torsten.becker@gmail.com> in 2012.


HD = false

if HD
  msg = "\
 _____ __ __ ____ __ __ |  |__ _____ 
|  -__|  |  |   _|  |  ||    -|  _  |
|_____|_____|__| |_____||__|__|_____|
"
else
  msg = "\
 ___ _ _ ___ _ _| |_ ___ 
| -_| | |  _| | | -_| - |
|___|___|_| |___|_|_|___|
"
end


# Unpacker for inters
def unzip(a, b, c, perm, top, bottom)
  [a,b,c].map{|f|
    t,b,out=top,bottom,''
    25.times{
      s=t-b
      i=((f-b)*4)/s
      b=b+s/4*i
      t=b+s/4
      out+=perm[i].chr
    }
    out + "\n"
  }.join
end


def zipped_lines msg, perm, initial_top, initial_bottom
  msg.lines.map do |line|
    i = 0
    
    top = initial_top
    bottom = initial_bottom
    
    line.chars.each do |chr|
      scale = (top - bottom)
      # puts "i: #{i}, chr: '#{chr}', scale: #{scale}"
      i += 1
      case chr
      when perm[0].chr
        # bottom = bottom + scale * 0.0
        top = bottom + scale / 4
      when perm[1].chr
        bottom = bottom + scale / 4
        top = bottom + scale / 4
      when perm[2].chr
        bottom = bottom + scale / 2
        top = bottom + scale / 4
      when perm[3].chr
        bottom = bottom + (scale * 3) / 4
        # top = bottom + scale * 0.25
      end
      # puts "%.80f"%top, "%.80f"%bottom, ""
      # puts bottom + 0.5 * (top - bottom)
      # puts "(#{bottom}, #{top}) = #{(bottom + ((top - bottom) / 2))}"
    end
    
    bottom + ((top - bottom) / 2)
  end
end


results = []
shortest = [99]


'_ |-'.chars.to_a.permutation.map{|x|x.join}.each do |perm|
  (0..9).each do |bottom|
    (23..39).each do |power|
      top = 4**power
      
      params = zipped_lines(msg, perm, top, bottom)
      stringified = params.inspect
      
      begin
        a, b, c = eval(stringified)
        result = unzip(a, b, c, perm, top, bottom)
        
        if result == msg
          score = stringified.length
          
          result_tuple = [score, stringified, perm, power, bottom]
          results << result_tuple
          
          if score <= shortest[0]
            shortest = result_tuple
            puts shortest.inspect
          end
        end
  
      rescue NoMethodError, FloatDomainError, ZeroDivisionError
      end
      
    end
  end
end

puts "---"


puts( (results.sort do |a, b|
  a[0] <=> b[0]
end)[0..10].map{|x|x.inspect})
