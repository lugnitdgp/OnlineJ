namespace :docker do
  desc 'Start Judge with docker'
  task judge_run: :environment do
    if (CONFIG[:judge_docker] == true)
      exec = "bash -c 'docker run -d -v #{Rails.root}/judge_data:#{Rails.root}/judge_data eh2arch/revi_oj tail -f /dev/null > tmp/container'"
      pid = Process.spawn(exec)
      _, status = Process.wait2(pid)
      if !status.exited? || status.exitstatus != 0
        puts 'Plase make sure docker is running properly'
        return
      end
      puts 'Judge is ready to run with docker'
    else
      puts 'Please set judge_docker config variable in config/application.yml'
      puts 'OR'
      puts 'try again'
    end
  end
  desc 'Stop docker'
  task judge_stop: :environment do
    tmp = 'tmp/container'
    if (CONFIG[:judge_docker] == true) || !File.exist?(tmp)
      container_id = File.read(tmp)
      exec = "bash -c 'docker kill #{container_id}'"
      pid = Process.spawn(exec)
      _, status = Process.wait2(pid)
      if !status.exited? || status.exitstatus != 0
        puts 'Plase make sure docker is running properly'
        return
      end
      File.delete(tmp)
      puts 'judge stopped with docker'
    else
      puts 'Please set judge_docker config variable in config/application.yml'
      puts 'OR'
      puts 'run docker_run task first'
      puts 'try again'
      puts 'Please set judge_docker config variable and try again'
    end
  end

end
