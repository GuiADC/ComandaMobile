unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  uRESTDWComponentBase, uRESTDWBasicDB, FMX.StdCtrls, FMX.Controls.Presentation,
  uRESTDWBasic, uRESTDWIdBase, System.IniFiles;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    Swtich: TSwitch;
    RESTDWIdServicePooler: TRESTDWIdServicePooler;
    procedure FormShow(Sender: TObject);
    procedure SwtichSwitch(Sender: TObject);
  private
    procedure conectarBanco;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses uDM;

procedure TfrmMain.conectarBanco;
var
  liniFile: TIniFile;
begin
  liniFile := nil;

  liniFile := TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\Login.ini');
  try
    RESTDWIdServicePooler.servicePort := liniFile.ReadInteger('Conexao', 'Port', 0);

    dm.conn.Params.Values['DriverId'] := 'FB';
    dm.conn.Params.Values['DataBase'] := liniFile.ReadString('Conexao', 'Database', '');
    dm.conn.Params.Values['DriverId'] := 'FB';
    dm.conn.Params.Values['User_Name'] := 'SYSDBA';
    dm.conn.Params.Values['Password'] := 'masterkey';
    dm.conn.Connected := true;
  except on
    E: Exception do
    ShowMessage('Erro ao acessar o banco. Erro:' +  E.Message);
  end;
end;


procedure TfrmMain.FormShow(Sender: TObject);
begin
  conectarBanco;
  RESTDWIdServicePooler.ServerMethodClass := TDM;
  RESTDWIdServicePooler.Active := Swtich.IsChecked;
end;

procedure TfrmMain.SwtichSwitch(Sender: TObject);
begin
  RESTDWIdServicePooler.Active := Swtich.IsChecked;
end;

end.
