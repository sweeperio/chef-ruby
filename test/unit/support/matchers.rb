# these already exist upstream, just not released yet
def put_ark(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:ark, :put, resource_name)
end

def install_with_make_ark(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:ark, :install_with_make, resource_name)
end
