function [ Phi ] = BPBDMtx(M,N)
k=N/M;
Phi=zeros(M,N);
if (M<N/2)||(M==N/2)
    for i=1:M
        Phi(i,2*i-1)=1; 
        Phi(i,2*i)=1; 
    end
end
if M>N/2
    for i=1:N/2
        Phi(i,2*i-1)=1; 
        Phi(i,2*i)=1; 
    end
    for j=(N/2)+1:M
        Phi(j,2*(j-N/2)-1)=1; 
        Phi(j,2*(j-N/2))=1; 
    end
end
