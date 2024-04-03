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
    procedure imgFecharClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvCategoriaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
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
    comanda: integer;
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
  lblComanda.text := 'Comanda / Mesa: ' + comanda.ToString;

  listarProduto(AItem.tag, '');

  TabControl.GotoVisibleTab(1, TTabTransition.slide);
end;

procedure TfrmAddItem.FormShow(Sender: TObject);
begin
  listarCategoria;
end;


procedure TfrmAddItem.imgFecharClick(Sender: TObject);
begin
  close;
end;

procedure TfrmAddItem.imgVoltarClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(0, TTabTransition.Slide);
end;

end.
