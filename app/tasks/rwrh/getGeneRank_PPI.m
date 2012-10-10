function [top_genes] = getGeneRank(MimID,Top_Number,remove_prior,lamda,gamma,eta) %If need count only, replace results into cnt
% cnt = abInitio(0.5,0.7,0.5)
load Mim5NN_PPI
% clear MimM
load PPIM_PPI
load BridgeM_PPI

Ng = length(genes);
Nd = size(MimIDs_5080,1); 

% to get the transition matrix for gene network
for i = 1 : Ng
    if sum(PPIM(:,i)) == 0
        PPIW(:,i) = sparse(zeros(size(PPIM(:,i))));
    else
        PPIW(:,i) = PPIM(:,i)/sum(PPIM(:,i));
    end
end
clear PPIM

% to get the transition matrix for phenotype network
for i = 1 : Nd
    if sum(MimM(:,i)) == 0
        MimW(:,i) = sparse(zeros(size(MimM(:,i))));
    else
        MimW(:,i) = MimM(:,i)/sum(MimM(:,i));
    end
end
clear MimM

[idxMIM, idxPPI] = find(bridgeM);
gMim = unique(MimIDs_5080(idxMIM)); %MimIDs having gene annotation
p0=zeros(Ng,1);

idxD = find(ismember(MimIDs_5080,MimID));
if(remove_prior == 1)
    idxG = find(bridgeM(idxD,:)>0); % index of phenotype ralated genes
    bridgeM(idxD,idxG) = 0;
end
[G2P,P2G] = getBridgeM(bridgeM);
d0 = zeros(Nd,1); d0(idxD) = 1; % seed phenotype
[p,d,steps] = rwrH(PPIW,MimW,G2P,P2G,gamma,lamda,eta,d0,p0);
result_p = sort(p,'descend');
top_genes = [];
for i = 1 : Top_Number
   gene_id = round(mean(find(p == result_p(i))));
   if(result_p(i) == 0)
       break;
   end
   if isnan(gene_id) == 0
       gene = genes(gene_id,5);
       top_genes = [top_genes gene];
   else
       return;
   end
end
top_genes = top_genes';
