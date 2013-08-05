guard 'sprockets', :minify => false, :destination => 'static/js', :asset_paths => ['source/js'] do
  watch(%r{source/js/.+\.*}) { |m| "source/js/all.js" }
end

guard 'compass', :configuration_file => 'source/compass.rb' do
  watch(/^source\/css\/(.*)\.scss/)
end