require "spec_helper"

describe "swpr_ruby" do
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

    %w(libruby.so libruby.so.2.2 libruby.so.2.2.0).each do |lib|
      describe file("/usr/lib/#{lib}") do
        it { should be_symlink }
        it { should be_linked_to "/opt/rubies/2.2.3/lib/#{lib}" }
      end
    end
  end

  context "chruby" do
    CHRUBY_FILES = {
      profile: "/etc/profile.d/chruby.sh",
      chruby: "/usr/local/chruby-0.3.9/share/chruby/chruby.sh",
      auto: "/usr/local/chruby-0.3.9/share/chruby/auto.sh"
    }.freeze

    CHRUBY_FILES.each do |_, file|
      describe file(file) do
        it { should exist }
        it { should be_file }
      end
    end

    describe file(CHRUBY_FILES[:profile]) do
      it { should exist }
      it { should be_mode("644") }

      its(:content) { should contain("source #{CHRUBY_FILES[:chruby]}") }
      its(:content) { should contain("source #{CHRUBY_FILES[:auto]}") }
    end

    describe command("source /etc/profile && chruby") do
      let(:shell) { "/bin/bash" }

      its(:exit_status) { should eq(0) }
      its(:stdout) { should match(/2\.2\.2\n\s*\*\s*2\.2\.3/) }
    end
  end
end
