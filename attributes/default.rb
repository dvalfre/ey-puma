#
# Cookbook Name:: puma
# Attributes:: default
#

puma({
  # number of puma workers in the cluster
  # for more info see: https://github.com/puma/puma#clustered-mode
  :workers => 2,
  
  # number of threads to use
  # for more info see: https://github.com/puma/puma#thread-pool
  :threads => {
    :minimum => 16,
    :maximum => 32
  },
  
  # memory limit threshold
  # (used by monit)
  :memory_limit => 300
})