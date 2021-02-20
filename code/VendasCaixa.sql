create database VendasCaixa

use VendasCaixa



CREATE TABLE CAIXA
(
	Cod				int IDENTITY (1,1) CONSTRAINT PK_Caixa PRIMARY KEY,
    Data            DATETIME,
    SaldoInicial	DECIMAL(10,2),
    SaldoFinal		DECIMAL(10,2)
)

CREATE TABLE CLIENTE
(
	ClienteCodigo	int IDENTITY (1,1) CONSTRAINT PK_Cliente PRIMARY KEY,
    ClienteNome		varchar(30),
	ClienteCPF		varchar(11)
)

CREATE TABLE PRODUTO
(
	ProdutoCodigo	int IDENTITY (1,1) CONSTRAINT PK_Produto PRIMARY KEY,
    DescProd		varchar(30),
	Marca			varchar(20),
	Valor			DECIMAL(10,2)
)


create TABLE VENDAS
(	
    Data			DATETIME,
    CodigoVenda		int IDENTITY (1,1) CONSTRAINT PK_vendas PRIMARY KEY,
	CodCaixa		INT,
	ClienteCodigo	INT,
	ClienteNome		VARCHAR(30),
	CodProduto		INT,
	ValorProd		DECIMAL(10,2),
    ValorVenda		DECIMAL(10,2),
	Lucro			DECIMAL(10,2)
	
	CONSTRAINT FK_Cliente_Codigo FOREIGN KEY (ClienteCodigo) REFERENCES CLIENTE(ClienteCodigo),
	CONSTRAINT FK_Caixa_Vendas FOREIGN KEY (CodCaixa) REFERENCES CAIXA(Cod),
	CONSTRAINT FK_Produto FOREIGN KEY (CodProduto) REFERENCES PRODUTO(ProdutoCodigo)
)
GO

INSERT INTO CAIXA
VALUES (GETDATE(), 0, 0)
GO

INSERT INTO CLIENTE
VALUES ('Christopher Miranda', '00000000000')
GO

INSERT INTO PRODUTO
VALUES ('Maquina Barbear', 'HomiBarbudo', 200.00)
GO

CREATE TRIGGER DeleteVenda
ON VENDAS
FOR DELETE
AS
BEGIN
    DECLARE
    @VALOR  DECIMAL(10,2),
    @DATA   DATETIME,
	@COD	INT
 
    SELECT @COD = CodCaixa, @VALOR = ValorVenda FROM DELETED
 
    UPDATE CAIXA SET SaldoFinal = SaldoFinal - @VALOR
    WHERE Cod = @COD
END
GO


CREATE PROCEDURE PROCVENDAS

@CODCAIXA INT, @CLIENTECODIGO INT, @CODPROD INT, @VALORVENDA DECIMAL(10,2)
AS 
BEGIN

	DECLARE @VALORPRODUTO DECIMAL (10,2)


	SELECT @VALORPRODUTO = Valor FROM PRODUTO WHERE ProdutoCodigo = @CODPROD

	INSERT INTO VENDAS(Data, CodCaixa, ClienteCodigo, ClienteNome, CodProduto,  ValorProd, ValorVenda)
	VALUES (GETDATE(), @CODCAIXA, @CLIENTECODIGO, 'Christopher Miranda', @CODPROD, @VALORPRODUTO, @VALORVENDA)

 
	DECLARE @CODVENDA INT 
	SET @CODVENDA = (select @@IDENTITY)
  
		UPDATE VENDAS SET Lucro = @VALORVENDA - @VALORPRODUTO    WHERE CodigoVenda = @CODVENDA
		UPDATE CAIXA SET SaldoFinal = SaldoFinal + @VALORVENDA WHERE Cod = @CODCAIXA

END


EXECUTE PROCVENDAS 
   1
  ,1
  ,1
  ,317.40
GO



Delete from VENDAS
WHERE CodigoVenda = 1



ALTER VIEW LUCROS AS
SELECT DESCPROD as Produto 
FROM PRODUTO
union all
SELECT SUM(Lucro) as Lucro FROM VENDAS, PRODUTO
WHERE CodProduto = ProdutoCodigo


select * FROM VENDAS
select * FROM CAIXA
select * FROM PRODUTO
select * FROM CLIENTE
select * FROM LUCROS



drop database VendasCaixa