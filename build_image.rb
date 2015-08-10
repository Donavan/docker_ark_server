require 'erb'
require 'net/http'
require 'uri'



begin
  current_version = IO.read('.ark_version')
rescue
  current_version = '0'
end

ark_version = Net::HTTP.get(URI.parse('http://arkdedicated.com/version'))
#ark_version = IO.read('http://arkdedicated.com/version')
#ark_version = '190.1'


if ark_version != current_version
  puts "Building Dockerfile for version #{ark_version}"
  dockerfile_contents = IO.read('Dockerfile.erb')
  dockerfile_template = ERB.new(dockerfile_contents)


  dockerfile_output = dockerfile_template.result

  File.open('Dockerfile', 'w') {|f| f.write(dockerfile_output) }
  File.open('.ark_version', 'w') {|f| f.write(ark_version) }
  puts 'Starting docker build'
  system 'docker build -t donavan/arktest .'
else
  puts "Dockerfile already at correct version (#{ark_version})"
end

