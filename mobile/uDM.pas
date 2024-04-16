unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, System.IOUtils,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, system.JSON, system.NetEncoding;

type
  Tdm = class(TDataModule)
    conn: TFDConnection;
    qry_config: TFDQuery;
    RESTClient: TRESTClient;
    RequestLogin: TRESTRequest;
    RESTResponse1: TRESTResponse;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function validaLogin(usuario: string; out erro: string): boolean;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

function Tdm.validaLogin(usuario: string; out erro: string): boolean;
var
  json: string;
  jsonOBJ: tjsonObject;
begin
  erro := '';

  RequestLogin.Params.clear;
  RequestLogin.AddParameter('usuario', usuario, TRESTRequestParameterKind.pkGETorPOST);
  RequestLogin.Execute;

  if dm.RequestLogin.Response.StatusCode <> 200 then
  begin
    result := false;
    erro := 'Erro ao validar login:' + dm.RequestLogin.Response.StatusCode.ToString;

  end
  else
  begin
    json := requestLogin.Response.JSONValue.ToString;
    jsonOBJ := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

    if (jsonOBJ.GetValue('retorno').value = 'OK') then
    begin
      result := true;
    end
    else
    begin
      result := false;
      erro := jsonOBJ.GetValue('retorno').value;

    end;
  end;
end;

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  with conn do
  begin
    Params.Values['DriverID'] := 'SQLite';

    {$ifdef mswindows}
    Params.Values['DataBase'] := system.SysUtils.GetCurrentDir + '\DB\banco.db';
    {$else}
    Params.Values['DataBase'] := TPath.Combine(TPath.GetDocumentsPath, 'banco.db');
    {$endif}

    try
      Connected := true;
    except on E: exception do
      raise exception.Create('Erro de conexão com o banco de dados: ' + E.message);
    end;
  end;
end;

end.
