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
    rectLogin: TRectangle;
    Label5: TLabel;
    Rectangle5: TRectangle;
    Label6: TLabel;
    ListBox1: TListBox;
    Rectangle6: TRectangle;
    ListView1: TListView;
    Edit2: TEdit;
    Rectangle7: TRectangle;
    Label7: TLabel;
    Image3: TImage;
    Image1: TImage;
    Image2: TImage;
    procedure Image3Click(Sender: TObject);
  private
    procedure mudarAba(indice: integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

procedure TfrmPrincipal.mudarAba(indice: integer);
begin
  TabControl.GotoVisibleTab(indice, TTabTransition.Slide);
end;

procedure TfrmPrincipal.Image3Click(Sender: TObject);
begin
  mudarAba(TImage(Sender).tag);
end;

end.
