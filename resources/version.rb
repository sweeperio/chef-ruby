default_action :install

property :version, String, name_property: true
property :symlink, [TrueClass, FalseClass], default: false

action :install do
  directory(install_dir) { recursive true }

  libs = ::File.join(install_dir, version, "lib", "libruby.so*")
  bins = ::File.join(install_dir, version, "bin", "*")

  execute "symlink shared libs #{version}" do
    action :nothing
    command "ln -s #{libs} ."
    cwd "/usr/lib"
  end

  execute "symlink ruby #{version}" do
    action :nothing
    command "ln -s #{bins} ."
    cwd "/usr/local/bin"
    only_if { symlink }
    notifies :run, "execute[symlink shared libs #{version}]", :immediately
  end

  ark "ruby-#{version}" do
    action :put
    name new_resource.version
    version new_resource.version
    path install_dir
    url tar_file
    notifies :run, "execute[symlink ruby #{new_resource.version}]", :immediately
  end
end

def install_dir
  node.attr!("swpr_ruby", "install_dir")
end

def tar_file
  node.attr!("swpr_ruby", "sources", version)
end
