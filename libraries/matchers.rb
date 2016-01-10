if defined?(ChefSpec)
  def install_ruby_version(version)
    ChefSpec::Matchers::ResourceMatcher.new(:swpr_ruby_version, :install, version)
  end
end
