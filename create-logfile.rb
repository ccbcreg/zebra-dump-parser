require "rubygems"

def collectors
  ["00","01","03","04","05","06","07","10","11","12","13","14","15"]
end

def download
  system "rm -f latest-bview* zebra.oix"
  collectors.each do |collector|
    system "wget http://data.ris.ripe.net/rrc#{collector}/latest-bview.gz"
    system "gunzip latest-bview.gz && mv latest-bview latest-bview#{collector}"
  end
end

def create_log
  download
  system "echo \"\" > zebra.oix"
  collectors.each do |collector|
    puts "Processing collector bview file: latest-bview#{collector}"
    system "cat latest-bview#{collector} | ./zebra-dump-parser.pl >> zebra.oix"
  end
  system "sort zebra.oix | uniq > zebra.oix.uniq"
end

create_log