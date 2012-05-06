s="\u{2764} "
l=" #{s*5}EURUKO #{s*5}\a"
a=lambda{12.times{print l+"\b"*27;sleep 0.2}}
5.times{a.call;puts " "*27+"\n"}
puts l #eurukogolf
