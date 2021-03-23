create database universidad
GO
use universidad 
GO
create table Carreras(
	ID varchar (4) not null primary key,
	Nombre varchar(40) not null,
	FechaCreacion date not null check (FechaCreacion < getdate()),
	Mail varchar(100) not null,
	Nivel varchar(12) not null check (Nivel ='Diplomatura'or Nivel='Pregrado' or Nivel='Grado' or Nivel='Posgrado')
)
GO
create table Materias(
	ID bigint not null primary key identity(1,1),
	IdCarrera varchar (4) not null foreign key references Carreras(ID),
	Nombre varchar(40) not null,
	CargaHoraria int not null check (CargaHoraria > 0)
)
GO
create table Alumnos(
	Legajo bigint not null primary key identity(1000,1),
	IdCarrera varchar (4) not null foreign key references Carreras(ID),
	Apellidos varchar (40) null,
	Nombres varchar (40) null,
	FechaNacimiento date not null check (FechaNacimiento	 < getdate()),
	Mail varchar (100) not null unique,
	Telefono varchar (20) null
)