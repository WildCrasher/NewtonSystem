unit NSInterval;

interface

uses
  IntervalArithmetic32and64, SysUtils, Dialogs, Math;

type
     vector4 = array of interval;
     vector5 = array of interval;
     vector6 = array of Integer;
     vector7 = array of interval;
     fxi      = function (i, n : Integer;
                         x    : vector4) : interval;
     dfxi     = procedure (i, n      : Integer;
                          x         : vector4;
                          var dfatx : vector4);

var
  i, it, mit, n, st : Integer;
  eps               : Extended;
  x                 : vector4;

function iabs ( x : interval) : interval;

function fi (i, n : Integer;
            x    : vector4) : interval;

procedure dfi (i, n      : Integer;
              x         : vector4;
              var dfatx : vector4);

procedure NewtonsysInterval     (n        : Integer;
                            var x     : vector4;
                            f         : fxi;
                            df        : dfxi;
                            mit       : Integer;
                            eps       : Extended;
                            var it,st : Integer);

implementation

procedure NewtonsysInterval (   n         : Integer;
                        var x     : vector4;
                        f         : fxi;
                        df        : dfxi;
                        mit       : Integer;
                        eps       : Extended;
                        var it,st : Integer);

var i,j,jh,k,kh,l,lh,n1,p,q,rh : Integer;
    s,max                      : interval;
    cond                       : Boolean;
    dfatx                      : vector4;
    a,b                        : vector5;
    r                          : vector6;
    x1                         : vector7;
begin
  try
    SetLength( dfatx, n + 1);
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
                                     s:=iabs(s);       //dopytac
                                     if (j<n1) and (s.b>max.a)   //dopytac
                                       then begin
                                              max:=s;
                                              jh:=j;
                                              lh:=l
                                            end
                                   end;
                          if ( max.a = left_read('0') ) and ( max.b = right_read('0') ) //dopytac
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
                                   max:=iabs(x[i]);   //dopytac
                                   s:= iabs(x1[i]);     //dopytac
                                   if max.b < s.a
                                     then max:=s;
                                   if ( max.a <> left_read('0') ) or ( max.b <> right_read('0') )  //dopytac
                                     then if ( interval((iabs(x[i]-x1[i])/max)).b > left_read(FloatToStr(eps)) ) or
                                     ( ( interval((iabs(x[i]-x1[i])/max)).a = left_read(FloatToStr(eps)) ) and ( interval((iabs(x[i]-x1[i])/max)).b = right_read(FloatToStr(eps))) )    //>=
                                            then cond:=false
                                 until (i=n) or not cond;
                                 for i:=1 to n do
                                   x[i]:=x1[i]
                               end
                      end
             until (st<>0) or cond
           end
  except
     showmessage('Dzielenie przez przedzia³ zawieraj¹cy zero. Nie mo¿na dokonaæ dalszych obliczeñ.');
     st := 3;
  end;
end;

function iabs ( x : interval) : interval;
begin
  if abs(x.a) < abs(x.b) then
  begin
    Result.a := abs(x.a);
    Result.b := abs(x.b);
  end
  else
  begin
    Result.a := abs(x.b);
    Result.b := abs(x.a);
  end;
end; //dopytac

function fi (i, n : Integer;
            x    : vector4) : Interval;
begin
    case i of
      1 : fi:=3*x[1]-icos(x[2]*x[3],st)-0.5;
      2 : fi:=isqr(x[1],st)-81*isqr(x[2]+0.1,st)+isin(x[3],st)+1.06;
      3 : fi:=iexp(-x[1]*x[2],st)+20*x[3]+(10*Pi-3)/3
    end
end;

procedure dfi (i, n      : Integer;
              x         : vector4;
              var dfatx : vector4);
begin
  case i of
    1 : begin
          dfatx[1]:=3;
          dfatx[2]:=x[3]*isin(x[2]*x[3],st);
          dfatx[3]:=x[2]*isin(x[2]*x[3],st)
        end;
    2 : begin
          dfatx[1]:=2*x[1];
          dfatx[2]:=-162*(x[2]+0.1);
          dfatx[3]:=icos(x[3],st)
        end;
    3 : begin
          dfatx[1]:=-x[2]*iexp(-x[1]*x[2],st);
          dfatx[2]:=-x[1]*iexp(-x[1]*x[2],st);
          dfatx[3]:=20
        end
  end
end;
  {
function fi (i, n : Integer;
            x    : vector4) : interval;
begin
  case i of
    1 : fi:=isqr(x[1],st)+8*x[2]-16;
    2 : fi:=x[1]-iexp(x[2],st)
  end
end;

procedure dfi (i, n      : Integer;
              x         : vector4;
              var dfatx : vector4);
begin
  case i of
    1 : begin
          dfatx[1]:=2*x[1];
          dfatx[2]:=8
        end;
    2 : begin
          dfatx[1]:=1;
          dfatx[2]:=-iexp(x[2],st)
        end
  end
end;    }



end.
