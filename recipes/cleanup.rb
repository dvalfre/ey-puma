if node[:instance_role][/app|solo/]
  execute 'cleanup old puma workers' do
    command 'ps aux | egrep "puma.50[0-9]{2}" | xargs kill'
  end
end