unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  uRESTDWComponentBase, uRESTDWBasicDB, FMX.StdCtrls, FMX.Controls.Presentation,
  uRESTDWBasic, uRESTDWIdBase;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    Swtich: TSwitch;
    RESTDWIdServicePooler: TRESTDWIdServicePooler;
    procedure FormShow(Sender: TObject);
    procedure SwtichSwitch(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses uDM;

procedure conectarBanco;
begin
  try
    dm.conn.Params.Values['DriverId'] := 'FB';
    dm.conn.Params.Values['DataBase'] := 'C:\Users\gui-a\Documents\Embarcadero\Studio\Projects\comandaMobile\server\DB\DBCOMANDA.FDB';
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
  RESTDWIdServicePooler.ServerMethodClass := TDM;
  RESTDWIdServicePooler.Active := Swtich.IsChecked;
end;

procedure TfrmMain.SwtichSwitch(Sender: TObject);
begin
  RESTDWIdServicePooler.Active := Swtich.IsChecked;
end;

end.
