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
  Data.Bind.ObjectScope, system.JSON, system.NetEncoding,
  REST.Authenticator.Basic, System.IniFiles;

type
  Tdm = class(TDataModule)
    conn: TFDConnection;
    qry_config: TFDQuery;
    RESTClient: TRESTClient;
    RequestLogin: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RequestListarComanda: TRESTRequest;
    RequestListarProduto: TRESTRequest;
    RequestListarCategoria: TRESTRequest;
    RequestAdicionarProdutoComanda: TRESTRequest;
    RequestListarProdutoComanda: TRESTRequest;
    RequestExcluirProdutoComanda: TRESTRequest;
    RequestEncerrarComanda: TRESTRequest;
    RequestTransferir: TRESTRequest;
    RequestOpcional: TRESTRequest;
    HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    function StringToBase64(const Input: string): string;
  public
    { Public declarations }
    function validaLogin(usuario: string; senha: string; out erro: string): boolean;
    function ListarComanda(out jsonArray: TJSONArray; out erro: string): boolean;
    function ListarProduto(id_categoria: integer; termo_busca: string; pagina: integer; out jsonArray: TJSONArray; out erro: string): boolean;
    function ListarCategoria(out jsonArray: TJSONArray; out erro: string): boolean;
    function AdicionarProdutoComanda(id_comanda: string; id_produto, qtd: integer; vl_total: double;
                                      obs, obs_opcional: string; vl_opcional: double; out erro: string): boolean;
    function ListarProdutoComanda(id_comanda: string;  out jsonArray: TJSONArray; out erro: string): boolean;
    function ExcluirProdutoComanda(id_comanda: string; id_consumo: integer; out erro: string): boolean;
    function ListarExcluirProdutoComanda(id_comanda: string; id_consumo: integer; out jsonArray: TJSONArray; out erro: string): boolean;
    function EncerrarComanda(id_comanda: string; out erro: string): boolean;
    function TransferirComanda(id_comanda_de, id_comanda_para: string; out erro: string): boolean;
    function ListarOpcional(id_produto: integer; out jsonArray: TJSONArray; out erro: string): boolean;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

function Tdm.validaLogin(usuario: string; senha: string; out erro: string): boolean;
var
  json: string;
  jsonOBJ: tjsonObject;
begin
  erro := '';
  RequestLogin.Params.clear;
  RequestLogin.AddParameter('usuario', usuario, TRESTRequestParameterKind.pkGETorPOST);
  RequestLogin.AddParameter('senha', senha, TRESTRequestParameterKind.pkGETorPOST);
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

    if (jsonOBJ.GetValue('retorno').value = 'ok') then
    begin
      result := true;
    end
    else
    begin
      result := false;
      erro := jsonOBJ.GetValue('retorno').value;
    end;

    jsonOBJ.DisposeOf
  end;
end;

function Tdm.TransferirComanda(id_comanda_de: string; id_comanda_para: string; out erro: string): boolean;
var
  json: string;
  jsonOBJ: tjsonObject;
begin
  erro := '';

  RequestTransferir.Params.clear;
  RequestTransferir.AddParameter('id_comanda_de', id_comanda_de, TRESTRequestParameterKind.pkGETorPOST);
  RequestTransferir.AddParameter('id_comanda_para', id_comanda_para, TRESTRequestParameterKind.pkGETorPOST);
  RequestTransferir.Execute;

  if dm.RequestTransferir.Response.StatusCode <> 200 then
  begin
    result := false;
    erro := 'Erro ao transferir comanda:' + dm.RequestTransferir.Response.StatusCode.ToString;
  end
  else
  begin
    json := RequestTransferir.Response.JSONValue.ToString;
    jsonOBJ := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

    if (jsonOBJ.GetValue('retorno').value = 'ok') then
    begin
      result := true;
    end
    else
    begin
      result := false;
      erro := jsonOBJ.GetValue('retorno').value;
    end;

    jsonOBJ.DisposeOf
  end;
end;

function Tdm.ListarComanda(out jsonArray: TJSONArray; out erro: string): boolean;
var
  json: string;
begin
  erro := '';

  RequestListarComanda.Params.clear;
  RequestListarComanda.Execute;

  if dm.RequestListarComanda.Response.StatusCode <> 200 then
  begin
    result := false;
    erro := 'Erro ao listar comandas:' + dm.RequestListarComanda.Response.StatusCode.ToString;

  end
  else
  begin
    json := RequestListarComanda.Response.JSONValue.ToString;
    jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;
    result := true;
  end;
end;


function Tdm.ListarExcluirProdutoComanda(id_comanda: string;
  id_consumo: integer; out jsonArray: TJSONArray; out erro: string): boolean;
