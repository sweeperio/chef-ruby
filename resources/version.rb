default_action :install

property :version, String, name_property: true
property :symlink, [TrueClass, FalseClass], default: false

action :install do
  directory(install_dir) { recursive true }

  execute "symlink ruby #{version}" do
    action :nothing
    command "ln -s /opt/rubies/#{version}/bin/* ."
    cwd "/usr/local/bin"
    only_if { symlink }
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
  node.attr!("ruby", "install_dir")
end

def tar_file
  node.attr!("ruby", "sources", version)
end
