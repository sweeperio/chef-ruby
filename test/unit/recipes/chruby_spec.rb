#
# Cookbook Name:: ruby
# Spec:: chruby
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

describe "swpr_ruby::chruby" do
  cached(:chef_run) do
    runner = ChefSpec::SoloRunner.new do |node|
      node.set["swpr_ruby"]["chruby"]["auto_switch"] = true
      node.set["swpr_ruby"]["chruby"]["version"]     = "0.3.9"
    end

    runner.converge(described_recipe)
  end

  it "converges successfully" do
    expect { chef_run }.to_not raise_error
  end

  it "arks chruby and installs with make" do
    version = chef_run.node.attr!("swpr_ruby", "chruby", "version")

    expect(chef_run).to install_with_make_ark("chruby").with(
      url: "https://github.com/postmodern/chruby/archive/v#{version}.tar.gz",
      version: version
    )
  end

  it "ensures /etc/profile.d exists" do
    expect(chef_run).to create_directory("/etc/profile.d").with(recursive: true)
  end

  it "generates the init script in /etc/profile.d" do
    version        = chef_run.node.attr!("swpr_ruby", "chruby", "version")
    system_version = chef_run.node.attr!("swpr_ruby", "system_version")
    auto_switch    = chef_run.node.attr!("swpr_ruby", "chruby", "auto_switch")

    expect(chef_run).to create_template("/etc/profile.d/chruby.sh").with(
      mode: 00644,
      variables: { default: system_version, switch: auto_switch, version: version }
    )
  end
end
