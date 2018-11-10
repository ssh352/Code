%macro fmreg(dvar, vlist, bvar, inputdata, outputname);
data FMRegData(where=(nmiss eq 0));
	set &inputdata; nmiss=nmiss(of &dvar &vlist);
proc sort data=FMRegData; by &bvar; run;

ods select none;
proc glm data=FMRegData;
        ods output ParameterEstimates=Parm(drop=Dependent Probt Stderr rename=(Parameter=Variable)) fitstatistics=fitstatistics;
	by &bvar;
        model &dvar=&vlist / solution;
run; quit;

proc summary data=Parm nway;
	class Variable;
	output out=Parm2(drop=_type_ rename=(_freq_=N)) mean(Estimate TValue)=estimates MeanT Std(Estimate)=STD;
run;
data clus2dstats2(rename=(PARAM=estimates));
	set Parm2;
	tstat=(estimates*sqrt(N-1))/Std;
	if abs(tstat) ge 1.645 then p='*  ';  if abs(tstat) ge 1.960 then p='** ';  if abs(tstat) ge 2.576 then p='***';
	est=put(estimates, 12.3); param=est; PARAM=compress(est||p); drop estimates;
run;
data coeff; set clus2dstats2(keep=variable estimates); run;
data tstat(drop=tstat rename=(tstat2=estimates)); set clus2dstats2(keep=variable tstat); tstat2=put(tstat, 12.2); tstat2=compress('('||tstat2||')')/*('('||left(tstat2)||')')*/; run;

proc summary data=fitstatistics nway;
	output out=FFFit(drop=_type_ _freq_) mean(RSquare)=Result; run;
data FFIT2(keep=Variable Estimates); retain Variable; set FFFIT; Variable='RSQ'; Result=Result*100; nvalue2=put(Result,12.3);  estimates=left(nvalue2); run;
data both(rename=(Estimates=Est_&outputname));
	set coeff tstat FFIT2;
run;
proc sort data=both out=both_&outputname; by Variable; run;

%mend fmreg;
