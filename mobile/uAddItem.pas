unit uAddItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.TabControl, FMX.Edit;

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
    rectEncerrar: TRectangle;
    Label4: TLabel;
    lblQtd: TLabel;
    imgMenos: TImage;
    imgMais: TImage;
    imgFecharQtd: TImage;
    procedure imgFecharClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvCategoriaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure imgMenosClick(Sender: TObject);
    procedure lvProdutoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure imgFecharQtdClick(Sender: TObject);
  private
    procedure addCategoriaLv(idCategoria: integer; descricao: string;
      icone: TStream);
    procedure listarCategoria;
    procedure addProdutoLv(idProduto: integer; descricao: string;
      preco: double);
    procedure listarProduto(idCategoria: integer; busca: string);
    { Private declarations }
  public
    { Public declarations }
    comanda: string;
  end;

var
  frmAddItem: TfrmAddItem;

implementation

{$R *.fmx}

procedure TfrmAddItem.addCategoriaLv(idCategoria: integer; descricao: string; icone: TStream);
var
  bmp: TBitmap;
begin
  with lvCategoria.Items.add do
  begin
    Tag := idCategoria;
    TListItemText(Objects.FindDrawable('txtDescricao')).text := descricao;

    if icone <> nil then
    begin
      bmp := TBitmap.Create;
      bmp.LoadFromStream(icone);

      TListItemImage(Objects.FindDrawable('imgIcone')).OwnsBitmap := true;
      TListItemImage(Objects.FindDrawable('imgIcone')).bitmap := bmp;
    end;
  end;

end;

procedure TfrmAddItem.listarCategoria;
var
  x: integer;
  icone: TStream;
begin
    lvCategoria.Items.clear;

   icone := TMemoryStream.create;
   imgIcone.Bitmap.SaveToStream(icone);
   icone.Position := 0;

  for x := 1 to 10 do
    addCategoriaLv(x, 'categoria ' + x.ToString, icone);

  freeandnil(icone);

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

procedure TfrmAddItem.listarProduto(idCategoria: integer; busca: string);
var
  x: integer;
begin
  lvProduto.Items.clear;

  for x := 1 to 10 do
   addProdutoLv(x, 'Produto ' + x.ToString, x);

end;

procedure TfrmAddItem.lvCategoriaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  lblTitulo.text := TListItemText(AItem.Objects.FindDrawable('txtDescricao')).Text;
  lblComanda.text := 'Comanda / Mesa: ' + comanda;

  listarProduto(AItem.tag, '');

  TabControl.GotoVisibleTab(1, TTabTransition.slide);
end;

procedure TfrmAddItem.lvProdutoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  lblQtd.text := '01';
  lblDescricao.text := TListItemText(AItem.Objects.FindDrawable('txtDescricao')).Text;
  layoutQtd.Visible := true;
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
