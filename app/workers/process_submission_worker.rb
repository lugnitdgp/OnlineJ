class ProcessSubmissionWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed, queue: :default, retry: 5

  def perform(args)
    submission_id = args['submission_id']
    submission = Submission.by_id(submission_id).first
    return if submission.nil? || submission[:status_code] != 'PE'
    ext_hash = { 'c++' => '.cpp', 'java' => '.java', 'python' => '.py', 'c' => '.c', 'ruby' => '.rb' }
    problem = submission.problem
    contest = problem.contest
    user_email = submission.user[:email]
    lang_code = submission.language[:lang_code]
    submission_dir = "#{CONFIG[:base_path]}/#{user_email}/#{contest[:ccode]}/#{problem[:pcode]}/#{submission_id}/"
    begin
      File.exist?(submission_dir + "/user_source_code#{ext_hash[lang_code]}")
    rescue Errno::ENOENT
      system 'rm', '-rf', submission_dir
      return
    end
    compilation = nil
    if lang_code == 'c'
      compilation = " bash -c 'gcc -std=c++0x -w -O2 -fomit-frame-pointer -lm -o compiled_code user_source_code#{ext_hash[lang_code]} >& compile_log'"
    elsif lang_code == 'c++'
      compilation = "bash -c 'g++ -std=c++0x -w -O2 -fomit-frame-pointer -lm -o compiled_code user_source_code#{ext_hash[lang_code]} &> compile_log'"
    elsif lang_code == 'java'
      compilation = "bash -c 'javac compiled_code user_source_code#{ext_hash[lang_code]} &> compile_log'"
    end

    unless compilation.nil?
      pid = Process.spawn(compilation, chdir: submission_dir)
      pid, status = Process.wait2(pid)
      if !status.exited? || status.exitstatus != 0
        begin
          compile_log = File.read(submission_dir + 'compile_log')
        rescue
          compile_log = 'compilation Error'
        end
        submission.update_attributes!(status_code: 'CE', error_desc: compile_log)
        return
      end
    end
  end
end
