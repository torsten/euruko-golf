# coding: utf-8
# see https://twitter.com/#!/konstantinhaase/status/198379625943015424
x=->c,v{(v==v.to_s)?print(v*(c%4)):x[x[x[c,"\u{1f49a} "],"  "],"\n"];c>>2};"񙖧񊒭𫖳𫒩򑤥񙖧񫢭𫖱𫒩򑤥񊕫󚔫".codepoints{|c|4.times{x[c%32,c=c>>5]}}
