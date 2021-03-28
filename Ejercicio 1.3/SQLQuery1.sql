create database blueprints
GO
use blueprints
GO
create table TiposClientes(
	IdTipo int not null primary key identity (1,1),
	Descripcion varchar(18) not null
)
Insert into TiposClientes(Descripcion) values ('Estatal')
Insert into TiposClientes(Descripcion) values ('Multinacional')
Insert into TiposClientes(Descripcion) values ('Educativo privado')
Insert into TiposClientes(Descripcion) values ('Educativo publico')
Insert into TiposClientes(Descripcion) values ('Sin fines de lucro')
GO
create table Clientes(
	ID int not null primary key identity (1,1),
	RazonSocial varchar(30) not null,
	Cuit int not null unique,
	TipoCliente int not null foreign key references TiposClientes(IdTipo),
	Mail varchar(35) null,
	Tel varchar (15) null,
	Cel varchar (15) null,
)
GO
create table Proyecto(
	ID int not null primary key identity (1,1),
	Nombre varchar (20) not null,
	Descripcion varchar(100) null,
	IdCliente int not null foreign key references Clientes(ID),
	FechaInicio date not null,
	FechaFin date null,
	CostoEstimado money not null,
	Estado bit not null
)