unit uMyMutex;

interface

uses
  Classes,
  SysUtils,
  DateUtils;

type
  TMutex = class
  private
    FFilePath: string;
    FFileStream: TFileStream;
  public
    constructor Create(const AName: string);
    destructor Destroy; override;
  end;

implementation

function GetATempDir: string;
begin
//  Result := PathDelim + 'tmp' + PathDelim; // On other systems
  Result := 'C:\temp';
end;

constructor TMutex.Create(const AName: string);
var
  LMask: UInt16;
begin
  inherited Create;
  FFileStream := nil;
  FFilePath := IncludeTrailingPathDelimiter(GetATempDir) + AName + '.pid';
  LMask := fmOpenReadWrite or fmShareExclusive;
  if not FileExists(FFilePath) then
    LMask := LMask or fmCreate;
  FFileStream := TFileStream.Create(FFilePath, LMask);
end;

destructor TMutex.Destroy;
begin
  FreeAndNil(FFileStream);
  inherited;
end;
end.
