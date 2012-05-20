# Packs the ASCII art using naiive float-based arithmetic compression
# with equal size buckets (so that the unpacker is less code).
# See #unzip and progress.rb for the unpacking code.
#
# Originally written by Torsten Becker <torsten.becker@gmail.com> in 2012.


msg="\
 ___ _ _ ___ _ _| |_ ___ 
| -_| | |  _| | | -_| - |
|___|___|_| |___|_|_|___|
"


# Unpacking routine (floats)
# a,b,c: float
# perm: string
# top: int
# bottom: float
def unzip(a, b, c, perm, top, bottom)
  [a,b,c].map{|f|
    t,b,out=top,bottom,''
    25.times{
      s=t-b
      i=(f-b)*4/s
      b+=s/4*i.to_i
      t=b+s/4
      out += perm[i].chr
    }
    out + "\n"
  }.join
end

# puts( unzip(4.01666285319154,9.7874952316723,8.03138113220488,16,0.0,4) == msg)


def zipped_lines msg, perm, initial_top, initial_bottom
  msg.lines.map do |line|
    i = 0
    
    top = initial_top.to_f
    bottom = initial_bottom.to_f
    
    line.chars.each do |chr|
      scale = (top - bottom)
      # puts "i: #{i}, chr: '#{chr}', scale: #{scale}"
      i += 1
      case chr
      when perm[0].chr
        # bottom = bottom + scale * 0.0
        top = bottom + scale * 0.25
      when perm[1].chr
        bottom = bottom + scale * 0.25
        top = bottom + scale * 0.25
      when perm[2].chr
        bottom = bottom + scale * 0.5
        top = bottom + scale * 0.25
      when perm[3].chr
        bottom = bottom + scale * 0.75
        # top = bottom + scale * 0.25
      end
      # puts "%.80f"%top, "%.80f"%bottom, ""
      # puts bottom + 0.5 * (top - bottom)
      # puts "(#{bottom}, #{top}) = #{(bottom + 0.5 * (top - bottom))}"
    end
    
    bottom + 0.5 * (top - bottom)
  end
end


def each_rounding num
  yield num
  yield num[0..-2]
  i = num[-2].chr.to_i
  if i != 9
    yield num[0..-3] + (i + 1).to_s
  elsif i != 0
    yield num[0..-3] + (i - 1).to_s
  else
    yield num[0..-3]
  end
end


def each_cropping(stringified)
  a, b, c = stringified.split(', ')
  a = a[1..-1]
  c = c[0..-2]

  each_rounding(a) do |var_a|
    each_rounding(b) do |var_b|
      each_rounding(c) do |var_c|
        yield "[#{var_a}, #{var_b}, #{var_c}]"
      end
    end
  end
end


results = []
shortest = [52]

permutations = '_ |-'.chars.to_a.permutation.map{|x|x.join}

((0.0)..(9.9)).step(0.1) do |bottom|
  ((bottom.floor+1)..30).each do |top|
    permutations.each do |perm|
      # puts "top: #{top}, bottom: #{bottom}"
    
      params = zipped_lines(msg, perm, top, bottom)
      stringified = params.inspect
      
      each_cropping(stringified) do |stringi|
        begin
          a, b, c = eval(stringi)
      
          result = unzip(a, b, c, perm, top, bottom)
          if result == msg
            score = stringi.length + top.to_s.length
            
            result_tuple = [score, stringi, perm, top, bottom]
            results << result_tuple
            
            if score <= shortest[0]
              shortest = result_tuple
              puts shortest.inspect
            end
          end
    
        rescue NoMethodError, FloatDomainError
        end
      end
    end
  end
  
  puts bottom
end

puts "---"

# Show top 10 results
puts( (results.sort do |a, b|
  (a[0]) <=> (b[0])
end)[0..10].map{|x|x.inspect})
