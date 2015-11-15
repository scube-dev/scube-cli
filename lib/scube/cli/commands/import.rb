require 'id3tag'

module Scube
  module CLI
    module Commands
      class Import < Base
        def setup *_args
          @stats = {
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
          Signal.trap('INFO') { puts stats_report_text }
          time = Benchmark.realtime do
            # FIXME: refactor this, we should not access ARGF directly
            ARGF.each { |l| import_file Pathname.new(l.chomp) }
          end
          puts "#{stats_report_text} in #{time.to_i} seconds"
        end

        def import_file path
          digest = Digest::SHA256.file(path)
          increment_stat :ignored, path and return if client.sound? digest
          puts client.track_post(path, track_attributes(path)).body
          increment_stat :created, path
        end

      private

        def track_attributes path
          attributes = { name: path.basename.to_s }

          ID3Tag.read(File.open(path, 'rb')) do |tag|
            attributes.merge!(
              name:     tag.title,
              authors:  [{ name: tag.artist }],
              release:  {
                name:         tag.album,
                year:         tag.year,
                track_number: tag.track_nr
              }
            )
          end

          attributes
        end

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
