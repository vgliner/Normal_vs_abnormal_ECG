function y = medfilt1m( x, r, z )

if(nargin<3 || isempty(z)), z=NaN; end; x=x(:)'; n=length(x);
if(isnan(z)), valid=~isnan(x); else valid=x~=z; end; v=sum(valid);
if(v==0), y=repmat(z,1,n); return; end
if(v<2*r+1), y=repmat(median(x(valid)),1,n); return; end
y=medfilt1(x(valid),2*r+1);

C=[0 cumsum(valid)]; s=2*r+1; R=find(C==s); R=R(1)-2; pos=zeros(1,n);
for j=1:n, R0=R;
  R=R0-1; a=max(1,j-R); b=min(n,j+R);
  if(C(b+1)-C(a)<s), R=R0; a=max(1,j-R); b=min(n,j+R);
    if(C(b+1)-C(a)<s), R=R0+1; a=max(1,j-R); b=min(n,j+R); end
  end
  pos(j)=(C(b+1)+C(a+1))/2;
end
y=y(floor(pos));

end
function y = medfilt1( x, s )
n=length(x); r=floor(s/2); indr=(0:s-1)'; indc=1:n;
ind=indc(ones(1,s),1:n)+indr(:,ones(1,n));
x0=x(ones(r,1))*0; X=[x0'; x'; x0'];
X=reshape(X(ind),s,n); y=median(X,1);
end

