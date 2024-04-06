unit uDM;

interface

uses
  System.SysUtils, System.Classes, urestDWDataModule;

type
  Tdm = class(TServerMethodDataModule)
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

end.
