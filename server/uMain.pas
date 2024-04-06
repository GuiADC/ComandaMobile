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

uses uDM;

{$R *.fmx}

procedure TfrmMain.FormShow(Sender: TObject);
begin
  RESTDWIdServicePooler.ServerMethodClass := TDM;
end;

procedure TfrmMain.SwtichSwitch(Sender: TObject);
begin
  RESTDWIdServicePooler.Active := Swtich.IsChecked;
end;

end.
