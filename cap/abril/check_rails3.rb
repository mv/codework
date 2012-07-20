require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)
require File.dirname(__FILE__) + '/check'

CapistranoEden.with_configuration do

  before "deploy:symlink", "check:rails3"

end
