unit uAddItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.TabControl, FMX.Edit, system.JSON, System.NetEncoding;

type
  TfrmAddItem = class(TForm)
    Rectangle4: TRectangle;
    Label3: TLabel;
    imgFechar: TImage;
    lvCategoria: TListView;
    TabControl: TTabControl;
    tabCategoria: TTabItem;
    tabProduto: TTabItem;
    Rectangle1: TRectangle;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    Rectangle6: TRectangle;
    edtBuscaProduto: TEdit;
    rectBuscaProduto: TRectangle;
    Label7: TLabel;
    Rectangle2: TRectangle;
    lblComanda: TLabel;
    imgIcone: TImage;
    lvProduto: TListView;
    imgAdd: TImage;
    layoutQtd: TLayout;
    Rectangle3: TRectangle;
    Rectangle5: TRectangle;
    lblDescricao: TLabel;
    rectConfirmar: TRectangle;
    Label4: TLabel;
    lblQtd: TLabel;
    imgMenos: TImage;
    imgMais: TImage;
    imgFecharQtd: TImage;
    edtObs: TEdit;
    LvOpcional: TListView;
    imgUnchecked: TImage;
    imgChecked: TImage;
    Rectangle7: TRectangle;
    procedure imgFecharClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvCategoriaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure imgMenosClick(Sender: TObject);
    procedure lvProdutoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure imgFecharQtdClick(Sender: TObject);
    procedure rectConfirmarClick(Sender: TObject);
    procedure rectBuscaProdutoClick(Sender: TObject);
    procedure LvOpcionalItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    procedure addCategoriaLv(idCategoria: integer; descricao: string; icone: string);
    procedure listarCategoria;
    procedure addProdutoLv(idProduto: integer; descricao: string;
      preco: double);
    procedure listarProduto(idCategoria: integer; busca: string);
    function converteValor(vl: string): double;
    procedure listarOpcional(idProduto: integer);
    procedure addOpcionalLv(idOpcao: integer; descricao: string; valor: double);
    { Private declarations }
  public
    { Public declarations }
    comanda: string;

    function bitmapFromBase64(const base64: string): TBitmap;
  end;

var
  frmAddItem: TfrmAddItem;

implementation

uses uDM;

{$R *.fmx}

function TfrmAddItem.bitmapFromBase64(const base64: string) : TBitmap;
var
  input: TStringStream;
  Output: TBytesStream;
  Encoding: TBase64Encoding;
begin
  input := TStringStream.Create(base64, TEncoding.ASCII);
  try
    Output := TBytesStream.create;
    try
      Encoding := TBase64Encoding.create(0);
      Encoding.Decode(input, Output);

      output.Position := 0;
      Result := TBitmap.Create;
      try
        Result.LoadFromStream(Output);
      except
        Result.Free;
        raise;
      end;
    finally
      Encoding.DisposeOf;
      output.Free;
    end;
  finally
    input.Free;
  end;

end;

procedure TfrmAddItem.addCategoriaLv(idCategoria: integer; descricao: string; icone: string);
var
  bmp: TBitmap;
begin
  with lvCategoria.Items.add do
  begin
    Tag := idCategoria;
    TListItemText(Objects.FindDrawable('txtDescricao')).text := descricao;

    if icone <> '' then
    begin
      bmp := bitmapFromBase64(icone);

      TListItemImage(Objects.FindDrawable('imgIcone')).OwnsBitmap := true;
      TListItemImage(Objects.FindDrawable('imgIcone')).bitmap := bmp;
    end;
  end;
end;

procedure TfrmAddItem.listarCategoria;
var
  x: integer;
  erro: string;
  jsonArray: TJsonArray;
begin
  try
    lvCategoria.Items.clear;

    if not dm.listarCategoria(jsonArray, erro) then
    begin
      ShowMessage(erro);
      exit;
    end;

    for x := 0 to jsonArray.size -1 do
      addCategoriaLv(jsonArray.get(x).GetValue<integer>('ID_CATEGORIA'), jsonArray.get(x).GetValue<string>('DESCRICAO'), jsonArray.get(x).GetValue<string>('ICONE'));

  finally
    jsonArray.DisposeOf;
  end;
end;

procedure TfrmAddItem.addProdutoLv(idProduto: integer; descricao: string; preco: double);
begin
  with lvProduto.Items.add do
  begin
    Tag := idProduto;
    TListItemText(Objects.FindDrawable('txtDescricao')).text := descricao;
    TListItemText(Objects.FindDrawable('txtPreco')).text := FormatFloat('#,##0.00', preco);
    TListItemImage(Objects.FindDrawable('imgAdd')).bitmap := imgAdd.bitmap;
  end;

end;

procedure TfrmAddItem.addOpcionalLv(idOpcao: integer; descricao: string; valor: double);
begin
  with lvOpcional.Items.add do
  begin
    Tag := idOpcao;
    TListItemText(Objects.FindDrawable('txtDescricao')).text := descricao;
    TListItemText(Objects.FindDrawable('txtValor')).text := FormatFloat('#,##0.00', valor);
    TListItemImage(Objects.FindDrawable('imgCheckbox')).bitmap := imgUnchecked.Bitmap;
    TListItemImage(Objects.FindDrawable('imgCheckbox')).TagString := '0';
    TListItemImage(Objects.FindDrawable('imgCheckbox')).TagFloat := valor;
  end;
end;

