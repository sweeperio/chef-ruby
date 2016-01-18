#
# Cookbook Name:: ruby
# Spec:: default
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

describe "swpr_ruby::default" do
  def each_version
    chef_run.node.attr!("swpr_ruby", "versions").each do |version|
      yield(version)
    end
  end

  def configure_node(node)
    node.set["swpr_ruby"]["sources"] = {
      "2.2.2" => "http://server.com/ruby-2.2.2.tar.bz2",
      "2.2.3" => "http://server.com/ruby-2.2.3.tar.bz2"
    }

    node.set["swpr_ruby"]["versions"]       = %w(2.2.2 2.2.3)
    node.set["swpr_ruby"]["system_version"] = "2.2.3"
  end

  cached(:chef_run) do
    runner = ChefSpec::SoloRunner.new { |node| configure_node(node) }
    runner.converge(described_recipe)
  end

  it "includes base recipes" do
    expect(chef_run).to include_recipe("apt")
  end

  it "installs apt packages" do
    chef_run.node.attr!("swpr_ruby", "packages").each do |package|
      expect(chef_run).to install_package(package)
    end
  end

  it "installs all the rubies" do
    each_version do |version|
      expect(chef_run).to install_ruby_version(version).with(
        symlink: version == chef_run.node.attr!("swpr_ruby", "system_version")
      )
    end
  end

  context "when stepping into the resource" do
    cached(:chef_run) do
      runner = ChefSpec::SoloRunner.new(step_into: %w(swpr_ruby_version)) do |node|
        configure_node(node)
      end

      runner.converge(described_recipe)
    end

    it "ensures install dir exists" do
      expect(chef_run).to create_directory(chef_run.node["swpr_ruby"]["install_dir"]).with(recursive: true)
    end

    it "installs each version of ruby" do
      each_version do |version|
        expect(chef_run).to put_ark("ruby-#{version}").with(
          action: %i(put),
          name: version,
          version: version,
          path: "/opt/rubies",
          url: chef_run.node["swpr_ruby"]["sources"][version]
        )
      end
    end

    it "should notify the symlink resource" do
      each_version do |version|
        resource = chef_run.find_resource(:ark, "ruby-#{version}")
        expect(resource).to notify("execute[symlink ruby #{version}]").to(:run).immediately

        resource = chef_run.find_resource(:execute, "symlink ruby #{version}")
        expect(resource).to notify("execute[symlink shared libs #{version}]").to(:run).immediately
      end
    end
  end
end
