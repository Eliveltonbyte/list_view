unit DataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.IOUtils;

type
  TDm = class(TDataModule)
    Conn: TFDConnection;
    qryPedido: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure ConnBeforeConnect(Sender: TObject);
    procedure ConnAfterConnect(Sender: TObject);
  private

    { Private declarations }
  public
  procedure ListarPedidos(id_pedido, cliente: string; dt_de,
      dt_ate: TDateTime; vl_de, vl_ate: double);
    { Public declarations }
  end;

var
  Dm: TDm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDm.ConnAfterConnect(Sender: TObject);
begin
  Conn.ExecSQL('CREATE TABLE IF NOT EXISTS TAB_PEDIDO ( ' +
                            'ID_PEDIDO          VARCHAR(20) NOT NULL PRIMARY KEY, ' +
                            'CLIENTE            VARCHAR(100), ' +
                            'DT_PEDIDO          DATETIME, ' +
                            'VL_TOTAL           DECIMAL (12, 2));'
                );

    Conn.ExecSQL('INSERT OR REPLACE INTO TAB_PEDIDO (ID_PEDIDO, CLIENTE, DT_PEDIDO, VL_TOTAL)' +
                 'VALUES(''00001'', ''99 Coders'', ''2023-01-15'', 500)');

    Conn.ExecSQL('INSERT OR REPLACE INTO TAB_PEDIDO (ID_PEDIDO, CLIENTE, DT_PEDIDO, VL_TOTAL)' +
                 'VALUES(''00002'', ''Kalunga'', ''2023-01-16'', 246)');

    Conn.ExecSQL('INSERT OR REPLACE INTO TAB_PEDIDO (ID_PEDIDO, CLIENTE, DT_PEDIDO, VL_TOTAL)' +
                 'VALUES(''00003'', ''ABC Peças'', ''2023-01-15'', 952)');

    Conn.ExecSQL('INSERT OR REPLACE INTO TAB_PEDIDO (ID_PEDIDO, CLIENTE, DT_PEDIDO, VL_TOTAL)' +
                 'VALUES(''00004'', ''Walmart'', ''2023-01-16'', 1250)');

    Conn.ExecSQL('INSERT OR REPLACE INTO TAB_PEDIDO (ID_PEDIDO, CLIENTE, DT_PEDIDO, VL_TOTAL)' +
                 'VALUES(''00005'', ''Pão de Açúcar'', ''2023-01-16'', 431)');

    Conn.ExecSQL('INSERT OR REPLACE INTO TAB_PEDIDO (ID_PEDIDO, CLIENTE, DT_PEDIDO, VL_TOTAL)' +
                 'VALUES(''00006'', ''Posto Ipiranga'', ''2023-01-17'', 3210)');

    Conn.ExecSQL('INSERT OR REPLACE INTO TAB_PEDIDO (ID_PEDIDO, CLIENTE, DT_PEDIDO, VL_TOTAL)' +
                 'VALUES(''00007'', ''LATAM'', ''2023-01-18'', 620)');

    Conn.ExecSQL('INSERT OR REPLACE INTO TAB_PEDIDO (ID_PEDIDO, CLIENTE, DT_PEDIDO, VL_TOTAL)' +
                 'VALUES(''00008'', ''Petrobras'', ''2023-01-19'', 4125)');
end;

procedure TDm.ConnBeforeConnect(Sender: TObject);
begin

    //conexão sqlLite...[System.IOUtils em uses]
    Conn.DriverName := 'SQLite';

    {$IFDEF MSWINDOWS}
    Conn.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\banco.db';
    {$ELSE}
    Conn.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'banco.bd');
    {$ENDIF}
end;

procedure TDm.DataModuleCreate(Sender: TObject);
begin
    Conn.Connected := true;
end;

procedure TDm.ListarPedidos(id_pedido, cliente: string;
                            dt_de, dt_ate: TDateTime;
                            vl_de, vl_ate: double);
begin
    with qryPedido do
    begin
        Active := false;
        SQL.Clear;
        SQL.Add('select * from tab_pedido');
        SQL.Add('where id_pedido <> '''' ');

        if id_pedido <> '' then
        begin
            SQL.Add('and id_pedido = :id_pedido');
            ParamByName('id_pedido').Value := id_pedido;
        end;

        if cliente <> '' then
        begin
            SQL.Add('and cliente like :cliente');
            ParamByName('cliente').Value := '%' + cliente + '%';
        end;

        if (dt_de > 0) and (dt_ate > 0) then
        begin
            SQL.Add('and dt_pedido >= :dt_de');
            SQL.Add('and dt_pedido <= :dt_ate');
            ParamByName('dt_de').Value := FormatDateTime('yyyy-mm-dd', dt_de);
            ParamByName('dt_ate').Value := FormatDateTime('yyyy-mm-dd', dt_ate);
        end;

        if (vl_de > 0) and (vl_de > 0) then
        begin
            SQL.Add('and vl_total >= :vl_de');
            SQL.Add('and vl_total <= :vl_ate');
            ParamByName('vl_de').Value := vl_de;
            ParamByName('vl_ate').Value := vl_ate;
        end;

        SQL.Add('order by id_pedido desc');

        Active := true;
    end;
end;

end.
