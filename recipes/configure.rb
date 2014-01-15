if node[:instance_role][/app|solo/]
  solo = !!node[:instance_role][/solo/]
  
  execute "reload-monit" do
    command "monit reload"
    action :nothing
  end
  
  node[:applications].each do |app_name, data|
    template "/data/#{app_name}/shared/config/puma.rb" do
      source "puma.rb.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode '0644'
      backup false
      variables({
        :app_name => app_name,
        :threads => node[:puma][:threads].values.sort,
        :workers => node[:puma][:workers],
        :framework_env => node[:environment][:framework_env]
      })
    end
  
    template "/etc/nginx/servers/#{app_name}.conf" do
      source "nginx_app.conf.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode '0644'
      backup false
      variables({
        :app_name => app_name,
        :port => (solo ? 80 : 81),
      })
      notifies :reload, resources(:service => "nginx")
    end
    
    template "/etc/monit.d/puma_#{app_name}.monitrc" do
      source "puma.monitrc.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode '0644'
      backup false
      variables({
        :app_name => app_name,
        :user => node[:owner_name], 
        :memory_limit => node[:puma][:memory_limit]
      })
      notifies :run, resources(:execute => 'reload-monit')
    end
    
    template "/engineyard/bin/app_#{app_name}" do
      source "app_control.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode '0755'
      backup false
      variables({
        :app_name => app_name,
        :user => node[:owner_name]
      })
    end
  end
end