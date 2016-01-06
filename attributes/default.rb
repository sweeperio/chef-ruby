def travis_ruby(version)
  "http://rubies.travis-ci.org/ubuntu/14.04/x86_64/ruby-#{version}.tar.bz2"
end

default["ruby"]["install_dir"]    = "/opt/rubies"
default["ruby"]["versions"]       = %w(2.2.3)
default["ruby"]["sources"]        = {}
default["ruby"]["system_version"] = "2.2.3"

default["ruby"]["packages"] = %w(zlib1g-dev libssl-dev libreadline-dev libyaml-dev libcurl4-openssl-dev libffi-dev)

%w(
  2.1.6
  2.1.7
  2.1.8
  2.2.0
  2.2.1
  2.2.2
  2.2.3
  2.3.0
).each do |version|
  default["ruby"]["sources"][version] = travis_ruby(version)
end
