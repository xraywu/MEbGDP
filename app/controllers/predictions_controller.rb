class PredictionsController < ApplicationController
  require Rails.root.join('app', 'tasks', 'RwrhJob.rb')
  require 'rubygems'
  require 'zip/zip'
  
  def parameter
    @disease = Disease.find_by_omim_id(params[:omim_id])
    @prediction = Prediction.new
    @title = "Prediction Panel"
    render :layout => "noLayout"
  end

  def predict
    @title = "Prediction Results"
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
  
  def pollAllResults
    @task_id = params[:task_id]
    task_folder = Rails.root.join('task_temp',@task_id)
    if File.exists?("#{task_folder}\\finish")
      File.delete("#{task_folder}\\finish")
      writeOverlappedResultsFile(task_folder)
      @results = loadAllResultFiles(task_folder)
    end
  end
  
  def showOverlappedResults
    @task_id = params[:task_id]
    task_folder = Rails.root.join('task_temp',@task_id)
    @results = loadResultFile(task_folder, "overlapped.txt")
  end
  
  def showAllResults
    @task_id = params[:task_id]
    task_folder = Rails.root.join('task_temp',@task_id)
    @results = loadAllResultFiles(task_folder)
  end
  
  def downloadResults
    task_id = params[:task_id]
    task_folder = Rails.root.join('task_temp',task_id)
    zipfile_name = generateZipFile(task_id)
    send_file zipfile_name, :type=>"application/zip" 
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
    f.each_line do |line|
       resultArray.push line
    end
    resultArray
  end
  
  def writeOverlappedResultsFile(task_folder)   
    results = []
    
    if File.exists?("#{task_folder}\\seman_prior.txt")
      seman_prior = loadResultFile(task_folder,"seman_prior.txt")
      unless seman_prior.empty?
        results.push(seman_prior)
      end
    end
    
    if File.exists?("#{task_folder}\\seman_nprior.txt")
      seman_nprior = loadResultFile(task_folder,"seman_nprior.txt")
      unless seman_nprior.empty?
        results.push(seman_nprior)
      end
    end
    
    if File.exists?("#{task_folder}\\ppi_prior.txt")
      ppi_prior = loadResultFile(task_folder,"ppi_prior.txt")
      unless ppi_prior.empty?
        results.push(ppi_prior)
      end
    end
        
    if File.exists?("#{task_folder}\\ppi_nprior.txt")
      ppi_nprior = loadResultFile(task_folder,"ppi_nprior.txt")
      unless ppi_nprior.empty?
        results.push(ppi_nprior)
      end
    end
    
    overlappedResults = results[0]
    
    results.each do |resultArray|
      overlappedResults = resultArray & overlappedResults
    end
    
    File.open("#{task_folder}\\overlapped.txt", "w", :type => 'text/html; charset=utf-8'){ |f| f << overlappedResults.join("")}
  end

  def generateZipFile(task_id)
    task_folder = Rails.root.join('task_temp',task_id)
    zipfile_name = "#{task_folder}\\#{task_id}.zip"
    if File.exists?(zipfile_name)
      File.delete(zipfile_name)
    end
    
    result_files = Dir.entries(task_folder)
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      result_files.each do |filename|
        unless filename == "." || filename == ".."
          zipfile.add(filename, "#{task_folder}\\#{filename}")
        end
      end
    end
    return zipfile_name
  end

end