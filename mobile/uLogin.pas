unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.TabControl,
  uPrincipal, REST.types, FMX.Ani;

type
  TfrmLogin = class(TForm)
    Rectangle1: TRectangle;
    lblTitulo: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    edtUsuario: TEdit;
    rectLogin: TRectangle;
    Label3: TLabel;
    TabControl: TTabControl;
    tabLogin: TTabItem;
    tabConfig: TTabItem;
    Layout2: TLayout;
    Label4: TLabel;
    edtServidor: TEdit;
    rectSave: TRectangle;
    Label5: TLabel;
    lblConfig: TLabel;
    edtSenha: TEdit;
    Label1: TLabel;
    LayoutCircle: TLayout;
    circle: TCircle;
    AnimationCircle: TFloatAnimation;
    procedure rectLoginClick(Sender: TObject);
    procedure lblConfigClick(Sender: TObject);
    procedure rectSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AnimationCircleFinish(Sender: TObject);
  private
    procedure posicionaObjetos;
    procedure animar;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

uses uDM;

procedure TfrmLogin.AnimationCircleFinish(Sender: TObject);
begin
  AnimationCircle.Inverse := not(AnimationCircle.Inverse);
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmLogin := nil;
end;

procedure TfrmLogin.animar;
begin
  AnimationCircle.Start;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  animar;

  dm.qry_config.Active := false;
  dm.qry_config.SQL.clear;
  dm.qry_config.SQL.add('SELECT * FROM TAB_USUARIO');
  dm.qry_config.Active := true;

  if dm.qry_config.FieldByName('SERVIDOR').AsString <> '' then
  begin
    TabControl.ActiveTab := tabLogin;
    edtServidor.Text := dm.qry_config.FieldByName('SERVIDOR').AsString;
  end
  else
  begin
    lblTitulo.Text := 'Configurações';
    TabControl.ActiveTab := tabConfig;
  end;

end;

procedure TfrmLogin.lblConfigClick(Sender: TObject);
begin
  animar;
  tabControl.GotoVisibleTab(1, TTabTransition.Slide);

  lblTitulo.Text := 'Configurações';
end;

procedure TfrmLogin.rectSaveClick(Sender: TObject);
begin
  animar;

  if edtServidor.text = '' then
  begin
    ShowMessage('Informe o servidor');
    exit;
  end;

  with dm.qry_config do
  begin
    Active := false;
    SQL.clear;
    SQL.add('DELETE FROM TAB_USUARIO');
    ExecSQL;

    Active := false;
    SQL.clear;
    SQL.add('INSERT INTO TAB_USUARIO(SERVIDOR)');
    SQL.add('VALUES(:SERVIDOR)');
    ParamByName('SERVIDOR').value := edtServidor.Text;
    ExecSQL;
  end;

  tabControl.GotoVisibleTab(0, TTabTransition.Slide);

  lblTitulo.Text := 'Acesso';
end;

procedure TfrmLogin.rectLoginClick(Sender: TObject);
var
  erro: string;
begin
  dm.RequestLogin.Client.BaseURL := edtServidor.text;

  if not dm.validaLogin(edtUsuario.text, edtSenha.text, erro) then
  begin
    ShowMessage(erro);
    exit;
  end;

    if not Assigned(frmPrincipal) then
    frmPrincipal := TfrmPrincipal.Create(nil);

  frmPrincipal.Show;

  Application.MainForm := frmPrincipal;

  self.Close;
end;

procedure TfrmLogin.posicionaObjetos;
begin
  if LayoutCircle.Width >= layoutcircle.Height then
  begin
    circle.Width := circle.Width * 1.5;
    circle.Height := circle.Width;
    //circle.Margins.Bottom := circle.Width * 0.30;

    AnimationCircle.PropertyName := 'Margins.Right';
    AnimationCircle.StartValue := circle.Width;
    AnimationCircle.StopValue := -circle.Width;
  end
  else
  begin

  end;

end;

end.
