program Project1;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

begin
  try
    writeln('Hello World');
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;
end.
