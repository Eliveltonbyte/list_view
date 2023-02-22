unit UntPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Layouts, FMX.Ani, FMX.DateTimeCtrls, FMX.Edit, System.Math;

type
  TFrmPrincipal = class(TForm)
    rectToolbar: TRectangle;
    lblPrincipal: TLabel;
    spdConfig: TSpeedButton;
    Image1: TImage;
    lvPedido: TListView;
    lytFiltro: TLayout;
    rectFundo: TRectangle;
    rectFiltro: TRectangle;
    imgFechar: TImage;
    rectFiltroBotao: TRectangle;
    spdApFiltro: TSpeedButton;
    edtPedido: TEdit;
    edtCliente: TEdit;
    lytSeparador: TLayout;
    dtInicio: TDateEdit;
    dtFim: TDateEdit;
    lytFinal: TLayout;
    edtValorIni: TEdit;
    edtValorMax: TEdit;
    btnLimpar: TSpeedButton;
    Image2: TImage;
    procedure FormShow(Sender: TObject);
    procedure spdConfigClick(Sender: TObject);
    procedure imgFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure spdApFiltroClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { Private declarations }
    procedure AddPedido(id_pedido, cliente, dt_pedido:string; valor: double);
    procedure ListarPedido;
    procedure OpenMenu;
    procedure closeMenu;
    procedure LimparFiltro;
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses DataModule;



{ TFrmPrincipal }

procedure TFrmPrincipal.AddPedido(id_pedido, cliente,
  dt_pedido: string; valor: double);
var
  item: TListViewItem;
begin
  try
    item := lvPedido.Items.Add;

    with item do
    begin
      Height := 90;
      TagString    := id_Pedido;

      //Num. Pedido..
       TListItemText(Objects.FindDrawable('txtPedido')).Text := id_pedido;

       //Cliente...
       TListItemText(Objects.FindDrawable('txtCliente')).Text:=  cliente;

       // Data Pedido...
       TListItemText(Objects.FindDrawable('txtData')).Text:=  dt_pedido;

       // Valor Pedido
       TListItemText(Objects.FindDrawable('txtValor')).Text:= FormatFloat('R$#,##0.00', valor);


    end;

    except on ex:exception do
    showMessage('Erro ao inserir o pedido na lista' + ex.Message);

  end;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    lytFiltro.Visible := false;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    ListarPedido;
end;

procedure TFrmPrincipal.Image2Click(Sender: TObject);
begin
  LimparFiltro;
  ListarPedido;
end;

procedure TFrmPrincipal.btnLimparClick(Sender: TObject);
begin
    LimparFiltro;
end;

procedure TFrmPrincipal.closeMenu;
begin
 rectFiltro.Margins.Bottom := 0;

  TAnimator.AnimateFloat(rectFiltro, 'Margins.Bottom',-265, 0.5,
                         TAnimationType.InOut,
                         TInterpolationType.Circular);

    TThread.CreateAnonymousThread(procedure
    begin
      sleep(500);
      TThread.Synchronize(TThread.CurrentThread, procedure
      begin
        lytFiltro.Visible := false;
      end);
    end).Start;


end;

procedure TFrmPrincipal.imgFecharClick(Sender: TObject);
begin
   closeMenu;
   LimparFiltro;
end;

procedure TFrmPrincipal.OpenMenu;
begin
  // Objeto retângulo começa fora da tela
  rectFiltro.Margins.Bottom := -265;
  lytFiltro.Visible := true;

  {
  1º Objeto para animação,
  2º Propriedade do objeto que quero alterar,
  3º Valor da propriedade(2º tópico)
  4º Tempo Animação
  5º Tipo da animação
  6º Como a animação vai acontecer
  FMX.Ani - em uses, para funcionar
  }
  TAnimator.AnimateFloat(rectFiltro, 'Margins.Bottom',0, 0.5,
                         TAnimationType.InOut,
                         TInterpolationType.Circular);

end;

procedure TFrmPrincipal.spdApFiltroClick(Sender: TObject);
begin
    closeMenu;
    ListarPedido;
end;

procedure TFrmPrincipal.spdConfigClick(Sender: TObject);
begin
      openMenu;
end;

procedure TFrmPrincipal.LimparFiltro;
begin
    edtPedido.Text := '';
    edtCliente.Text := '';
    dtInicio.IsEmpty := true;
    dtfim.IsEmpty := true;
    edtValorIni.Text := '';
    edtValorMax.Text := '';

    closeMenu;
    ListarPedido;
end;

procedure TFrmPrincipal.ListarPedido;
var
  data_de, data_ate: TDate;
  vl_de, vl_ate: double;
begin
    try
       if dtInicio.IsEmpty then
           data_de := 0
       else
           data_de := dtInicio.Date;

       if dtFim.IsEmpty then
           data_ate := 0
       else
           data_ate := dtFim.Date;

    try
      vl_de := edtValorIni.Text.ToDouble;
    except
      vl_de := 0;
    end;

    try
      vl_ate := edtValorMax.Text.ToDouble;
    except
      vl_ate := 0;
    end;


       DM.ListarPedidos(edtPedido.Text,
                        edtCliente.Text,
                        data_de,
                        data_ate,
                        vl_de,
                        vl_ate);

       lvPedido.BeginUpdate;
       lvPedido.Items.Clear;

       while NOT DM.qryPedido.eof do
       begin
          AddPedido(Dm.qryPedido.fieldbyname('id_pedido').asstring,
                    Dm.qryPedido.fieldbyname('cliente').asstring,
                    FormatDateTime('dd/mm;yyyy', Dm.qryPedido.fieldbyname('dt_pedido').asdatetime),
                    Dm.qryPedido.fieldbyname('vl_total').asfloat);

          Dm.qryPedido.Next;
       end;

    except on ex:exception do
       showMessage('Erro na consulta de pedidod' + ex.Message);

    end;

      lvPedido.EndUpdate;
end;

end.
