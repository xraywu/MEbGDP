class RwrhJob < Struct.new(:omim_id, :top_results, :lambda, :gamma, :eta, :network, :task_id)
  
  
  def perform
    script_path = Rails.root.join('app', 'tasks', 'rwrh')
    task_dir = "task_temp/#{task_id}"
    Dir.mkdir(task_dir)
    filepath = Rails.root.join(task_dir)
    
    network.each do |n|
      file_number = Dir.entries(filepath).length
      process = ChildProcess.build("matlab","-sd","#{script_path}",
                                   "-nojvm","-nosplash","-nodesktop","-minimize","-r",
                                   "#{n}(#{omim_id},#{top_results},#{lambda},#{gamma},#{eta},'#{filepath}')")
      process.start
      while Dir.entries(filepath).length == file_number do
        sleep 1
      end
    end
    
    completeFile = File.new "#{filepath}/finish","w"
    completeFile.close
    
  end
  
end