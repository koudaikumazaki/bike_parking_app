# # 追記部分
app_dir = File.expand_path("../..", __FILE__)
bind "unix://#{app_dir}/tmp/sockets/puma.sock"
daemonize

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
# コメントアウトしないと、puma.sockを参照しない可能性があるらしい。
# port ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# preload_app!



# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

# # # アプリケーションディレクトリ
# # app_dir = File.expand_path("../../", __FILE__)
# # # ソケット通信を図る為bindでURI指定
# # bind "unix://#{app_dir}/tmp/sockets/puma.sock"
# # # PIDファイル所在(プロセスID)
# # pidfile "#{app_dir}/tmp/pids/puma.pid"
# # # stateファイルはpumactlコマンドでサーバーを操作する。その所在。
# # state_path "#{app_dir}/tmp/pids/puma.state"
# # # 標準出力/標準エラーを出力するファイルの所在。
# # stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true
# # threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
# # threads threads_count, threads_count
# # #port ENV.fetch("PORT") { 3000 }
# # environment ENV.fetch("RAILS_ENV") { "development" }
# # plugin :tmp_restart

# app_dir = File.expand_path("../..", __FILE__)
# bind "unix://#{app_dir}/tmp/sockets/puma.sock"
# pidfile "#{app_dir}/tmp/pids/puma.pid"
# state_path "#{app_dir}/tmp/pids/puma.state"
# stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true