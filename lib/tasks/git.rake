
namespace :git do
  desc "Finalize project setup"
  task :setup_project => :environment do
    puts "* Copying database config from template"
    `cp #{RAILS_ROOT}/config/database.example.yml #{RAILS_ROOT}/config/database.yml`
    
    puts "* Adding submodules"
    `git submodule init`
    `git submodule add`
    
    puts "* Generating rspec configs"
    `./script/generate rspec`
    `git add script/spec spec`
    `git commit -m '* Generating configs for rspec'`
  end
end