# rubocop:disable Style/SingleSpaceBeforeFirstArg
name             "ruby"
maintainer       "sweeper.io"
maintainer_email "developers@sweeper.io"
license          "mit"
description      "Installs/Configures ruby"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "0.1.0"
# rubocop:enable Style/SingleSpaceBeforeFirstArg

supports "ubuntu"

depends "apt",   "~> 2.0"
depends "ark",   "~> 0.0"
depends "core",  "~> 0.0"

chef_version ">= 12.5" if respond_to?(:chef_version)
source_url "https://github.com/sweeperio/chef-ruby" if respond_to?(:source_url)
issues_url "https://github.com/sweeperio/chef-ruby/issues" if respond_to?(:issues_url)
