unit uDM;

interface

uses
  System.SysUtils, System.Classes, urestDWDataModule, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, uRESTDWComponentBase, uRESTDWServerEvents, uRESTDWParams,
  uRESTDWAboutForm, uRESTDWJSONObject, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, system.JSON, uRESTDWConsts;

type
  Tdm = class(TServerMethodDataModule)
    conn: TFDConnection;
    DWEvents: TRESTDWServerEvents;
    qryLogin: TFDQuery;
    procedure DWEventsEventsValidarLoginReplyEvent(var Params: TRESTDWParams;
      var Result: string);
    procedure DWEventsEventsListarComandaReplyEvent(var Params: TRESTDWParams;
      var Result: string);
    procedure DWEventsEventsListarCategoriaReplyEvent(var Params: TRESTDWParams;
      var Result: string);
    procedure DWEventsEventsListarProdutoReplyEvent(var Params: TRESTDWParams;
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

procedure Tdm.DWEventsEventsListarCategoriaReplyEvent(var Params: TRESTDWParams;
  var Result: string);
var
  qry: TFDQuery;
  json: uRESTDWJSONObject.TJSONValue;
begin
  try
    qry := TFDQuery.create(nil);
    qry.Connection := dm.conn;

    json := uRESTDWJSONObject.TJSONValue.Create;

    qry.Active := false;
    qry.SQL.clear;
    qry.SQL.add('select');
    qry.SQL.add('    C.*');
    qry.SQL.add('from');
    qry.SQL.add('    tab_produto_categoria C');
    qry.SQL.add('order BY C.descricao');
    qry.active := true;

    json.LoadFromDataset('', qry, false, dmRAW);

    result := json.ToJSON;
  finally
    json.DisposeOf;
    qry.DisposeOf;
  end;
end;

procedure Tdm.DWEventsEventsListarComandaReplyEvent(var Params: TRESTDWParams;
  var Result: string);
var
  qry: TFDQuery;
  json: uRESTDWJSONObject.TJSONValue;
begin
  try
    qry := TFDQuery.create(nil);
    qry.Connection := dm.conn;

    json := uRESTDWJSONObject.TJSONValue.Create;

    qry.Active := false;
    qry.SQL.clear;
    qry.SQL.add('select');
    qry.SQL.add('    C.ID_COMANDA,');
    qry.SQL.add('    C.STATUS,');
    qry.SQL.add('    coalesce(SUM(O.VALOR_TOTAL), 0) as VALOR_TOTAL');
    qry.SQL.add('from');
    qry.SQL.add('    tab_comanda C');
    qry.SQL.add('    left join tab_comanda_consumo O ON (C.id_comanda = O.id_comanda)');
    qry.SQL.add('GROUP BY');
    qry.SQL.add('    C.id_comanda, c.status');
    qry.SQL.add('    order BY C.id_comanda');
    qry.active := true;

    json.LoadFromDataset('', qry, false, dmRAW);

    result := json.ToJSON;
  finally
    json.DisposeOf;
    qry.DisposeOf;
  end;

end;

procedure Tdm.DWEventsEventsListarProdutoReplyEvent(var Params: TRESTDWParams;
  var Result: string);
var
  qry: TFDQuery;
  json: uRESTDWJSONObject.TJSONValue;
begin
  try
    qry := TFDQuery.create(nil);
    qry.Connection := dm.conn;

    json := uRESTDWJSONObject.TJSONValue.Create;

    qry.Active := false;
    qry.SQL.clear;
    qry.SQL.add('select');
    qry.SQL.add('    *');
    qry.SQL.add('from');
    qry.SQL.add('    TAB_PRODUTO P');
    qry.SQL.add('where');
    qry.SQL.add('    P.ID_PRODUTO > 0');

    if Params.ItemsString['id_categoria'].AsString <> '' then
    begin
      qry.SQL.add('AND P.ID_CATEGORIA = :ID_CATEGORIA');
      qry.ParamByName('ID_CATEGORIA').value := Params.ItemsString['id_categoria'].asInteger;
    end;

    if Params.ItemsString['termo_busca'].AsString <> '' then
    begin
      qry.SQL.add('AND P.ID_DESCRICAO LIKE  :TERMO_BUSCA');
      qry.ParamByName('ID_CATEGORIA').value := Params.ItemsString['id_categoria'].asInteger;
      qry.ParamByName('TERMO_BUSCA').value := '%' + Params.ItemsString['id_categoria'].asString + '%';
    end;

    qry.SQL.add(' ORDER BY P.DESCRICAO');

    qry.active := true;

    json.LoadFromDataset('', qry, false, dmRAW);

    result := json.ToJSON;

  finally
    json.DisposeOf;
    qry.DisposeOf;
  end;

end;

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
