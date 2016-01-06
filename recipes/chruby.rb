#
# Cookbook Name:: ruby
# Recipe:: chruby
#
# The MIT License (MIT)
#
# Copyright (c) 2016 sweeper.io
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

version        = node.attr!("ruby", "chruby", "version")
auto_switch    = node.attr!("ruby", "chruby", "auto_switch")
system_version = node.attr!("ruby", "system_version")

template_vars = {
  default: system_version,
  switch: auto_switch,
  version: version
}

ark "chruby" do
  url "https://github.com/postmodern/chruby/archive/v#{version}.tar.gz"
  version version
  action :install_with_make
end

directory("/etc/profile.d") { recursive true }

template "/etc/profile.d/chruby.sh" do
  mode 00644
  variables template_vars
end
