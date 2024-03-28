unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.TabControl,
  FMX.Edit, FMX.Layouts, FMX.ListBox, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TfrmPrincipal = class(TForm)
    Rectangle1: TRectangle;
    Label1: TLabel;
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    rect_abas: TRectangle;
    Rectangle3: TRectangle;
    Label2: TLabel;
    Rectangle4: TRectangle;
    Label3: TLabel;
    Layout1: TLayout;
    Label4: TLabel;
    Edit1: TEdit;
    rectAddItem: TRectangle;
    Label5: TLabel;
    rectDetalhes: TRectangle;
    Label6: TLabel;
    ListBox1: TListBox;
    Rectangle6: TRectangle;
    ListView1: TListView;
    Edit2: TEdit;
    Rectangle7: TRectangle;
    Label7: TLabel;
    imgAba1: TImage;
    imgAba2: TImage;
    imgAba3: TImage;
    procedure imgAba1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure mudarAba(img: TImage);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

procedure TfrmPrincipal.mudarAba(img: TImage);
begin
  imgAba1.Opacity := 0.4;
  imgAba2.Opacity := 0.4;
  imgAba3.Opacity := 0.4;

  img.Opacity := 1;
  TabControl.GotoVisibleTab(img.tag, TTabTransition.Slide);
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  mudarAba(imgAba1);
end;

procedure TfrmPrincipal.imgAba1Click(Sender: TObject);
begin
  mudarAba(TImage(Sender));
end;

end.
