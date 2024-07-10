unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.TabControl,
  uPrincipal, REST.types, FMX.Ani, StrUtils;

type
  TfrmLogin = class(TForm)
    layLogin: TLayout;
    Label2: TLabel;
    edtSenha: TEdit;
    rectLogin: TRectangle;
    Label3: TLabel;
    TabControl: TTabControl;
    tabLogin: TTabItem;
    tabConfig: TTabItem;
    layServidor: TLayout;
    Label4: TLabel;
    edtServidor: TEdit;
    rectSave: TRectangle;
    Label5: TLabel;
    lblConfig: TLabel;
    edtUsuario: TEdit;
    Label1: TLabel;
    LayoutCircle: TLayout;
    circle: TCircle;
    AnimationCircle: TFloatAnimation;
    layContainerLogin: TLayout;
    layContainerServidor: TLayout;
    rectEdtUsuario: TRectangle;
    rectEdtSenha: TRectangle;
    procedure rectLoginClick(Sender: TObject);
    procedure lblConfigClick(Sender: TObject);
    procedure rectSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AnimationCircleFinish(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    procedure posicionaObjetos;
    procedure animar;
    procedure resizeContainerInfosLogin(playContainer: TLayout; pintMarginValue: integer);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

uses uDM, utils;

procedure TfrmLogin.AnimationCircleFinish(Sender: TObject);
begin
  AnimationCircle.Inverse := not(AnimationCircle.Inverse);
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmLogin := nil;
end;

procedure TfrmLogin.FormResize(Sender: TObject);
begin
  resizeContainerInfosLogin(IfThenn(TabControl.ActiveTab = tabconfig, layContainerServidor, layContainerLogin), self.Height div 2 - 110);
  posicionaObjetos;
end;

procedure TfrmLogin.animar;
begin
  AnimationCircle.Start;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  LayoutCircle.BringToFront;
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
    TabControl.ActiveTab := tabConfig;
  end;

end;

procedure TfrmLogin.lblConfigClick(Sender: TObject);
begin
  animar;

  resizeContainerInfosLogin(layContainerServidor, self.Height div 2);
  tabControl.GotoVisibleTab(1, TTabTransition.Slide);
end;

procedure TfrmLogin.rectSaveClick(Sender: TObject);
begin
  resizeContainerInfosLogin(IfThenn(TabControl.ActiveTab = tabconfig, layContainerLogin, layContainerLogin), self.Height div 2 - 110);
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

procedure TfrmLogin.resizeContainerInfosLogin(playContainer: TLayout; pintMarginValue: integer);
begin
  resetMargins(playContainer);

  if self.Width >= Self.Height then
  begin
    if playContainer.name = 'layContainerServidor' then
    begin
      playContainer.Align := TAlignLayout.left;
      layServidor.Margins.bottom := 0;
      playContainer.Margins.right := 0;
      playContainer.Margins.left := 20;
    end
    else
    begin
      playContainer.Align := TAlignLayout.right;
      playContainer.Margins.right := 20;
      playContainer.Margins.left := 0;
    end;
  end
  else
  begin
    playContainer.Align := TAlignLayout.center;

    if playContainer.name = 'layContainerServidor' then
    begin
      playContainer.Margins.Bottom := 0;
      playContainer.Margins.top := pintMarginValue;
    end
    else
    begin
      playContainer.Margins.Bottom := pintMarginValue;
      playContainer.Margins.top := 0;
    end;
  end;
end;

procedure TfrmLogin.posicionaObjetos;
begin
  if LayoutCircle.Width >= layoutcircle.Height then
  begin
    circle.Width := LayoutCircle.Width * 1.5;
    circle.Height := circle.Width;
    circle.Margins.Bottom := circle.Width * 0.30;

    AnimationCircle.PropertyName := 'Margins.Right';
    AnimationCircle.StartValue := -circle.Width;
    AnimationCircle.StopValue := circle.Width;

    if not AnimationCircle.Inverse then
      circle.Margins.Right := AnimationCircle.startValue
    else
      circle.Margins.Right := AnimationCircle.stopValue;

  end
  else
  begin
    circle.height := LayoutCircle.height * 1.5;
    circle.width := circle.height;
    circle.Margins.right := 0;

    AnimationCircle.PropertyName := 'Margins.Bottom';
    AnimationCircle.StartValue := circle.Width;
    AnimationCircle.StopValue := -circle.Width;

    if not AnimationCircle.Inverse then
      circle.Margins.bottom := AnimationCircle.StartValue
    else
      circle.Margins.bottom := AnimationCircle.StopValue;
  end;

end;

end.
