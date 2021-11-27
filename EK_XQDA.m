function [theta, Gamma] = EK_XQDA(K, probLabels, galLabels )

qdaDims = -1;

% data       
numGals = size(galLabels, 1); 
numProbs = size(probLabels, 1);
n = numGals;
m = numProbs;

% Eq.(11) in paper
K_xx = K(1:numGals, 1:numGals);K_xz = K(1:numGals, numGals+1:numGals+numProbs);
K_zx = K(numGals+1:numGals+numProbs, 1:numGals);K_zz = K(numGals+1:numGals+numProbs, numGals+1:numGals+numProbs); 

labels = unique([galLabels;probLabels  ]);
c = length(labels);

galW = zeros(numGals, 1);
probW = zeros(numProbs, 1);
ni = 0;

F = zeros(numGals , 1);
G = zeros(numProbs, 1);
H  = zeros(numGals+numProbs, 2*c);
num_galClassSum = zeros(c, 1);
num_probClassSum = zeros(c, 1);

for k = 1 : c
    galIndex = find(galLabels == labels(k));
    nk = length(galIndex);
    num_galClassSum(k, :) = nk;
    
    probIndex = find(probLabels == labels(k));
    mk = length(probIndex);
    num_probClassSum(k, :) = mk;
    
    ni = ni + nk * mk;
    galW(galIndex) = sqrt(mk);
    probW(probIndex) = sqrt(nk);
    
    G(probIndex) = nk;
    F(galIndex) = mk;
    H(:,k) = sum(K(:,galIndex),2);
    H(:,c+k) = sum(K(:,numGals+probIndex),2);    
end

H_xx = H(1:n,1:c);H_xz = H(1:n,c+1:2*c);H_zx = H(n+1:n+m,1:c);H_zz = H(n+1:n+m,1+c:2*c);

A = [K_xx;K_zx]*diag(F)*[K_xx;K_zx]';   %Eq.(22) in paper
B = [K_xz;K_zz]*diag(G)*[K_xz;K_zz]';   %Eq.(25) in paper
C = [H_xx;H_zx]*[H_xz' H_zz'];          %Eq.(30) in paper
U = m*[K_xx;K_zx]*[K_xx;K_zx]';         %Eq.(38) in paper
V = n*[K_xz;K_zz]*[K_xz;K_zz]';         %Eq.(39) in paper
E = [K_xx;K_zx]*ones(n,m)*[K_xz;K_zz]'; %Eq.(40) in paper

% Symmetric matrices correction
A = (A+A')/2;
B = (B+B')/2;
U = (U+U')/2;
V = (V+V')/2;

KexCov = U+V-E-E'-A-B+C+C';             %Eq.(45) in paper
KinCov = A+B-C-C';                      %Eq.(31) in paper

% Symmetric matrices correction
KexCov = (KexCov+KexCov')/2;
KinCov = (KinCov+KinCov')/2;

ne = numGals * numProbs - ni;
KexCov = KexCov / ne;
KinCov = KinCov / (ni);

I1 = eye(size(KinCov));
KinCov = KinCov + (10^-7)*I1;

% Finding eigen system
[W, S] = eig(KinCov \ KexCov);

% choose only real elements
latent = diag(S);
sel = latent ~= real(latent);
latent = latent(~sel);
W = W(:,~sel);

[latent, index] = sort(latent, 'descend');

energy = sum(latent);
minv = latent(end);

r = sum(latent > 1);
energy = sum(latent(1:r)) / energy;

if qdaDims > r
    qdaDims = r;
end

if qdaDims <= 0
    qdaDims = max(1,r);
end

theta = W(:, index(1:qdaDims));
    
% Normalizing theta to ensure discriminants are unit norm
for s = 1:qdaDims
    norm_factor = theta(:,s)'*K*theta(:,s);
    theta(:,s) = theta(:,s)/sqrt(norm_factor);
end

Gamma = inv(theta'*KinCov*theta) - inv(theta'*KexCov*theta);    %From Theorem (3) in paper

end
