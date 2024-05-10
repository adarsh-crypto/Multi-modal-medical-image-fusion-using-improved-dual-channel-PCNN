function [F]=Medical_Fusion(A,B)

addpath(genpath('Shearlet_Transform'));


pfilt = 'maxflat';
shear_parameters.dcomp =[3,3,4,4];
shear_parameters.dsize =[8,8,16,16];

%NSST Decomposition

[y1,shear_f1]=nsst_dec2(A,shear_parameters,pfilt);
[y2,shear_f2]=nsst_dec2(B,shear_parameters,pfilt);



Fused=y1;

ALow1= y1{1};
BLow1 =y2{1};

%  Fusion of Low-pass Subbands

Px=[-1 0 1;-1 0 1;-1 0 1];
Py=[-1 -1 -1;0 0 0;1 1 1];
P45=[0 1 1;-1 0 1;-1 -1 0];
P135=[-1 -1 0;-1 0 1;0 1 1];
PD1=conv2(ALow1,Px,'same')+conv2(ALow1,Py,'same')+conv2(ALow1,P45,'same')+conv2(ALow1,P135,'same');
PD2=conv2(BLow1,Px,'same')+conv2(BLow1,Py,'same')+conv2(BLow1,P45,'same')+conv2(BLow1,P135,'same');
MR1=MRE(ALow1);
MR2=MRE(BLow1);
map=((MR1+PD1)>=(MR2+PD2));
Fused{1}=map.*ALow1+~map.*BLow1;  

 
 
        
%Fusion of High-pass Sub-bands
for m=2:length(shear_parameters.dcomp)+1
    temp=size((y1{m}));temp=temp(3);
    for n=1:temp
        Ahigh=y1{m}(:,:,n);
        Bhigh=y2{m}(:,:,n);
        
                AH=abs(Ahigh);
                BH=abs(Bhigh);
                map=IDPCNN(AH,BH);  %Improved Dual Channel PCNN (IDPCNN)
                Fused{m}(:,:,n)=map.*Ahigh+~map.*Bhigh;
        
    end
end


%Inverse NSST Transform
F=nsst_rec2(Fused,shear_f1,pfilt);
        

end








