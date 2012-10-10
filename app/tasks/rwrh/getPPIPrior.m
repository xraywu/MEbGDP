function [ result ] = getPPIPrior( MimID,Top_Number,lamda,gamma,eta, filepath )
    result =  getGeneRank_PPI(MimID,Top_Number,0,lamda,gamma,eta);
    
    filename = [filepath '/ppi_prior.txt'];
    fid = fopen(filename,'w');
    for i = 1:length(result)
        fprintf(fid,'%s\n',result{i,1});
    end
    
    exit;
end

