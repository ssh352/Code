time = (1992:0.25:2014.5)';
%Start and end dates of sample period to use
t0 = 1992; t1 = 2013.75;
%Private 
y = [88167	90023	90869	91002
89547	91761	93012	93465
92188	94889	96407	97010
95737	97924	98995	99243
97632	100177	101488	101892
100496	103173	104422	105056
103625	106206	107360	107799
106278	108865	110037	110550
108980	111350	112255	112335
110214	111618	111589	110404
107773	109401	109769	109515
107166	108879	109397	109496
107685	110361	111100	111365
109558	112294	113326	113624
112136	114625	115403	115532
113712	116021	116602	116537
114134	115549	115357	113602
108997	109007	108671	108037
105618	107865	108675	108981
107126	109833	110795	111267
109824	112257	113080	113574
111960	114521	115515	116018
114224	116933	118087 NaN]';
y=log(y(:));


ind0 = find(time == t0);
ind1 = find(time == t1);

y = y(ind0:ind1);
time = time(ind0:ind1);
Tq = length(y);
Ty = ceil(Tq/4);


timetrend = (1:Tq)';
const = ones(Tq,1);
SeasDumMat = kron(ones(Ty,1),eye(4));
SeasDumMat = SeasDumMat(1:Tq,:);
SeasDumMatTrunc = SeasDumMat(:,1:3);



%Seasonal adjustment version 1 (levels)
X = [const timetrend SeasDumMatTrunc];
BetaOLS = regress(y,X);
BetaSeas = [BetaOLS(3:5) ; 0] - sum(BetaOLS(3:5))/4;
ySA1 = y - SeasDumMat*BetaSeas;





%Seasonal adjustment version 2 (differences)
X = [const SeasDumMatTrunc];
BetaOLS2 = regress(diff(y),X(2:end,:));
BetaSeas2 = [BetaOLS2(2:4) ; 0] - sum(BetaOLS2(2:4))/4;
ySA2 = NaN(Tq,1);
ySA2(1) = y(1);
for ttt=2:Tq
ySA2(ttt) = ySA2(ttt-1) + (y(ttt)-y(ttt-1)) - SeasDumMat(ttt,:)*BetaSeas2;
end
ySA2 = ySA2 - mean(ySA2) + mean(y);



%Seasonal adjustment version 3 (levels), uses equation (8) of William H. Greene and Terry G. Seaks
%The Restricted Least Squares Estimator: A Pedagogical Note
%Source: The Review of Economics and Statistics, Vol. 73, No. 3 (Aug., 1991), pp. 563-567
X = [const timetrend SeasDumMat];
R = [0 0 1 1 1 1];
r = 0;
XX = X'*X;
XXtilda = [[XX R']; [ R 0]];
bstarlambda = XXtilda\[X'*y ; r];
BetaRLS = bstarlambda(1:end-1);
BetaSeas3 = BetaRLS(3:end);
ySA3 = y - SeasDumMat*BetaSeas3;





figure;
subplot(2,1,1);
plot(time,[ySA1 ySA2 ySA3 y]);
grid on;
title('Log-Levels');
legend('ySA1','ySA2','ySA3','yNSA');
subplot(2,1,2);
plot(time(2:end),100*diff([ySA1 ySA2 ySA3]));
grid on;
title('Log-Differences times 100');
legend('ySA1','ySA2','ySA3');
