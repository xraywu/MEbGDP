class PredictionsController < ApplicationController
  require Rails.root.join('app', 'tasks', 'RwrhJob.rb')
  require 'zip/zip'
  require 'open-uri'
  
  OMIM_API_KEY = '30C52EDBCFC6F856381C6FC7C10B852FCB36CA3B'
  OMIM_API_URL = 'http://api.omim.org/api/entry'
  OMIM_INCLUDED_SECTIONS = 'include=text:cytogenetics&include=text:description&include=text:molecularGenetics'
  
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
       task_dir = "task_temp/#{@task_id}"
       Dir.mkdir(task_dir)
       writeLogFile(params[:prediction][:omim_id],
                    params[:prediction][:top_results],params[:prediction][:lambda],
                    params[:prediction][:gamma],params[:prediction][:eta],
                    params[:prediction][:network], @task_id)
                    
       @omim_id = params[:prediction][:omim_id]
       
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
    @omim_id = params[:omim_id]
    task_folder = Rails.root.join('task_temp',@task_id)
    if File.exists?("#{task_folder}/finish")
      @linkage_interval = getLinkageInterval(@omim_id)
      File.delete("#{task_folder}/finish")
      writeOverlappedResultsFile(task_folder)
      @disease = Disease.find_by_omim_id(@omim_id)
      @results = loadAllResultFiles(task_folder)
    end
  end
  
  def showOverlappedResults
    @task_id = params[:task_id]
    @omim_id = params[:omim_id]
    @disease = Disease.find_by_omim_id(@omim_id)
    @linkage_interval = getLinkageInterval(@omim_id)
    task_folder = Rails.root.join('task_temp',@task_id)
    @results = loadResultFile(task_folder, "overlapped.txt")
  end
  
  def showAllResults
    @task_id = params[:task_id]
    @omim_id = params[:omim_id]
    @disease = Disease.find_by_omim_id(@omim_id)
    @linkage_interval = getLinkageInterval(@omim_id)
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
  
  def writeLogFile(omim_id, top_results, lambda, gamma, eta, network, task_id)
    task_dir = "task_temp/#{task_id}"
    logFile_dir = Rails.root.join(task_dir,'log.log')
    logFile = File.new(logFile_dir,"w")
    logFile.write("#{Time.new}\n")
    logFile.write("===========================\n\n")
    logFile.write("OMIM Entry: #{omim_id}\n")
    logFile.write("Top Results: #{top_results}\n")
    logFile.write("Lambda: #{lambda}\n")
    logFile.write("Gamma: #{gamma}\n")
    logFile.write("Eta: #{eta}\n")
    logFile.close
  end
  
  def loadAllResultFiles(task_folder)
    results = []
        
    if File.exists?("#{task_folder}/seman_prior.txt")
      resultArray = loadResultFile(task_folder,"seman_prior.txt")
      resultArray.collect! {|result| result.chomp }
      results.push Hash["Semantic Prior Network",resultArray]
    end
    
    if File.exists?("#{task_folder}/seman_nprior.txt")
      resultArray = loadResultFile(task_folder,"seman_nprior.txt")
      resultArray.collect! {|result| result.chomp }
      results.push Hash["Semantic Non-Prior Network",resultArray]
    end
    
    if File.exists?("#{task_folder}/ppi_prior.txt")
      resultArray = loadResultFile(task_folder,"ppi_prior.txt")
      resultArray.collect! {|result| result.chomp }
      results.push Hash["PPI Prior Network",resultArray]
    end
        
    if File.exists?("#{task_folder}/ppi_nprior.txt")
      resultArray = loadResultFile(task_folder,"ppi_nprior.txt")
      resultArray.collect! {|result| result.chomp }
      results.push Hash["PPI Non-Prior Network",resultArray]
    end
    
    return results
  end
  
  def loadResultFile(task_folder, file_name)
    resultArray = []
    f = File.open("#{task_folder}/#{file_name}") or die "Unable to open file..."
    f.each_line do |line|
       resultArray.push line
    end
    resultArray.collect! {|result| result.chomp } 
  end
  
  def writeOverlappedResultsFile(task_folder)   
    results = []
    
    if File.exists?("#{task_folder}/seman_prior.txt")
      seman_prior = loadResultFile(task_folder,"seman_prior.txt")
      unless seman_prior.empty?
        results.push(seman_prior)
      end
    end
    
    if File.exists?("#{task_folder}/seman_nprior.txt")
      seman_nprior = loadResultFile(task_folder,"seman_nprior.txt")
      unless seman_nprior.empty?
        results.push(seman_nprior)
      end
    end
    
    if File.exists?("#{task_folder}/ppi_prior.txt")
      ppi_prior = loadResultFile(task_folder,"ppi_prior.txt")
      unless ppi_prior.empty?
        results.push(ppi_prior)
      end
    end
        
    if File.exists?("#{task_folder}/ppi_nprior.txt")
      ppi_nprior = loadResultFile(task_folder,"ppi_nprior.txt")
      unless ppi_nprior.empty?
        results.push(ppi_nprior)
      end
    end
    
    overlappedResults = results[0]
    
    results.each do |resultArray|
      overlappedResults = resultArray & overlappedResults
    end
    
    File.open("#{task_folder}/overlapped.txt", "w", :type => 'text/html; charset=utf-8'){ |f| f << overlappedResults.join("\n")}
  end

  def generateZipFile(task_id)
    task_folder = Rails.root.join('task_temp',task_id)
    zipfile_name = "#{task_folder}/#{task_id}.zip"
    if File.exists?(zipfile_name)
      File.delete(zipfile_name)
    end
    
    result_files = Dir.entries(task_folder)
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      result_files.each do |filename|
        unless filename == "." || filename == ".."
          zipfile.add(filename, "#{task_folder}/#{filename}")
        end
      end
    end
    return zipfile_name
  end

  def getLinkageInterval(omim_id)
    information_url = "#{OMIM_API_URL}?mimNumber=#{omim_id}&apiKey=#{OMIM_API_KEY}&#{OMIM_INCLUDED_SECTIONS}"
    information_xml = Nokogiri::XML(open(information_url))
    information_to_be_parsed = information_xml.xpath("////textSectionContent").to_s
    linkage_interval = parse_linkage_interval(information_to_be_parsed)
  end
  
  def parse_linkage_interval(information)
    linkage_interval = []
    #Use rubular.com for verification
    interval_pattern1 = /t\((((\d+|X|Y);*)+)\)\((((\d+|X|Y)*(p|q)(\d+)(\.\d+)*;*)+)\)/ #e.g. t(2;12;X)(q22.3;12q22;q21.33)
    interval_pattern2 = /((\d+|X|Y)(p|q)(\d+)(\.\d)*(-(p|q)(\d+)(\.\d)*)*)/ #e.g. 12q11.3-q12
    simple_pattern = /(\d+|X|Y)+((p|q)\d+(\.\d+)*)/ #e.g 12q11.3
    
    information.scan(interval_pattern1).each do |m|
      chromosome = m[0].split(';') #m[0] is the first parentheses
      band = m[3].split(';')  #m[3] is the second parentheses
      interval = chromosome.map.with_index do |elem, idx|
        if band[idx] =~ simple_pattern
          elem + $2 #$2 is the q11.3 part 
        else
          elem + band[idx]
        end
      end  
      linkage_interval.concat(interval)
    end
    
    information.scan(interval_pattern2).each do |m|
      linkage_interval.push(m[0]) #m[0] is the whole match
    end
    
    linkage_interval.uniq!
  end

end