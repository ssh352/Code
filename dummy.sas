%macro dummy(dsn = , var = , prefix = ) ;
proc summary data = &dsn nway ;
class &var ;
output out = x ( keep = &var ) ;
proc print ;
*;
data _null_ ;
set x nobs=last ;
if _n_ = 1 then call symput ( 'num',
trim(left(put( last, best. ) ) ) ) ;
call symput ( 'c' || trim ( left (
put ( _n_, best. ) ) ),trim ( left
( &var ) ) ) ;
run ;
data &dsn ;
set &dsn nobs=last;
array ct ( &num ) %do k=1 %to
&num ;
&prefix&&c&k
%end ; ;
%do i = 1 %to &num ;
select;
when (&var="&&c&i" ) ct(&i)=1;
otherwise ct(&i)=0;
end;
%end;
run ;
%mend dummy;