begin

end;

function Tdm.StringToBase64(const Input: string): string;
var
  Base64: TBase64Encoding;
begin
  Base64 := TBase64Encoding.Create;
  try
    Result := Base64.Encode(Input);
  finally
    freeandnil(Base64);
  end;
end;

function Tdm.AdicionarProdutoComanda(id_comanda: string; id_produto, qtd: integer; vl_total: double;
                                      obs, obs_opcional: string; vl_opcional: double; out erro: string): boolean;
var
  json: string;
  jsonOBJ: TJsonObject;
begin
  erro := '';

  RequestAdicionarProdutoComanda.Params.clear;
  RequestAdicionarProdutoComanda.AddParameter('id_comanda', id_comanda, TRESTRequestParameterKind.pkGETorPOST);
  RequestAdicionarProdutoComanda.AddParameter('id_produto', id_produto.ToString, TRESTRequestParameterKind.pkGETorPOST);
  RequestAdicionarProdutoComanda.AddParameter('qtd', qtd.ToString, TRESTRequestParameterKind.pkGETorPOST);
  RequestAdicionarProdutoComanda.AddParameter('vl_total', FormatFloat('0.00', vl_total).Replace(',','').Replace('.', ''), TRESTRequestParameterKind.pkGETorPOST);
  RequestAdicionarProdutoComanda.AddParameter('obs_opcional', StringToBase64(obs_opcional), TRESTRequestParameterKind.pkGETorPOST);
  RequestAdicionarProdutoComanda.AddParameter('vl_opcional', FormatFloat('0.00', vl_opcional).Replace(',','').Replace('.', ''), TRESTRequestParameterKind.pkGETorPOST);
  RequestAdicionarProdutoComanda.AddParameter('obs', StringToBase64(obs), TRESTRequestParameterKind.pkGETorPOST);
  RequestAdicionarProdutoComanda.Execute;

  if dm.RequestAdicionarProdutoComanda.Response.StatusCode <> 200 then
  begin
    result := false;
    erro := 'Erro ao adicionar item:' + dm.RequestAdicionarProdutoComanda.Response.StatusCode.ToString;
  end
  else
  begin
    json := RequestAdicionarProdutoComanda.Response.JSONValue.ToString;
    jsonOBJ := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJsonObject;

    if (jsonObj.GetValue('retorno').Value = 'ok') then
      result := true
    else
    begin
      Result := false;
      erro := jsonObj.GetValue('retorno').value;
    end;

    jsonOBJ.DisposeOf;
  end;
end;

function Tdm.ListarOpcional(id_produto: integer; out jsonArray: TJSONArray; out erro: string): boolean;
var
  json: string;
begin
  erro := '';
  try
    RequestOpcional.Params.clear;
    RequestOpcional.AddParameter('id_produto', id_produto.ToString, TRESTRequestParameterKind.pkGETorPOST);
    RequestOpcional.Execute;
  except on ex: exception do
      begin
        Result := false;
        erro := 'Erro ao listar Opcionais:' + ex.message;
        exit;
      end;
  end;

  if dm.RequestOpcional.Response.StatusCode <> 200 then
  begin
    result := false;
    erro := 'Erro ao listar Opcionais:' + dm.RequestOpcional.Response.StatusCode.ToString;
  end
  else
  begin
    json := RequestOpcional.Response.JSONValue.ToString;
    jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;
    result := true;
  end;
end;

function Tdm.ListarProduto(id_categoria: integer; termo_busca: string; pagina: integer; out jsonArray: TJSONArray; out erro: string): boolean;
var
  json: string;
begin
  erro := '';
  try
    RequestListarProduto.Params.clear;
    RequestListarProduto.AddParameter('id_categoria', id_categoria.ToString, TRESTRequestParameterKind.pkGETorPOST);
    RequestListarProduto.AddParameter('termo_busca', termo_busca, TRESTRequestParameterKind.pkGETorPOST);
    RequestListarProduto.AddParameter('pagina', pagina.ToString, TRESTRequestParameterKind.pkGETorPOST);
    RequestListarProduto.Execute;
  except on ex: exception do
      begin
        Result := false;
        erro := 'Erro ao listar produto:' + ex.message;
        exit;
      end;
  end;

  if dm.RequestListarProduto.Response.StatusCode <> 200 then
  begin
    result := false;
    erro := 'Erro ao listar produto:' + dm.RequestListarProduto.Response.StatusCode.ToString;
  end
  else
  begin
    json := RequestListarProduto.Response.JSONValue.ToString;
    jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;
    result := true;
  end;
end;

function Tdm.ListarCategoria(out jsonArray: TJSONArray; out erro: string): boolean;
var
  json: string;
