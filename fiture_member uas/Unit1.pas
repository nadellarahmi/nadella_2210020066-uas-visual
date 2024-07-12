unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZAbstractConnection, ZConnection, Grids, DBGrids, StdCtrls, DBCtrls,
  frxClass, frxDBSet;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    DBGrid1: TDBGrid;
    Button6: TButton;
    ZConnection1: TZConnection;
    zqry: TZQuery;
    DataSource1: TDataSource;
    DBComboBox1: TDBComboBox;
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DBComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
// Mengaktifkan komponen input
   Edit1.Enabled := True;
   Edit2.Enabled := True;
   Edit3.Enabled := True;
   Edit4.Enabled := True;
   Edit5.Enabled := True;
   DBComboBox1.Enabled := True;
   Label8.Enabled := True;

  // Mengaktifkan tombol SIMPAN dan BATAL
  Button2.Enabled := True;
  Button5.Enabled := True;

  // Menonaktifkan tombol BARU, EDIT, dan HAPUS sementara
  Button1.Enabled := False;
  Button3.Enabled := False;
  Button4.Enabled := False;

  // Membersihkan input sebelumnya
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';
  Edit5.Text := '';
  DBComboBox1.Text := '';

  // Fokus pada input pertama (NIK)
  Edit1.SetFocus;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  try
    // Menyusun perintah SQL untuk menyisipkan data ke dalam tabel kustomer
    zqry.SQL.Clear;
    zqry.SQL.Add('INSERT INTO kustomer (NIK, NAMA, TELP, EMAIL, ALAMAT, MEMBER) ' +
                       'VALUES (:NIK, :NAMA, :TELP, :EMAIL, :ALAMAT, :MEMBER)');

    // Menetapkan nilai parameter dari input pengguna
    zqry.Params.ParamByName('NIK').AsString := Edit1.Text;
    zqry.Params.ParamByName('NAMA').AsString := Edit2.Text;
    zqry.Params.ParamByName('TELP').AsString := Edit3.Text;
    zqry.Params.ParamByName('EMAIL').AsString := Edit4.Text;
    zqry.Params.ParamByName('ALAMAT').AsString := Edit5.Text;
    zqry.Params.ParamByName('MEMBER').AsString := DBComboBox1.Text;

    // Mengeksekusi perintah SQL
    zqry.ExecSQL;

    // Menyusun perintah SQL untuk membuka data yang telah dimasukkan
    zqry.SQL.Clear;
    zqry.SQL.Add('SELECT * FROM kustomer');
    zqry.Open;

    // Menampilkan pesan sukses
    ShowMessage('Data Berhasil di Simpan!');

    // Refresh DBGrid
    DBGrid1.DataSource.DataSet := zqry;
    DBGrid1.Refresh;

    // Menonaktifkan komponen input dan tombol SIMPAN serta BATAL
    Edit1.Enabled := False;
    Edit2.Enabled := False;
    Edit3.Enabled := False;
    Edit4.Enabled := False;
    Edit5.Enabled := False;
    Button2.Enabled := False;
    Button5.Enabled := False;

    // Mengaktifkan kembali tombol BARU, EDIT, dan HAPUS
    Button1.Enabled := True;
    Button3.Enabled := True;
    Button4.Enabled := True;
  except
    on E: Exception do
      ShowMessage('Terjadi kesalahan: ' + E.Message);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
begin
  try
    // Validasi NIK
    if Trim(Edit1.Text) = '' then
    begin
      ShowMessage('NIK tidak boleh kosong.');
      Exit;
    end;

    // Validasi Nama
    if Trim(Edit2.Text) = '' then
    begin
      ShowMessage('Nama tidak boleh kosong.');
      Exit;
    end;

    // Menyiapkan perintah SQL untuk memperbarui data customer berdasarkan NIK
    Form1.zqry.SQL.Clear;
    Form1.zqry.SQL.Add('UPDATE kustomer SET NAMA = :nama, TELP = :telp, ' +
                          'EMAIL = :email, ALAMAT = :alamat WHERE NIK = :nik');

    // Menetapkan nilai parameter
    Form1.zqry.Params.ParamByName('nama').AsString := Edit2.Text;    // Nama baru
    Form1.zqry.Params.ParamByName('telp').AsString := Edit3.Text;    // Telp baru
    Form1.zqry.Params.ParamByName('email').AsString := Edit4.Text;  // Email baru
    Form1.zqry.Params.ParamByName('alamat').AsString := Edit5.Text;  // Alamat baru
    Form1.zqry.Params.ParamByName('nik').AsString := Edit1.Text;      // NIK dari baris yang akan diperbarui

    // Mengeksekusi perintah SQL
    Form1.zqry.ExecSQL;

    // Menyusun perintah SQL untuk membuka data yang telah dimasukkan
    zqry.SQL.Clear;
    zqry.SQL.Add('SELECT * FROM kustomer');
    zqry.Open;

    // Refresh DBGrid
    DBGrid1.DataSource.DataSet := zqry;
    DBGrid1.Refresh;

    // Menampilkan pesan sukses
    ShowMessage('Data customer berhasil diupdate untuk NIK yang dimasukkan!');
  except
    on E: Exception do
      ShowMessage('Terjadi kesalahan: ' + E.Message);
  end;
end;
end;

procedure TForm1.DBComboBox1Change(Sender: TObject);
begin
case DBComboBox1.ItemIndex of
    0: // Jika memilih 'YES'
       Label8.Caption := 'Diskon: 10%';
    1: // Jika memilih 'NO'
       Label8.Caption := 'Diskon: 5%';
    // Anda bisa menambahkan kasus lain jika diperlukan
  else
    Label8.Caption := 'Pilih status member';
end;

end;
procedure TForm1.FormCreate(Sender: TObject);
begin
  DBComboBox1.Items.Clear;  // Pastikan ComboBox kosong sebelum menambahkan item
  DBComboBox1.Items.Add('yes');      // Tambahkan item "YES"
  DBComboBox1.Items.Add('Non');  // Tambahkan item "Non"
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  idToDelete: string;
begin
  idToDelete := Edit1.Text; // Mengambil nilai dari edt1.Text sebagai ID yang akan dihapus

  // Kosongkan field-field yang ingin direset setelah penghapusan
  Edit1.Text := '';
  Edit2.Text := '';

  // Menghapus data dari tabel kustomer berdasarkan ID yang dipilih
  with Form1.zqry do
  begin
    SQL.Clear;
    SQL.Add('DELETE FROM kustomer WHERE nik = :nik');
    Params.ParamByName('nik').AsString := idToDelete; // Gunakan nilai ID yang diambil dari edt1.Text
    ExecSQL;

    SQL.Clear;
    SQL.Add('SELECT * FROM kustomer');
    Open;
  end;

  ShowMessage('Data berhasil dihapus!');
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
Edit1.Text :='';
Edit2.Text :='';
Edit3.Text :='';
Edit4.Text :='';
Edit5.Text :='';
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
try
    // Memuat file laporan FastReport
    frxReport1.LoadFromFile('LaporanMember.fp3');

    // Menghubungkan dataset ke laporan
    frxDBDataset1.DataSet := zqry;
    
    // Membuka dataset
    zqry.Open;
    
    // Menampilkan preview laporan
    frxReport1.ShowReport;
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

end.
