function Tends = twaveend(s0, fs, PeakIndxs)
fr = fs/250; 
swin = 32*fr;
N=numel(s0);
ptwin = ceil(4*fr); 
nT = numel(PeakIndxs);
if PeakIndxs(nT)+200 > N
  nT = nT-1;
end
areavalue = zeros(N,1);
Tends = zeros(nT,1);

ald = 0.15;
bld = 37*fr;
alu = 0.7;
blu = -9*fr;
ard = 0.0;
brd = 70*fr;
aru = 0.20;
bru = 101*fr;

for knR=1:nT
  kR=PeakIndxs(knR);
  
  if (knR<length(PeakIndxs))
    RRk = PeakIndxs(knR+1)- kR;
  else
    RRk = 200*fr;
  end
     
  if RRk<220*fr
    
    minRtoT = floor(ald*RRk+bld); 
    maxRtoT = ceil(alu*RRk+blu);
      
  else
    minRtoT = floor(ard*RRk+brd); 
    maxRtoT = ceil(aru*RRk+bru);
  end
  
  leftbound = kR+minRtoT;
  rightbound = kR+maxRtoT;
    
  rightbound = min(rightbound, N-ptwin);
  leftbound = min(leftbound, rightbound);
  
  if knR<length(PeakIndxs) & rightbound>PeakIndxs(knR+1)
     rightbound = PeakIndxs(knR+1);
  end
      s=s0';
  % Compute the area indicator
  for kT=leftbound:rightbound
    %cutlevel = mean(s((kT-ptwin):(kT+ptwin)));
    cutlevel = sum(s((kT-ptwin):(kT+ptwin)),1)/(ptwin*2+1);
    corsig = s(ceil(kT-swin+1):kT) -  cutlevel;
    areavalue(kT) = sum(corsig,1);
  end
  Tval = areavalue(leftbound:rightbound);
  mthrld=1;
  if isnumeric(mthrld) | mthrld(1)=='p'
    [dum, maxind] = max(Tval);
  end
  if isnumeric(mthrld) | mthrld(1)=='n'
    [duminv, maxindinv] = max(-Tval);
  end
  
  if ischar(mthrld)
    if mthrld(1)=='n'
      maxind = maxindinv;
      dum = duminv;
    end
  else  
    if maxind<maxindinv
      leftind = maxind;
      rightind = maxindinv;
      leftdum = dum;
      rightdum = duminv;
    else
      leftind = maxindinv;
      rightind = maxind;
      leftdum = duminv;
      rightdum = dum;
    end
  
    if leftdum>mthrld*rightdum 
      maxind = leftind;
      dum = leftdum;
    else
      maxind = rightind;
      dum = rightdum;
    end
  end
 
  Tends(knR) = maxind + leftbound - 1;
end

