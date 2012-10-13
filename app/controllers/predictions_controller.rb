class PredictionsController < ApplicationController
  require Rails.root.join('app', 'tasks', 'RwrhJob.rb')
  
  def parameter
    @disease = Disease.find_by_omim_id(params[:omim_id])
    @prediction = Prediction.new
    @title = "Prediction Panel"
    render :layout => "noLayout"
  end

  def predict
    @parameter = Prediction.new(params[:prediction])
    if @parameter.valid?
       @task_id = Time.new.to_time.to_i
       Delayed::Job.enqueue RwrhJob.new(params[:prediction][:omim_id],
                                        params[:prediction][:top_results],params[:prediction][:lambda],
                                        params[:prediction][:gamma],params[:prediction][:eta],
                                        params[:prediction][:network], @task_id)
    else
      @disease = Disease.find_by_omim_id(params[:prediction][:omim_id])
      render :action => 'parameter'
    end
  end
  
  def pollResult
    task_id = params[:task_id]
    task_folder = Rails.root.join('task_temp',task_id)
    if File.exists?("#{task_folder}\\finish")
      File.delete("#{task_folder}\\finish")
      @results = loadAllResultFiles(task_folder)
    end
  end
  
  private
  
  def loadAllResultFiles(task_folder)
    results = []
    
    if File.exists?("#{task_folder}\\seman_prior.txt")
      resultArray = loadResultFile(task_folder,"seman_prior.txt")
        results.push Hash["Semantic Prior Network",resultArray]
    end
    
    if File.exists?("#{task_folder}\\seman_nprior.txt")
      resultArray = loadResultFile(task_folder,"seman_nprior.txt")
        results.push Hash["Semantic Non-Prior Network",resultArray]
    end
    
    if File.exists?("#{task_folder}\\ppi_prior.txt")
      resultArray = loadResultFile(task_folder,"ppi_prior.txt")
        results.push Hash["PPI Prior Network",resultArray]
    end
        
    if File.exists?("#{task_folder}\\ppi_nprior.txt")
      resultArray = loadResultFile(task_folder,"ppi_nprior.txt")
        results.push Hash["PPI Non-Prior Network",resultArray]
    end
        
    return results
  end
  
  def loadResultFile(task_folder, file_name)
    resultArray = []
    f = File.open("#{task_folder}\\#{file_name}") or die "Unable to open file..."
    f.each_line {|line|
       resultArray.push line
    }
    resultArray
  end

end
