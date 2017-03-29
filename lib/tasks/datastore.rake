require 'fileutils'

namespace :datastore do
  desc "TODO"
  task clean: :environment do
    Rake::Task["db:drop"].invoke
    Dir.chdir(CONFIG[:base_path])
    file_list = Dir.entries(Dir.pwd)
    judgePath = "judge_exec"
    file_list = file_list.reject{ |f| f == judgePath || f == ".." || f == "."  || !(File.directory? f)}
    file_list.each do |dir|
      FileUtils.rm_r dir
    end
  end

end
