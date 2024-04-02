﻿unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.TabControl, uPrincipal;

type
  TfrmLogin = class(TForm)
    Rectangle1: TRectangle;
    lblTitulo: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    Edit1: TEdit;
    rectLogin: TRectangle;
    Label3: TLabel;
    TabControl: TTabControl;
    tabLogin: TTabItem;
    tabConfig: TTabItem;
    Layout2: TLayout;
    Label4: TLabel;
    Edit2: TEdit;
    rectSave: TRectangle;
    Label5: TLabel;
    lblConfig: TLabel;
    procedure rectLoginClick(Sender: TObject);
    procedure lblConfigClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rectSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  TabControl.ActiveTab := tabLogin;
end;

procedure TfrmLogin.lblConfigClick(Sender: TObject);
begin
  tabControl.GotoVisibleTab(1, TTabTransition.Slide);

  lblTitulo.Text := 'Configurações';
end;

procedure TfrmLogin.rectSaveClick(Sender: TObject);
begin
  tabControl.GotoVisibleTab(0, TTabTransition.Slide);

  lblTitulo.Text := 'Acesso';
end;

procedure TfrmLogin.rectLoginClick(Sender: TObject);
begin
  if not Assigned(frmPrincipal) then
    frmPrincipal := TfrmPrincipal.Create(nil);

    frmPrincipal.Show;
    Application.MainForm := frmPrincipal;

    freeandnil(frmLogin);

end;

end.
