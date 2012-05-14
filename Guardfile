# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2, :cli => "--color --require ./spec/golf_formatter.rb --format GolfFormatter" do
  watch(%r{^spec/.+_spec\.rb$}) { "spec" }
  watch('lib/golf.rb') { "spec" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch('spec/golf_formatter.rb')  { "spec" }
end
