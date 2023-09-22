clc;
clear all;
SNR=0:1:50;                 %�H�����ܤƽd��
SNR1=0.5*(10.^(SNR/10));    %?�H������Ʀ������y��
N=1000000;                  %��u�I��
X=4;                        %�i���?
x=randi([0,1],1,N);         %�����H���H��
R=raylrnd(0.5,1,N);         %���ͷ�Q�H��
h=pskmod(x,X);              %�ե�matlab�۱a��psk�ը���
hR=h.*R;
for i=1:length(SNR)
    yAn=awgn(h,SNR(i),'measured');
    yA=pskdemod(yAn,X);%QPSK�ݩ�4PSK
    [bit_A,l]=biterr(x,yA);
    QPSK_s_AWGN(i)=bit_A/N;

    yRn=awgn(hR,SNR(i),'measured');
    yR=pskdemod(yRn,X);%�ե�matlab�۱a��psk�ѽը��?
    [bit_R,ll]=biterr(x,yR);
    QPSK_s_Ray(i)=bit_R/N;
end
QPSK_t_AWGN=1/2*erfc(sqrt(10.^(SNR/10)/2));   %AWGN�H�D�UQPSK�z�׻~�X�v
QPSK_t_Ray= -(1/4)*(1-sqrt(SNR1./(SNR1+1))).^2+(1-sqrt(SNR1./(SNR1+1)));
%Rayleigh�H�D�UQPSK�z�׻~�X�v

%ø�s�ϧ�
figure
semilogy(SNR,QPSK_s_Ray,'-k.');grid on;
axis([-1 50 10^-3 1]);
title('MIMO-OFDM analyze');
xlabel('SNR(dB)');ylabel('BER');