procedure TfrmAddItem.listarOpcional(idProduto: integer);
var
  x: integer;
  jsonArray: TJSONArray;
  erro: string;
begin
  try
    LvOpcional.Items.clear;

    if not (dm.ListarOpcional(idProduto, jsonArray, erro)) then
    begin
      ShowMessage(erro);
      exit;
    end;

    for x := 0 to jsonArray.size -1 do
      addOpcionalLv(jsonArray.Get(x).GetValue<integer>('ID_OPCAO'), jsonArray.Get(x).GetValue<string>('DESCRICAO'), jsonArray.Get(x).GetValue<double>('VALOR'));

  finally
    LvOpcional.Visible := jsonArray.size > 0;
    jsonArray.DisposeOf;
  end;
end;

procedure TfrmAddItem.listarProduto(idCategoria: integer; busca: string);
var
  x: integer;
  jsonArray: TJSONArray;
  erro: string;
begin
  try
    lvProduto.Items.clear;

    if not (dm.ListarProduto(idCategoria, busca, 0, jsonArray, erro)) then
    begin
      ShowMessage(erro);
      exit;
    end;

    for x := 0 to jsonArray.size -1 do
      addProdutoLv(jsonArray.Get(x).GetValue<integer>('ID_PRODUTO'), jsonArray.Get(x).GetValue<string>('DESCRICAO'), jsonArray.Get(x).GetValue<double>('PRECO'));

  finally
    jsonArray.DisposeOf;
  end;
end;

procedure TfrmAddItem.lvCategoriaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  lblTitulo.text := TListItemText(AItem.Objects.FindDrawable('txtDescricao')).Text;
  lblComanda.text := 'Comanda / Mesa: ' + comanda;

  lvProduto.tag := AItem.tag;
  listarProduto(AItem.tag, '');

  TabControl.GotoVisibleTab(1, TTabTransition.slide);
end;

procedure TfrmAddItem.LvOpcionalItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if (tlistview(sender).Selected <> nil) and (ItemObject is TListItemImage) then
  begin
    if TListItemImage(ItemObject).tagstring = '0' then
    begin
      TListItemImage(ItemObject).Bitmap := imgChecked.Bitmap;
      TListItemImage(ItemObject).TagString := '1';
    end
    else
    begin
      TListItemImage(ItemObject).Bitmap := imgUnchecked.Bitmap;
      TListItemImage(ItemObject).TagString := '0';
    end;
  end;
end;

function TfrmAddItem.converteValor(vl: string): double;
begin
  try
    vl := vl.Replace(',', '').Replace('.','');
    result := vl.ToDouble / 100;
  except
    result := 0;
  end;
end;

procedure TfrmAddItem.lvProdutoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  lblQtd.text := '01';
  lblDescricao.text := TListItemText(AItem.Objects.FindDrawable('txtDescricao')).Text;
  lblDescricao.tag := AItem.tag;
  lblDescricao.TagFloat := converteValor(TListItemText(AItem.Objects.FindDrawable('txtPreco')).Text);

  listarOpcional(AItem.tag);

  edtObs.Text := '';
  layoutQtd.Visible := true;
end;

procedure TfrmAddItem.rectBuscaProdutoClick(Sender: TObject);
begin
  listarProduto(lvProduto.Tag, edtBuscaProduto.text);
end;

procedure TfrmAddItem.rectConfirmarClick(Sender: TObject);
var
  obs_opcional: string;
  erro: string;
  vlOpcional: double;
begin
  //verificar os opcionais...
  vlOpcional := 0;

  for var lintIndex := 0 to LvOpcional.Items.Count -1 do
  begin
    if (TListItemImage(lvOpcional.items[lintIndex].Objects.FindDrawable('imgCheckbox')).TagString = '1') then
    begin
      vlOpcional := vlOpcional + (TListItemImage(lvOpcional.items[lintIndex].Objects.FindDrawable('imgCheckbox')).tagfloat * lblQtd.Text.ToInteger);

      if obs_opcional <> '' then
        obs_opcional := obs_opcional + ' + ';

      obs_opcional := obs_opcional + TListItemText(lvOpcional.items[lintIndex].Objects.FindDrawable('txtDescricao')).text;
    end;
  end;

  if vlOpcional > 0 then
    obs_opcional := obs_opcional + ' = ' + FormatFloat('#,##0.00', vlOpcional);

  if (dm.AdicionarProdutoComanda(comanda, lblDescricao.Tag, lblQtd.Text.ToInteger, lblQtd.Text.ToInteger * lblDescricao.TagFloat,
                                 edtObs.text, obs_opcional, vlOpcional, erro)) then
  begin
    layoutQtd.Visible := false;
    self.modalResult := mrOk;
  end
  else
    ShowMessage(erro);
end;

procedure TfrmAddItem.FormShow(Sender: TObject);
begin
  layoutQtd.Visible := false;
  listarCategoria;
end;


procedure TfrmAddItem.imgFecharClick(Sender: TObject);
begin
  close;
end;

procedure TfrmAddItem.imgFecharQtdClick(Sender: TObject);
begin
  layoutQtd.Visible := false;
end;

procedure TfrmAddItem.imgMenosClick(Sender: TObject);
begin
  if (strtoint(lblQtd.text) = 0) and (TImage(sender).Tag = -1) then
    exit;

  lblQtd.text := formatfloat('00', lblQtd. text.ToInteger + TImage(sender).Tag);
end;

procedure TfrmAddItem.imgVoltarClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(0, TTabTransition.Slide);
end;

end.
