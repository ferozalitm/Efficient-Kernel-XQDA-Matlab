function M = projectPSD(M)
% project the matrix M to its cone of PSD
% INPUT
%   M: a squared matrix
% OUTPUT
%   M: the PSD matrix
%-------------------------------------------------------------------------%
% author: Bac Nguyen (bac.nguyencong@ugent.be)
%-------------------------------------------------------------------------%

    [V,D]=eig(M); 
    
    if(~isreal(D))
        error('Complex Eigen values');
    end
    
    %V = real(V); 
    latent = diag(D);
    [latent, index] = sort(latent, 'descend');
    d=diag(real(D));
    d(d<=0)=eps;
    %d(d<=0)=0.001;
    M = V*diag(d)*V';
    M = (M+M')/2;
end