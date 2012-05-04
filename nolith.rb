require 'open-uri'
open('http://pastebin.com/raw.php?i=b31RBDqG'){|f| puts f.read}