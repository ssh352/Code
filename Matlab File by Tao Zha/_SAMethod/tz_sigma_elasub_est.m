if (1)  
  close all
  clear all
  clc
end
q_m = 12;  %Monthly data.
%******* Copied and pasted from DataRaw_InustryHeavyLight_kc.xlsx.
% 工业总产值:重工业	工业总产值:轻工业
% 国家/地区	中国	中国
% 频率	月, 月	月, 月
% 单位	十亿人民币	十亿人民币
% 数据来源	国家统计局	国家统计局
% 状况	继续	继续
% 代码	3639901 (CBEJ)	3639801 (CBEI)
% 函数说明		
% 开始日期	 3/1992	 3/1992
% 最后日期	 5/2012	 5/2012
% 最新更新时间	1/30/14	1/30/14
dataraw_grossoutput = [
   114.560	100.970
   125.080	107.800
   130.130	107.770
   139.190	112.440
   130.230	102.330
   133.540	103.710
   139.280	111.790
   144.960	116.580
   148.290	122.550
   164.760	137.550
   132.000	100.050
   152.910	112.590
   187.070	132.940
   193.170	136.230
   204.930	141.110
   224.580	152.110
   203.620	134.830
   203.470	136.650
   201.490	140.770
   198.560	144.060
   208.000	154.180
   239.080	192.170
   196.310	147.180
   174.777	124.404
   235.208	171.592
   245.618	181.671
   260.105	191.782
   276.112	205.319
   242.903	182.614
   245.938	188.627
   255.340	202.671
   263.789	208.791
   272.141	226.858
   313.686	263.603
   233.120	188.800
   229.620	187.140
   294.970	238.880
   304.140	246.730
   314.400	252.060
   328.600	265.570
   297.030	232.150
   298.200	231.410
   306.340	247.790
   313.100	256.690
   325.250	277.950
   365.550	321.000
   263.470	213.900
   231.130	179.120
   297.910	236.970
   306.670	246.960
   317.600	248.340
   334.470	264.850
   295.200	230.610
   289.720	227.630
   303.450	244.180
   311.600	251.920
   320.150	272.360
   358.030	309.450
   281.844	232.112
   246.071	192.829
   328.339	258.733
   333.778	264.546
   342.148	268.616
   361.062	288.237
   315.627	243.203
   312.934	246.496
   332.793	267.504
   336.934	278.747
   351.625	299.523
   386.803	329.949
   257.840	217.262
   255.079	213.245
   321.471	261.966
   322.973	258.732
   331.700	260.645
   344.548	273.546
   304.692	241.154
   311.624	245.091
   333.070	275.873
   342.497	284.470
   356.399	294.249
   388.942	318.287
   574.250	352.750
   571.080	316.940
   711.830	384.390
   722.150	398.240
   720.600	398.600
   786.000	441.730
   750.030	400.830
   769.410	411.650
   806.120	444.380
   816.960	451.050
   855.880	484.050
   940.870	526.950
   732.240	393.420
   846.280	429.600
   995.350	487.080
   1011.830	502.100
   996.500	499.750
   1055.610	543.220
   994.940	505.980
   1034.330	520.540
   1097.640	560.010
   1115.320	560.920
   1162.480	579.690
   1260.980	635.710
   1137.205	541.247
   1057.562	465.969
   1317.165	584.122
   1368.687	610.258
   1383.838	619.743
   1494.966	689.929
   1405.099	631.746
   1445.230	646.819
   1511.267	695.065
   1519.209	702.084
   1595.902	730.718
   1736.171	808.399
   1103.008	538.927
   1382.233	596.440
   1691.225	726.512
   1743.439	744.640
   1802.191	768.381
   1990.862	862.170
   1841.177	775.006
   1877.234	793.285
   1976.730	853.178
   1958.117	833.599
   2050.520	878.118
   2212.075	947.633
   1914.372	833.947
   1688.354	692.699
   2158.470	902.173
   2237.126	921.402
   2315.042	965.954
   2586.977	1103.891
   2355.178	977.820
   2395.987	993.859
   2552.343	1082.869
   2535.284	1051.614
   2647.702	1106.739
   2858.283	1194.919
   2414.164	1032.608
   2185.007	851.445
   2852.034	1146.845
   2930.868	1139.987
   3045.506	1194.835
   3410.031	1355.457
   3150.026	1199.321
   3122.254	1213.481
   3193.142	1299.919
   2935.081	1232.664
   2782.445	1245.848
   2935.282	1309.029
   2146.236	990.245
   2296.207	989.073
   2912.499	1243.686
   2934.933	1238.583
   3111.356	1309.518
   3518.500	1503.199
   3283.449	1335.750
   3360.491	1376.822
   3563.355	1503.615
   3507.536	1452.612
   3666.591	1525.207
   3956.880	1619.133
   3359.540	1384.640
   2988.430	1147.340
   3962.690	1562.830
   4037.500	1581.600
   4204.260	1661.060
   4500.560	1840.560
   4105.450	1662.900
   4230.480	1717.270
   4475.540	1897.340
   4442.130	1845.920
   4702.310	1954.100
   5065.940	2089.280
   4091.430	1647.320
   3760.800	1390.930
   4976.120	1874.310
   4930.640	1858.580
   5098.510	1977.320
   5649.970	2221.550
   5142.420	1985.340
   5239.320	2050.680
   5517.920	2239.450
   5348.880	2161.840
   5492.650	2252.940
   5832.470	2384.830
   4173.730	1720.550
   4744.960	1840.400
   5636.090	2197.590
   5342.400	2071.430
   5496.140	2148.570
];		
logY = log(dataraw_grossoutput);
		
