require "spec_helper"

describe "ruby" do
  describe file("/opt/rubies/2.2.3/bin/ruby") do
    it { should exist }
    it { should be_file }
  end

  describe file("/opt/rubies/2.2.3/bin/ruby") do
    it { should exist }
    it { should be_file }
  end

  context "system version" do
    %w(ruby irb gem).each do |exe|
      describe file("/usr/local/bin/#{exe}") do
        it { should be_symlink }
        it { should be_linked_to "/opt/rubies/2.2.3/bin/#{exe}" }
      end
    end
  end
end
