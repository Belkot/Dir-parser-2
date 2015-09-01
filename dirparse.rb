class Dirparse

  def initialize(dir='.')
    @dir = dir
  end

  def to_s
    outstr = ''
    if Dir.exist? @dir
      Dir.entries(@dir)
        .grep(/^U\d+_(Account|Activity|Position|Security)_\d{8}.txt/)
          .group_by { |id| id[/^U\d+/] }
            .inject({}) { |h, (k, v)| h[k] = v.group_by { |date| date[/\d{8}/] }; h }
              .sort { |x,y| y<=>x }.each do |id|
                outstr << id.first << "\n"
                id.last.sort.each do |date|
                  outstr << "  " << "#{date.first[0..3]}-#{date.first[4..5]}-#{date.first[6..8]}" << "\n"
                  date.last.sort.each { |type| outstr << "    " << "#{type[/(Account|Activity|Position|Security)/].downcase}" << "\n" }
                end
              end
    end
    outstr.chomp
  end

end