mdates_nobreak = [(1992+2/12):(1/12):(2012+4/12)]';
mdates = [(1992+2/12):(1/12):(1998+11/12), (2003):(1/12):(2012+4/12)]';
nobs = size(dataraw_grossoutput,1);
if (length(mdates)~=nobs)
   error('Checking the length of mdates to match the data');
end   
%loc_breakdate = 83;  %Mannually counting by printing out [[1:length(mdates)]', mdates]
loc_breakdate = find(mdates==(2003));

if (1)
   figure;
   subplot(2,1,1);
   plot(mdates, dataraw_grossoutput);
   legend('Heavy','Light');
   title('Gross output (NSA)');
   subplot(2,1,2);
   plot(mdates, dataraw_grossoutput(:,1)./dataraw_grossoutput(:,2));
   title('Ratio of heavy to light gross output (SA)');
end

%=================================================
%========== Seasonally adjusted series ===========
%=================================================
%---$$## Setup 
Tm1 = find(mdates_nobreak==(1998+11/12)); 
Tm2 = find(mdates_nobreak==(2003)); 
Tm = length(mdates_nobreak);  
timetrend = [1:Tm1, Tm2:Tm]';
constterm = ones(nobs,1);
nyears_max = ceil(nobs/q_m);
SeasDumMat = kron(ones(nyears_max,1),eye(q_m));
SeasDumMat = SeasDumMat(3:(size(SeasDumMat,1)-7),:); %$$##
SeasDumMatTrunc = SeasDumMat(:,1:(q_m-1));
%--- Seasonally adjusting
Xright = [constterm timetrend SeasDumMatTrunc];
yleft = logY(:,1);
BetaOLS = regress(yleft,Xright);
BetaSeas = [BetaOLS(3:end) ; 0] - sum(BetaOLS(3:end))/q_m;
yleftSA = yleft - SeasDumMat*BetaSeas;
logheavy = yleftSA;

if (1)
   figure;
   %subplot(3,1,1);
   plot(mdates, [logheavy, logY(:,1)]);
   legend('SA','NA');
   title('Heavy gross output');
   print -dpdf  outfig_try.pdf
end



return;		
		
		
		
		
		


%1.  Industry identifier
%2.  capital/labor ratio 1 (TotalAssets/Employment)
%3.  capital/labor ratio 2 (Equity/Employment)
%4.  capital/labor ratio 3 (NetValueFixedInvest/Employment) (%)
%5.  rank by K/L1		
%6.  rank by K/L2		
%7.  rank by K/L3		
%8.  Gross Output Value		
%9.  Value added of industry				
%10. SOE share in industries (net value of fixed investment)
%11. SOE share in industries (revenue)		
%12. SOE share in industries (profit)		
%13. SOE share in industries (labor)		









SOE_KLraw = [
  1    17.33007033	6.893016306	741.46 	30	30	23	1235.97453	565.01581	0.947959398	0.81721203	1.411846384
  2    72.09425529	47.20231366	4824.99 	4	2	2	2084.89169	1438.4502	0.997446862	0.997967322	0.997952097
  3    20.07387141	9.844049248	591.35 	27	20	30	147.12705	53.04464	0.751208828	0.415870842	0.009891801
  4    17.92103935	8.050454087	661.96 	28	28	24	361.51971	126.04519	0.808483499	0.469271546	0.223938203
  5    17.43425682	7.495382586	759.15 	29	29	22	341.65889	118.35686	0.794232777	0.337765134	-0.275062937
  7    25.37418138	9.432860062	837.11 	19	22	19	3516.99677	761.86315	0.596331561	0.426426952	-3.698977037
  8    24.66997008	10.43633134	863.29 	21	18	18	1262.19227	344.55149	0.415821157	0.325503897	0.328278207
  9    37.97237817	16.96137435	1351.28 	14	11	11	1658.70477	585.77517	0.565755246	0.567440185	0.768017078
  10    149.4595935	93.2761527	3068.17 	1	1	4	1390.77071	892.05255	0.966291213	0.978521693	0.990478215
  11    16.71606056	6.172817628	607.40 	31	32	29	4529.81729	1117.11516	0.500936631	0.357366575	-0.558177111
  12    8.650783738	3.763005058	231.30 	36	35	35	2038.58728	505.97118	0.139434972	0.07320159	0.028048397
  13    9.179769104	3.69362287	225.73 	34	36	36	1197.92772	283.61168	0.184468104	0.054073021	-0.080787831
  14    15.06174957	6.562464265	609.23 	32	31	28	560.58243	132.89323	0.461585962	0.168966553	-0.274217325
  15    14.57510892	6.172191703	441.54 	33	33	33	318.3753	77.95628	0.187224242	0.081067078	-0.012554026
  16    31.58527493	12.19012116	1334.82 	15	15	12	1327.72741	355.55774	0.449741551	0.301538862	0.140505492
  17    24.84244581	11.6146878	960.47 	20	16	16	578.7574	197.93752	0.574828912	0.418162806	0.366716705
  18    9.095212709	4.117496535	249.08 	35	34	34	555.73983	140.20489	0.15455518	0.088404435	0.086466693
  19    76.1157341	35.17551411	3627.39 	3	4	3	2705.57905	590.24197	0.92438648	0.895409488	0.592679248
  20    38.3913071	16.68326681	1497.63 	13	12	10	4924.77764	1216.88385	0.761970918	0.53449717	-0.004926985
  21    40.48628808	19.09602565	1158.68 	12	9	13	1497.21998	514.86433	0.631791697	0.588858564	0.537390235
  22    51.26790794	20.73752263	2274.11 	8	8	7	975.27636	252.54643	0.71352037	0.574032105	0.508509873
  23    24.63901761	9.342137782	828.17 	22	23	20	780.30075	202.60647	0.501579259	0.360876949	-0.649934562
  24    22.80571616	9.970696452	770.66 	23	19	21	1623.40996	387.79628	0.246189592	0.135217958	0.077473461
  25    21.50376974	8.478818242	883.67 	25	26	17	3394.63641	1004.60314	0.502555253	0.350541976	-0.196888824
  26    56.6128008	23.07781476	2077.45 	6	7	8	4097.35531	1081.15324	0.903741601	0.76233889	0.491166489
  27    43.33872642	15.17087731	1568.35 	10	14	9	1793.14165	405.04222	0.755538778	0.538027088	0.288486723
  28    20.9489013	8.210762566	569.11 	26	27	31	2215.09088	540.7183	0.261021592	0.148325138	0.00078098
  29    26.0621676	9.267155273	617.69 	17	24	27	2693.90487	743.61468	0.625071944	0.445597372	0.03699365
  30    25.91713288	9.075742361	657.30 	18	25	25	1980.70927	515.72838	0.699308558	0.474709041	-0.246846653
  31    41.95358495	16.59857091	1013.57 	11	13	15	4659.31103	1193.14189	0.804611975	0.696739253	0.61394005
  32    29.608601	11.52061493	644.42 	16	17	26	4021.55093	1002.57376	0.390513519	0.233005259	0.127171093
  33    45.28290342	17.37621476	1049.99 	9	10	14	5830.96054	1347.95264	0.465749614	0.424228627	0.392013891
  34    22.8051832	9.544235925	519.07 	24	21	32	705.7281	180.46103	0.548974521	0.259847784	-0.092224466
  37    114.0953276	41.05641926	7277.50 	2	3	1	3996.90722	2161.81582	0.875674088	0.903370953	0.86249246
  38    62.2926156	32.83436853	2986.75 	5	5	5	131.27405	36.64043	0.961678754	0.848127874	1.007206484
  39    53.68810497	29.40804474	2889.93 	7	6	6	314.95437	146.31655	0.943485464	0.892891853	0.848391669
];
%1.  Industry identifier
%2.  capital/labor ratio 1 (TotalAssets/Employment)
%3.  capital/labor ratio 2 (Equity/Employment)
%4.  capital/labor ratio 3 (NetValueFixedInvest/Employment) (%)
%5.  rank by K/L1		
%6.  rank by K/L2		
%7.  rank by K/L3		
%8.  Gross Output Value		
%9.  Value added of industry				
%10. SOE share in industries (net value of fixed investment)
%11. SOE share in industries (revenue)		
%12. SOE share in industries (profit)		
%13. SOE share in industries (labor)	
denom = 100;	
nSample = size(SOE_KLraw,1);
valindus = SOE_KLraw(:,9);
KLratio = SOE_KLraw(:,4)/denom;
SOEshare = SOE_KLraw(:,10);

w4industries = valindus ./ sum(valindus); %weights
disp(' ');
disp('Weights by value added');
w4industries*100

disp(' ');
disp('**** Ranks by K/L ****');
SOE_KLraw(:,7)

disp('**** Unweighted correlation between KL ratio and SOEshare: ****');
corr(KLratio,SOEshare)
disp('**** Weighted correlation between KL ratio and SOEshare by value added: ****');
corr(w4industries.*KLratio, w4industries.*SOEshare)

figure;
plot(w4industries);
title('Weights for the industries.');

figure;
scatter(KLratio,SOEshare);
xlabel('Capital-labor ratio');
ylabel('SOE share (%)');


%=============== Plotting bar graphs and scatter.
sort_column = 4; %9.  Value added of industry %4.  capital/labor ratio 3 (NetValueFixedInvest/Employment) (%)
[~,indx_sort] = sort(SOE_KLraw(:,sort_column), 'ascend');
SOE_KLrawSortByKLRatio = SOE_KLraw(indx_sort,:);
SOEShareSortByKLRatio = SOE_KLrawSortByKLRatio(:,[1, 10, 4]);  %Identifier, SOE share, and K/L.
sort_column = 9; %9.  Value added of industry %4.  capital/labor ratio 3 (NetValueFixedInvest/Employment) (%)
[~,indx_sort2] = sort(SOE_KLraw(:,sort_column), 'descend');
SOE_KLrawSortByKLRatio2 = SOE_KLraw(indx_sort2,:);
SOEShareSortByKLRatio2 = SOE_KLrawSortByKLRatio2(:,[1, 10, 4]);  %Identifier, SOE share, and K/L.

nTop = 10; %floor(nSample*(1/4));
%--- Running quadratic regression
Yleft = SOEShareSortByKLRatio2(1:nTop,2).*100;
Xright = [ones(nTop,1), SOEShareSortByKLRatio2(1:nTop,3)/denom, (SOEShareSortByKLRatio2(1:nTop,3)/denom).^2];
Bcoefs = regress(Yleft,Xright);
XYfitted = [SOEShareSortByKLRatio2(1:nTop,3)/denom, Xright * Bcoefs];
[~,indx_sort_fitted] = sort(XYfitted(:,1),'ascend');

figure;
subplot(1,2,1);
barsize = 0.5;
barh(SOEShareSortByKLRatio(:,2).*100, barsize, 'r');
ylabel('Industry identifier');
xlabel('SOE share (%)');
ylim([0 nSample+1]);
set(gca,'YTick',1:1:nSample);
set(gca,'YTickLabel',num2cell(SOEShareSortByKLRatio(:,1)))
grid;
subplot(1,2,2);
symbolsize = 100;
h1 = scatter(SOEShareSortByKLRatio2(1:nTop,3)/denom, SOEShareSortByKLRatio2(1:nTop,2).*100,symbolsize,'o','MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none');
hold on;
symbolsize = 50;
h2 = scatter(SOEShareSortByKLRatio2((nTop+1):nSample,3)/denom, SOEShareSortByKLRatio2((nTop+1):nSample,2).*100,symbolsize,'s','MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor','none');
plot(XYfitted(indx_sort_fitted,1),XYfitted(indx_sort_fitted,2),'m-','LineWidth',1.2);
hold off;
%xlim([0 round(max(SOEShareSortByKLRatio2(:,3)))+1]);
%xlim([0 80]);
xlabel('Capital-labor ratio');
ylabel('SOE share (%)');
legend([h1,h2],{'Large value added','Small value added'},'Location','SouthEast');
print -depsc2 outfigpaper_soe_kl_industries1999.eps 
print -dpdf   outfigpaper_soe_kl_industries1999.pdf 