begin
  erro := '';

  try
    RequestListarCategoria.Params.clear;
    RequestListarCategoria.Execute;

  except on ex: exception do
      begin
        Result := false;
        erro := 'Erro ao listar categorias: ' + ex.Message;
      end;
  end;

  if dm.RequestListarCategoria.Response.StatusCode <> 200 then
  begin
    result := false;
    erro := 'Erro ao listar categorias:' + dm.RequestListarCategoria.Response.StatusCode.ToString;
  end
  else
  begin
    json := RequestListarCategoria.Response.JSONValue.ToString;
    jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;
    result := true;
  end;
end;

function Tdm.ListarProdutoComanda(id_comanda: string;  out jsonArray: TJSONArray; out erro: string): boolean;
var
  json: string;
begin
  erro := '';
  try
    RequestListarProdutoComanda.Params.clear;
    RequestListarProdutoComanda.AddParameter('id_comanda', id_comanda, TRESTRequestParameterKind.pkGETorPOST);
    RequestListarProdutoComanda.Execute;
  except on ex: exception do
      begin
        Result := false;
        erro := 'Erro ao listar produto da comanda:' + ex.message;
        exit;
      end;
  end;

  if dm.RequestListarProdutoComanda.Response.StatusCode <> 200 then
  begin
    result := false;
    erro := 'Erro ao listar produto da comanda:' + dm.RequestListarProdutoComanda.Response.StatusCode.ToString;
  end
  else
  begin
    json := RequestListarProdutoComanda.Response.JSONValue.ToString;
    jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;
    result := true;
  end;
end;

function Tdm.ExcluirProdutoComanda(id_comanda: string; id_consumo: integer; out erro: string): boolean;
var
  json: string;
  jsonObj: TJsonObject;
begin
  erro := '';

  RequestExcluirProdutoComanda.Params.clear;
  RequestExcluirProdutoComanda.AddParameter('id_comanda', id_comanda, TRESTRequestParameterKind.pkGETorPOST);
  RequestExcluirProdutoComanda.AddParameter('id_consumo', id_consumo.ToString, TRESTRequestParameterKind.pkGETorPOST);
  RequestExcluirProdutoComanda.Execute;

  if dm.RequestExcluirProdutoComanda.Response.StatusCode <> 200 then
  begin
    result := false;
    erro := 'Erro ao excluir produto da comanda:' + dm.RequestExcluirProdutoComanda.Response.StatusCode.ToString;
  end
  else
  begin
    json := RequestExcluirProdutoComanda.Response.JSONValue.ToString;
    jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

    if jsonObj.GetValue('retorno').Value = 'ok' then
        Result := true
    else
    begin
        Result := false;
        erro := jsonObj.GetValue('retorno').Value;
    end;

    jsonObj.DisposeOf;
  end;
end;


function Tdm.EncerrarComanda(id_comanda: string; out erro: string): boolean;
var
  json: string;
  jsonObj: TJsonObject;
begin
  erro := '';

  RequestEncerrarComanda.Params.clear;
  RequestEncerrarComanda.AddParameter('id_comanda', id_comanda, TRESTRequestParameterKind.pkGETorPOST);
  RequestEncerrarComanda.Execute;

  if dm.RequestEncerrarComanda.Response.StatusCode <> 200 then
  begin
    result := false;
    erro := 'Erro ao encerrar comanda:' + dm.RequestEncerrarComanda.Response.StatusCode.ToString;
  end
  else
  begin
    json := RequestEncerrarComanda.Response.JSONValue.ToString;
    jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

    if jsonObj.GetValue('retorno').Value = 'ok' then
        Result := true
    else
    begin
        Result := false;
        erro := jsonObj.GetValue('retorno').Value;
    end;

    jsonObj.DisposeOf;
  end;
end;

procedure Tdm.DataModuleCreate(Sender: TObject);
var
  liniFile: TIniFile;
begin
  liniFile := nil;
  try
    liniFile := TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\Comanda.ini');

    conn.Params.Values['DriverID'] := 'SQLite';
    RESTClient.BaseURL := liniFile.ReadString('Conexao', 'serverURL', '');

    {$ifdef mswindows}
      conn.params.Values['DataBase'] := system.SysUtils.GetCurrentDir + '\DB\banco.db';
    {$endif}
    {$ifdef ANDROID}
      conn.Params.Values['DataBase'] := TPath.Combine(TPath.GetDocumentsPath, 'banco.db');
    {$endif}

    try
      conn.Connected := true;
    except on E: exception do
      raise exception.Create('Erro de conexão com o banco de dados: ' + E.message);
    end;
  finally
    if liniFile <> nil then
      freeandnil(liniFile);
  end;
end;

end.
