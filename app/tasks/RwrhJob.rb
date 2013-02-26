class RwrhJob < Struct.new(:omim_id, :top_results, :lambda, :gamma, :eta, :network, :task_id)
  
  def perform
    script_path = Rails.root.join('app', 'tasks', 'rwrh')
    task_dir = "task_temp/#{task_id}"
    filepath = Rails.root.join(task_dir)
    
    network.each do |n|
      file_number = Dir.entries(filepath).length
      
       #Different matlab command under different OS
      if RUBY_PLATFORM.downcase.include?("mingw32") || RUBY_PLATFORM.downcase.include?("win32")
        #Check the command see if it works to call Matlab on your system
        process = ChildProcess.build("matlab","-sd","#{script_path}",
                                     "-nojvm","-nosplash","-nodesktop","-minimize","-r",
                                     "#{n}(#{omim_id},#{top_results},#{lambda},#{gamma},#{eta},'#{filepath}')")
      elsif RUBY_PLATFORM.downcase.include?("linux")
        process = ChildProcess.build("matlab","-nodesktop","-r",
                                     "#{n}\(#{omim_id},#{top_results},#{lambda},#{gamma},#{eta},\'#{filepath}\'\)")
      end
      
      #Exec the command
      process.start
      
      while Dir.entries(filepath).length == file_number do
        sleep 1
      end
    end
    
    completeFile = File.new "#{filepath}/finish","w" #Create an empty temp file to indicate the task is completed
    completeFile.close
    
  end
  
end