# already exists upstream, just not released yet
def put_ark(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:ark, :put, resource_name)
end
