% Designs an FIR filter given a desired frequency response H_des(wi).
% With length L = 8 with Delay value = 3.8258
% 400 discrete points between 0 ~ pi
% The design is judged by the minimun absolute error .

%************************************************************
%   minimize  max |H(wi) - H_des(wi)|    i = 1,2,3,4,5,6,7,8
%************************************************************
% Using CVX
% Final optimal value is +0.520354
n = 8;
m = 50 * n;
w = linspace(-pi, pi, m)';
D = 3.8258;
Hdes = exp(-j*D*w);
A = exp( -j*kron(w,[0:n-1]) );

cvx_begin     %Using CVX to solve SOCP to get optimized filter
    variable h(n,1)
    minimize( max (abs( A*h - Hdes )) )
cvx_end

% check if problem was successfully solved
disp(['Problem is ' cvx_status])
if ~strfind(cvx_status,'Solved')
  h = [];
end

%*********************************************************************
% plotting routines
%*********************************************************************
% plot the FIR impulse reponse
figure(1)
stem([0:n-1],h)
xlabel('n')
ylabel('h(n)')

% plot the frequency response
H = [exp(-j*kron(w,[0:n-1]))]*h;
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