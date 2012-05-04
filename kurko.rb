"311311113\n1  1111111111\n3112 112 11\n1  1111111111\n33113113".split(//).each{|x|(x.to_i>0)?(x.to_i.times{putc "#"};putc " "):(print x)}
