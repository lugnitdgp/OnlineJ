namespace :judge do
  desc 'TODO'
  task init: :environment do
    user = `whoami`.chomp
    path = File.join(Rails.root, 'judge_data', 'judge_exec', 'judge_exec')
    if File.exist? path
      write = "#{user} ALL=(root) NOPASSWD: #{path}"
      exec = "sudo bash -c 'echo \"#{write}\" >> /etc/sudoers'"
      pid = Process.spawn(exec)
      _, status = Process.wait2(pid)
      if !status.exited? || status.exitstatus != 0
        puts 'permission denied'
        return
      end
      puts 'Judge is ready'
    else
      puts 'Donot move or delete judge_data aborting...'
      puts 'try again'
    end
  end
end
