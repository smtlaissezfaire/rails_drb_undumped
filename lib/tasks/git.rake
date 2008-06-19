namespace :git do
  desc "Add submodules to project"
  task :add_submodules do
    puts `cp #{RAILS_ROOT}/config/database.example.yml #{RAILS_ROOT}/config/database.yml`
    puts `git submodule init`
    puts `git submodule update`
  end
end