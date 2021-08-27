lock "~> 3.16.0"

require 'capistrano-db-tasks'

set :rbenv_type, :user

set :application, "mnwr-backend"
set :repo_url, "git@github.com:StevenDRiggs/my-next-website-revamp-backend.git"
set :deploy_to, "/home/deploy/#{fetch(:application)}"

set :bundle_flags, nil

set :conditionally_migrate, true

set :linked_files, %w(config/database.yml config/master.key config/secrets.yml)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system .bundle)

set :keep_releases, 3
set :keep_assets, 3

set :migration_role, :app

set :rails_env, 'production'

set :db_remote_clean, true
set :db_local_clean, true
set :db_ignore_tables, [mnwr_backend_production]

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 10 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Upload master.key and secrets.yml'
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 5 do
        unless test("[ -f #{shared_path}/config/master.key ]")
          upload! 'config/master.key', "#{shared_path}/config/master.key"
        end
        unless test("[ -f #{shared_path}/config/secrets.yml ]")
          upload! 'config/secrets.yml', "#{shared_path}/config/secrets.yml"
        end
      end
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

