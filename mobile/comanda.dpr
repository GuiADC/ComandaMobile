program comanda;

uses
  System.StartUpCopy,
  FMX.Forms,
  uLogin in 'uLogin.pas' {frmLogin},
  uPrincipal in 'uPrincipal.pas' {frmPrincipal},
  uResumo in 'uResumo.pas' {frmResumo},
  uAddItem in 'uAddItem.pas' {frmAddItem},
  uDM in 'uDM.pas' {dm: TDataModule},
  utils in 'utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.
