unit data;

interface

uses
  System.SysUtils, System.Classes, uLanguages, System.ImageList, Vcl.ImgList,
  Vcl.Controls, SVGIconImageListBase, SVGIconImageList, Vcl.ExtCtrls, Vcl.Menus;

type
  TUtilModule = class(TDataModule)
    Language: TLanguage;
    SVGIconImageList1: TSVGIconImageList;
    SVGIconImageList2: TSVGIconImageList;
    SVGIconImageList3: TSVGIconImageList;
    SVGIconImageList4: TSVGIconImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UtilModule: TUtilModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
