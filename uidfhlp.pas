unit uidfhlp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTabstractESRIgrid, uTSingleESRIgrid,
  Vcl.StdCtrls, math, uerror, AVGRIDIO;

type
  TForm3 = class(TForm)
    SingleESRIgrid1: TSingleESRIgrid;
    SingleESRIgrid2: TSingleESRIgrid;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  filename1, filename2, filename3: string;
  iResult, nrows, ncols, i, j: Integer;
  aValue1, aValue2: Single;
  optie: String;
  count: integer;
begin
  optie := uppercase(paramstr(1));
  filename1 := paramstr(2);
  filename2 := paramstr(3);
  filename3 := paramstr(4);

  SingleESRIgrid1 := TSingleESRIgrid.InitialiseFromIDFfile( filename1, iResult, self );
  SingleESRIgrid2 := TSingleESRIgrid.InitialiseFromIDFfile( filename2, iResult, self );
  nrows:=SingleESRIgrid1.NRows;
  ncols:=SingleESRIgrid1.NCols;

  count := 0;
  for i := 1 to NRows do
    for j := 1 to NCols do begin
      aValue1 := SingleESRIgrid1[i,j];
      aValue2 := SingleESRIgrid2[i,j];
      if ((not SingleESRIgrid1.IsMissing(i,j)) and (not SingleESRIgrid2.IsMissing(i,j))) then begin
        if ( optie = 'MAX' ) then
          SingleESRIgrid1[i,j] := max(aValue1, aValue2)
        else if ( optie = 'MIN' ) then
          SingleESRIgrid1[i,j] := min(aValue1, aValue2)
      end else if (SingleESRIgrid1.IsMissing(i,j) and (not SingleESRIgrid2.IsMissing(i,j))) then
        begin
          SingleESRIgrid1[i,j] := aValue2;
          Inc( count );
        end
      else if ((not SingleESRIgrid1.IsMissing(i,j) and SingleESRIgrid2.IsMissing(i,j))) then begin
        SingleESRIgrid1[i,j] := aValue1;
        Inc( count );
      end;
    end;
  SingleESRIgrid1.ExportToIDFfile( filename3 );

  WriteToLogFile( 'MissingSingle=' + FloatToStr( MissingSingle ) );
  WriteToLogFile( 'Nr of novalues overwritten: ' + inttoStr( count ) );
  {MessageDlg( filename3, mtInformation, [mbOk], 0);}
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  InitialiseLogFile;
  InitialiseGridIO;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
FinaliseLogFile;
end;

end.
