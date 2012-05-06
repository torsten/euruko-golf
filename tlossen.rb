puts %w[0000080 64ad2a6 f4b12c9 84a12a9 73a0e96].map{|x|x.to_i(16).to_s(2).rjust(28,'0')}.join("\n").gsub('0','  ').gsub('1','_|')
