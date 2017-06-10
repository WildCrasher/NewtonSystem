unit NSNormal;

interface

uses Math;

type
     vector  = array of Extended;
     vector1 = array of Extended;
     vector2 = array of Integer;
     vector3 = array of Extended;
     fx      = function (i, n : Integer;
                         x    : vector) : Extended;
     dfx     = procedure (i, n      : Integer;
                          x         : vector;
                          var dfatx : vector);

function f(i, n : Integer;
                x  : vector): Extended;
procedure df(i, n      : Integer;
                  x      : vector;
              var dfatx  : vector);

procedure Newtonsys     (n        : Integer;
                        var x     : vector;
                        f         : fx;
                        df        : dfx;
                        mit       : Integer;
                        eps       : Extended;
                        var it,st : Integer);

implementation

procedure Newtonsys (   n         : Integer;
                        var x     : vector;
                        f         : fx;
                        df        : dfx;
                        mit       : Integer;
                        eps       : Extended;
                        var it,st : Integer);

var i,j,jh,k,kh,l,lh,n1,p,q,rh : Integer;
    max,s                      : Extended;
    cond                       : Boolean;
    dfatx                      : vector;
    a,b                        : vector1;
    r                          : vector2;
    x1                         : vector3;
begin
  SetLength( dfatx, n + 1 );
  SetLength( a, n + 2);
  SetLength( b, n + 2);
  SetLength( r, n + 2);
  SetLength( x1, Ceil( ( ( n + 2 ) * ( n + 2 ) ) / 4 ));
  if (n<1) or (mit<1)
    then st:=1
    else begin
           st:=0;
           it:=0;
           n1:=n+1;
           repeat
             it:=it+1;
             if it>mit
               then begin
                      st:=3;
                      it:=it-1
                    end
               else begin
                      p:=n1;
                      for i:=1 to n1 do
                        r[i]:=0;
                      k:=0;
                      repeat
                        k:=k+1;
                        df (k,n,x,dfatx);
                        for i:=1 to n do
                          a[i]:=dfatx[i];
                        s:=-f(k,n,x);
                        for i:=1 to n do
                          s:=s+dfatx[i]*x[i];
                        a[n1]:=s;
                        for i:=1 to n do
                          begin
                            rh:=r[i];
                            if rh<>0
                              then b[rh]:=a[i]
                          end;
                        kh:=k-1;
                        l:=0;
                        max:=0;
                        for j:=1 to n1 do
                          if r[j]=0
                            then begin
                                   s:=a[j];
                                   l:=l+1;
                                   q:=l;
                                   for i:=1 to kh do
                                     begin
                                       s:=s-b[i]*x1[q];
                                       q:=q+p
                                     end;
                                   a[l]:=s;
                                   s:=abs(s);
                                   if (j<n1) and (s>max)
                                     then begin
                                            max:=s;
                                            jh:=j;
                                            lh:=l
                                          end
                                 end;
                        if max=0
                          then st:=2
                          else begin
                                 max:=1/a[lh];
                                 r[jh]:=k;
                                 for i:=1 to p do
                                   a[i]:=max*a[i];
                                 jh:=0;
                                 q:=0;
                                 for j:=1 to kh do
                                   begin
                                     s:=x1[q+lh];
                                     for i:=1 to p do
                                     if i<>lh
                                       then begin
                                              jh:=jh+1;
                                              x1[jh]:=x1[q+i]-s*a[i]
                                            end;
                                     q:=q+p
                                   end;
                                 for i:=1 to p do
                                   if i<>lh
                                     then begin
                                            jh:=jh+1;
                                            x1[jh]:=a[i]
                                          end;
                                 p:=p-1
                               end
                      until (k=n) or (st=2);
                      if st=0
                        then begin
                               for k:=1 to n do
                                 begin
                                   rh:=r[k];
                                   if rh<>k
                                     then begin
                                            s:=x1[k];
                                            x1[k]:=x1[rh];
                                            i:=r[rh];
                                            while i<>k do
                                              begin
                                                x1[rh]:=x1[i];
                                                r[rh]:=rh;
                                                rh:=i;
                                                i:=r[rh]
                                              end;
                                            x1[rh]:=s;
                                            r[rh]:=rh
                                          end
                                 end;
                               cond:=true;
                               i:=0;
                               repeat
                                 i:=i+1;
                                 max:=abs(x[i]);
                                 s:=abs(x1[i]);
                                 if max<s
                                   then max:=s;
                                 if max<>0
                                   then if abs(x[i]-x1[i])/max>=eps
                                          then cond:=false
                               until (i=n) or not cond;
                               for i:=1 to n do
                                 x[i]:=x1[i]
                             end
                    end
           until (st<>0) or cond
         end
end;

function f (i, n : Integer;
            x    : vector) : Extended;
begin
  case i of
    1 : f:=3*x[1]-Cos(x[2]*x[3])-0.5;
    2 : f:=Sqr(x[1])-81*Sqr(x[2]+0.1)+Sin(x[3])+1.06;
    3 : f:=Exp(-x[1]*x[2])+20*x[3]+(10*Pi-3)/3
  end
end;

procedure df (i, n      : Integer;
              x         : vector;
              var dfatx : vector);
begin
  case i of
    1 : begin
          dfatx[1]:=3;
          dfatx[2]:=x[3]*Sin(x[2]*x[3]);
          dfatx[3]:=x[2]*Sin(x[2]*x[3])
        end;
    2 : begin
          dfatx[1]:=2*x[1];
          dfatx[2]:=-162*(x[2]+0.1);
          dfatx[3]:=Cos(x[3])
        end;
    3 : begin
          dfatx[1]:=-x[2]*Exp(-x[1]*x[2]);
          dfatx[2]:=-x[1]*Exp(-x[1]*x[2]);
          dfatx[3]:=20
        end
  end
end;
{
function f (i, n : Integer;
            x    : vector) : Extended;
begin
  case i of
    1 : f:=Sqr(x[1])+8*x[2]-16;
    2 : f:=x[1]-Exp(x[2])
  end
end;

procedure df (i, n      : Integer;
              x         : vector;
              var dfatx : vector);
begin
  case i of
    1 : begin
          dfatx[1]:=2*x[1];
          dfatx[2]:=8
        end;
    2 : begin
          dfatx[1]:=1;
          dfatx[2]:=-Exp(x[2])
        end
  end
end;    }

end.
