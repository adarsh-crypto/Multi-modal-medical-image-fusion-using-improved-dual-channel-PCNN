function R=IDPCNN(A,B) % Code for IDPCNN model


%Absolute values can be used

alpha_U=0.7; % alpha_f


V_E=20;


alpha_E=0.2;

betaAI=WSEML(A);
betaA=betaAI/max(betaAI(:));

betaBI=WSEML(B);
betaB=betaBI/max(betaBI(:));

iteration_times=120;

%DCPCNN

[p,q]=size(A);
F1=abs(A);
F2=abs(B);
U=zeros(p,q);
Y=zeros(p,q);
E=ones(p,q);


W=[0.707 1 0.707;1 0 1;0.707 1 0.707];

for n=1:iteration_times
    K = conv2(Y,W,'same');
    U1=F1.* (1 + betaA .* K);
    U2=F2.* (1 + betaB .* K);
    map=(U1>=U2);
    U3=map.*U1+~map.*U2;
    U = exp(-alpha_U) * U + U3;
    Y = im2double( U > E );
    E = exp(-alpha_E) * E + V_E * Y;
    
end

R =(U1>=U2);
end


