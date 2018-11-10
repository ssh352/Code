%First generate the relevant data variables;
    
    P=data(:,4); %Price per share;
    FROE=data(:,5:16); %ROE forcasts 12 periods out;
    B0 = data(:,19); %Book Value per share in the current period.;
    FB = data(:,20:31); %Forecast of Book per share values 12 periods out;
    PERMNO=data(:,1);
    MYEAR=data(:,3);
    
    %%%Set parameters and initial value;
    t = 12
    capd0 = .03
    coc = zeros(length(P),1);


    for n=1:length(P)
      tic
        display('This is loop')
        display(n)
        coc(n,:) = fsolve(@(capd) CostofCapitalGLS(P(n,:),B0(n,:),FB(n,1:t-1),FROE(n,:),t,capd),capd0);
      toc    
    end
    
    aresults_gls = [PERMNO MYEAR coc];
   save('aresults_gls');
 