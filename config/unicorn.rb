rails_env = ENV['RAILS_ENV'] || 'production'
app_path = "/home/www/tick-tock/current"

worker_processes 2
working_directory app_path

preload_app true
timeout 120
listen 8888, :tcp_nopush => true
listen "#{app_path}/tmp/sockets/unicorn.sock", :backlog => 64
pid "#{app_path}/tmp/pids/unicorn.pid"

stderr_path "#{app_path}/log/unicorn.stderr.log"
stderr_path "#{app_path}/log/unicorn.stdout.log"

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{app_path}/Gemfile"
end

before_fork do |server, worker|
  old_pid = "#{app_path}/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errono::ENOENT, Errno::ESRCH
      puts "Send 'QUIT' signal to unicorn error!"
    end
  end
end

after_fork do |server, worker|
  begin
    uid, gid = Process.euid, Process.egid
    user, group = 'www', 'www'
    target_uid = Etc.getpwnam(user).uid
    target_gid = Etc.getgrnam(group).gid
    worker.tmp.chown(target_uid, target_gid)
    if uid != target_uid || gid != target_gid
      Process.initgroups(user, target_gid)
      Process::GID.change_privilege(target_gid)
      Process::UID.change_privilege(target_uid)
    end
  rescue => e
    if ENV['RAILS_ENV'] == 'development'
      STDERR.puts "couldn't change user"
    else
      raise e
    end
  end
end
