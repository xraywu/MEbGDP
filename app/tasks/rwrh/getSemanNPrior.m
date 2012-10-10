function [ result ] = getSemanNPrior( MimID,Top_Number,lamda,gamma,eta, filepath )
    result =  getGeneRank_Seman(MimID,Top_Number,1,lamda,gamma,eta);
    
    filename = [filepath '/seman_nprior.txt'];
    fid = fopen(filename,'w');
    for i = 1:length(result)
        fprintf(fid,'%s\n',result{i,1});
    end
    
    exit;
end

