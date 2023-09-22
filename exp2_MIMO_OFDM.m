
clc;
clear all;

Num_ant=8+1;                %�ѽu�ӼơA�@�ڥΨӶi��H�D���p
L=10;						%�H�D���n����
MC=1000;
SNRdB=0:2:50;
NO=10.^(SNRdB/20);
tx_msg='MIMO-OFDM Communication Systems Simulink';
tx_bs=text2bit(tx_msg);
tx_bs_enc=block_encode(tx_bs);				%�H�D�s�X
tx_bs_QPSK=QPSK_mapper(tx_bs_enc);          %QPSK�ջs
tx_bs_frame=framemodify(tx_bs_QPSK);
x=tx_bs_frame.'*ones(1,Num_ant-1);
Rs=randi([0,1],1024,1)*2-1;
d=[Rs,x];
s=ifft(d,1024,1);                               %�@��N�I�f�ť߸��ܴ�
s=[s(end-127:end,:);s];                         %�K�[�`���e��
s=s(:);											%��x�}�i���@�C
s=s.';											%��x�}�ܦ��@��
BER=zeros(1,MC);
Pe0=zeros(1,length(N0));
for snr=1:length(N0)
	for mc=1:MC
	
	%�H�D
	h=(randn(1,L)+li*randn(1,L))/sqrrt(2);		%���ͷ�Q�I��H�D;
	%plot(abs(fft(h,1024)),'r');
	r=N0(snr)*conv(h,s)+(randn(1,(1024+128)*Num_ant+L-1)+li*randn(1,(1024+128)*Num_ant+L-1))/sqrt(2);
	
	%OFDM�ѽ�
	r=reshape(r(1:lengh(s)),1024+128,Num_ant);
	r=r(129:end,:);			%�h�`���e��
	r=fft(r,1024,1);		%�ť߸��ܴ��ѽ�
	
	%���ž�
	h=r(:,1)./Rs;				%�H�D���p
	rx_d=r(:,2:Num_ant);		%�h���Ĥ@�C�ƾ�
	rx_d=rx_d./(h*ones(1,Num_ant-1));
	
	%Ķ�X
	x_d=((real(rx_d)>0)-0.5)*sqrt(2)+li*((imag(rx_d)>0)-0.5)*sqrt(2);
	rx_bs_frame=x_d(:,2);
	rx_bs_QRSK=dec_framemodify(rx_bs_frame,length(tx_bs_QRSK));
	rx_bs=QPSK_demapper(rx_bs_QPSK.');
	rx_bs_dec=block_decode(rx_bs);
	BER(mc)=compute_BER_modify(rx_bs_dec,tx_bs);
	
	end
	Pe0(snr)=mean(BER);
end

figure
semilogy(SNRdB,Pe0,'-k*');
grid on;
axis([-1 50 10^-3 1]);
title('MIMO-OFDM analyze');
xlabel('SNR(dB)');ylabel('BER');