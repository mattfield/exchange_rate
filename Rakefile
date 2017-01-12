require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

OUTPUT_FILE='spec/fixtures/example.xml'

desc "Fetch the latest feed XML (if doesn't exist)"
file OUTPUT_FILE do
  res = Net::HTTP.get(URI.parse "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml")
  File.open(OUTPUT_FILE, 'w+') do |f|
    f.write(res)
  end
end

task :fetch_feed => [OUTPUT_FILE]
