program comanda;

uses
  System.StartUpCopy,
  FMX.Forms,
  uLogin in 'uLogin.pas' {frmLogin},
  uPrincipal in 'uPrincipal.pas' {frmPrincipal},
  uResumo in 'uResumo.pas' {frmResumo},
  uAddItem in 'uAddItem.pas' {frmAddItem},
  uDM in 'uDM.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
