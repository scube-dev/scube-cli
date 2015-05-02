module Scube
  module CLI
    module Commands
      class Import
        def initialize args
          @client = Client.new
          @stats  = {
            created: {
              count:  0,
              size:   0
            },
            ignored: {
              count:  0,
              size:   0
            }
          }
        end

        def run
          ARGF.each do |l|
            path    = Pathname.new(l.chomp)
            digest  = Digest::SHA256.file(path)

            if @client.sound? digest
              increment_stat :ignored, path
            else
              @client.sound_post path
              increment_stat :created, path
            end
          end

          puts "#{stats_report_text} in X seconds"
        end


        private

        def increment_stat stat, path
          @stats[stat][:count]  += 1
          @stats[stat][:size]   += path.size
        end

        def stats_report_text
          @stats.keys.each_with_object [] do |e, m|
            m << "#{@stats[e][:count]} #{e} (#{@stats[e][:size]} bytes)"
          end.join ', '
        end
      end
    end
  end
end
