class RwrhJob < Struct.new(:omim_id, :top_results, :lambda, :gamma, :eta, :network, :task_id)
  
  
  def perform
    matlab_path = Rails.root.join('app', 'tasks', 'rwrh')
    task_dir = "task_temp/#{task_id}"
    Dir.mkdir(task_dir)
    filepath = Rails.root.join(task_dir)
    
    network.each do |n|
      rwrh_command = "matlab -sd #{matlab_path} -nojvm -nosplash -nodesktop -minimize -r #{n}(#{omim_id},#{top_results},#{lambda},#{gamma},#{eta},'#{filepath}')"
      %x[#{rwrh_command}]
    end
  end
  
end