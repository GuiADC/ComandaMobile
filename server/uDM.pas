unit uDM;

interface

uses
  System.SysUtils, System.Classes, urestDWDataModule, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, uRESTDWComponentBase, uRESTDWServerEvents, uRESTDWParams,
  uRESTDWAboutForm, uRESTDWJSONObject, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, system.JSON;

type
  Tdm = class(TServerMethodDataModule)
    conn: TFDConnection;
    DWEvents: TRESTDWServerEvents;
    qryLogin: TFDQuery;
    procedure DWEventsEventsValidarLoginReplyEvent(var Params: TRESTDWParams;
      var Result: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure Tdm.DWEventsEventsValidarLoginReplyEvent(var Params: TRESTDWParams;
  var Result: string);
var
  json: TJsonObject;
begin
  try
    json := TJSONObject.create;

    if Params.ItemsString['usuario'].AsString = '' then
    begin
      json.AddPair('retorno', 'Usuário nao informado');
      Result := json.ToString;
      exit;
    end;

    with dm do
    begin
      qryLogin.Active := false;
      qryLogin.SQL.Clear;
      qryLogin.SQL.Add('SELECT * from TAB_USUARIO WHERE COD_USUARIO=:USUARIO');
      qryLogin.ParamByName('USUARIO').Value := Params.ItemsString['usuario'].AsString;
      qryLogin.Active := true;

      if qryLogin.RecordCount > 0 then
        json.AddPair('retorno', 'OK')
      else
        json.AddPair('retorno', 'Usuário invalido');

      Result := json.tostring;
    end;
  finally
    json.DisposeOf;
  end;
end;

end.
