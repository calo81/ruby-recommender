Gem::Specification.new do |s|
  s.name = "ruby-recommender"
  s.summary = "Recommendation Engine for Ruby based loosely in Apache Mahout"
  s.description = File.read(File.join(File.dirname(__FILE__), 'README'))
  s.version = "0.0.1"
  s.author = "Carlo Scarioni"
  s.email = "carlo.scarioni@gmail.com"
  s.homepage = "http://cscarioni.blogspot.com"
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>=1.9'
  s.add_dependency('rspec')
  s.files = Dir['**/**']
  s.test_files = Dir["spec/*spec.rb"]
  s.has_rdoc = false
end