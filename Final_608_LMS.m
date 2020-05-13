% Designs an FIR filter given a desired frequency response H_des(wi).
% With length L = 8 with Delay value = 3.8258
% 400 discrete points between 0 ~ pi
% The design is judged by the minimun absolute error .

%************************************************************
%   minimize  max |H(wi) - H_des(wi)|    i = 1,2,3,4,5,6,7,8
%************************************************************
% Using LMS
% Fianl optimal value is 0.4485
close all;
clear all;
clc
N = 8;   
D = 3.8258;
for i=1:N
syms (['n',num2str(i)]);
end

m = 50 * N;
w = linspace(-pi, pi, m)';
Hdes = exp(-j*D*w);
A = exp( -j*kron(w,[0:N-1]) );
h = (inv(A' * A) * A') * Hdes


figure(1)
stem([0:N-1],h)
xlabel('n')
ylabel('h(n)')

% plot the frequency response
H = [exp(-j*kron(w,[0:N-1]))]*h;
figure(2)
% magnitude
subplot(2,1,1);
plot(w,20*log10(abs(H)),w,20*log10(abs(Hdes)),'--')
xlabel('w')
ylabel('mag H in dB')
axis([0 pi -30 10])
legend('optimized','desired','Location','SouthEast')
% phase
subplot(2,1,2)
plot(w,angle(H),w,angle(Hdes))
axis([0,pi,-pi,pi])
xlabel('w'), ylabel('phase H(w)')

error_fir = A*h - Hdes;
error = 0;
for i=1:8
    error = error + norm(error_fir(i));
end
error = error / N;