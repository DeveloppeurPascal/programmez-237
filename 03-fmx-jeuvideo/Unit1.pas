unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects;

type
  TForm1 = class(TForm)
    btnJouer: TButton;
    Timer1: TTimer;
    lblScore: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnJouerClick(Sender: TObject);
  private
    FScore: integer;
    FJeuOnOff: boolean;
    procedure SetJeuOnOff(const Value: boolean);
    procedure SetScore(const Value: integer);
    { Déclarations privées }
    procedure aniDebutVersFin(Sender: TObject);
    procedure aniFin(Sender: TObject);
    procedure clickOK(Sender: TObject);
    procedure clickKO(Sender: TObject);
  public
    { Déclarations publiques }
    property Score: integer read FScore write SetScore;
    property JeuOnOff: boolean read FJeuOnOff write SetJeuOnOff;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

Uses Radiant.Shapes, FMX.Ani;

procedure TForm1.aniDebutVersFin(Sender: TObject);
var
  Ani: tfloatanimation;
begin
  Ani := Sender as tfloatanimation;
  Ani.Stop;
  Ani.StartValue := 1;
  Ani.StopValue := 0;
  Ani.Delay := random(500) / 50;
  Ani.Duration := random(20) / 10;
  Ani.OnFinish := aniFin;
  Ani.Start;
end;

procedure TForm1.aniFin(Sender: TObject);
var
  Ani: tfloatanimation;
begin
  Ani := Sender as tfloatanimation;
  Ani.Stop;
  Ani.Parent.Free;
end;

procedure TForm1.btnJouerClick(Sender: TObject);
begin
  JeuOnOff := true;
end;

procedure TForm1.clickKO(Sender: TObject);
begin
  Score := Score - 1;
  Freeandnil(Sender);
  if (Score < 1) then
  begin
    showmessage('perdu');
    JeuOnOff := false;
  end;
end;

procedure TForm1.clickOK(Sender: TObject);
begin
  Score := Score + 5;
  Freeandnil(Sender);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Score := 0;
  JeuOnOff := false;
end;

procedure TForm1.FormHide(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

procedure TForm1.SetJeuOnOff(const Value: boolean);
var
  elem: tcomponent;
  i: integer;
begin
  if (FJeuOnOff <> Value) then
  begin
    if Value then
      Score := 0;
    for i := 0 to ComponentCount - 1 do
    begin
      elem := components[i];
      if (elem is TRadiantTriangle) then
        (elem as TRadiantTriangle).HitTest := Value
      else if (elem is TRadiantCircle) then
        (elem as TRadiantCircle).HitTest := Value
      else if (elem is TRadiantRing) then
        (elem as TRadiantRing).HitTest := Value;
    end;
  end;
  FJeuOnOff := Value;
  btnJouer.Visible := not FJeuOnOff;
end;

procedure TForm1.SetScore(const Value: integer);
begin
  FScore := Value;
  lblScore.Text := 'Score : ' + FScore.ToString;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Triangle: TRadiantTriangle;
  Circle: TRadiantCircle;
  Ring: TRadiantRing;
  couleur: TAlphaColor;
  event: TNotifyEvent;

  procedure ajouteAnimation(AOwner: TFMXObject);
  var
    aniDebut: tfloatanimation;
  begin
    aniDebut := tfloatanimation.Create(AOwner);
    aniDebut.Parent := AOwner;
    aniDebut.PropertyName := 'Opacity';
    aniDebut.StartValue := 0;
    aniDebut.StopValue := 1;
    aniDebut.Delay := random(100) / 50;
    aniDebut.Duration := random(20) / 10;
    aniDebut.OnFinish := aniDebutVersFin;
    aniDebut.Start;
  end;

begin
  case random(7) of
    0:
      couleur := talphacolors.Red;
    1:
      couleur := talphacolors.Green;
    2:
      couleur := talphacolors.Blue;
    3:
      couleur := talphacolors.Yellow;
    4:
      couleur := talphacolors.Violet;
    5:
      couleur := talphacolors.Orange;
    6:
      couleur := talphacolors.Darkgray;
  end;
  if couleur = talphacolors.Green then
    event := clickOK
  else
    event := clickKO;
  case random(3) of
    0:
      begin
        Triangle := TRadiantTriangle.Create(Self);
        Triangle.Parent := Self;
        Triangle.Position.X := random(width);
        Triangle.Position.Y := random(height);
        Triangle.opacity := 0;
        Triangle.Fill.color := couleur;
        Triangle.OnClick := event;
        Triangle.HitTest := JeuOnOff;
        ajouteAnimation(Triangle);
      end;
    1:
      begin
        Circle := TRadiantCircle.Create(Self);
        Circle.Parent := Self;
        Circle.Position.X := random(width);
        Circle.Position.Y := random(height);
        Circle.opacity := 0;
        Circle.Fill.color := couleur;
        Circle.OnClick := event;
        Circle.HitTest := JeuOnOff;
        ajouteAnimation(Circle);
      end;
    2:
      begin
        Ring := TRadiantRing.Create(Self);
        Ring.Parent := Self;
        Ring.Position.X := random(width);
        Ring.Position.Y := random(height);
        Ring.opacity := 0;
        Ring.Fill.color := couleur;
        Ring.OnClick := event;
        Ring.HitTest := JeuOnOff;
        ajouteAnimation(Ring);
      end;
  end;
end;

initialization

randomize;

end.
