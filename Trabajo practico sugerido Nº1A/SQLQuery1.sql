create database libreria
GO
use libreria
GO
create table Articulos(
	ID varchar(6) not null primary key,
	Descripcion varchar(100) not null,
	Marca varchar(20) not null,
	PrecioCompra int not null,
	PrecioVenta int not null,
	Ganancia int not null,
	TipoArticulo varchar (100) not null,
	StockMinimo int not null,
	StockActual int not null,
	StockPEM int (StockActual-StockMinimo),
	Estado bit
)
GO
create table Ventas(

)
GO
create table Clientes(

)
create table Vendedores(

)