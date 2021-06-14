--Listar por cada viaje: El ID, el fecha, la capacidad del camión que lo realiza y la cantidad 
--de paquetes de hasta 50 kilos y la cantidad de paquetes que superen los 50 kilos que transportó dicho viaje. (20 puntos)
Select V.ID, V.Fecha, C.Capacidad, (
	Select Count(P.ID)
	From Paquetes as P1
	Inner Join Viajes as V1 on P.IDViaje=V1.ID
	Where V.ID=V1.ID and P.Peso <= 50
) as 'Menor de 50' , (
	Select Count(P.ID)
	From Paquetes as P
	Inner Join Viajes as V1 on P.IDViaje=V1.ID
	Where V.ID=V1.ID and P.Peso <= 50
) as 'Mayor de 50'
From Viajes as V 
Inner Camiones as C on V.Patente=C.Patente

--Listar la información de los camiones que hayan realizado viajes el año pasado y que hayan llevado al 
--menos un paquete de más de 150 kilos. (20 puntos)
Select C.Patente, C.Año, C.Capacidad, 
From Camiones as C
Where (
	Select Count(V.ID)
	From Camiones as C1
	Left Join Viajes as V on C1.Patente=V.Patente
	Left Join Paquetes as P on V.ID=P.IDViaje
	Where YEAR(V.Fecha) = '2020' and P.Peso>150  and C1.Patente=C.Patente
   ) > 0 

--Listar la información del viaje más largo. Incluir en el listado el ID, la fecha del viaje y los Kms. (10 puntos)

Use Mensajeria
Select Top(1) ID, Fecha, Kms
From Viajes 
Order by Kms Desc 

--Listar los ID de los viajes que hayan llevado en el año 2019, en promedio, más de 40 kilos por encomienda. (20 puntos)
Select V.ID 
From Viajes as V
Inner Join Paquetes as P V.ID=P.IDViaje
Where YEAR(V.Fecha) = '2019' and 40 < (
	Select AVG(P1.Peso)
	From Paquetes as P1
	Inner Join Viajes as V1 on P1.ID=V1.IDViaje
	Where V1.ID=V.ID 
)

--Realizar la normalización, creación de tablas y relaciones de una base de datos que permita registrar subastas7
--y que muchos usuarios puedan realizar muchas ofertas a dicha subasta.

--Se debe asegurar que:
--Una subasta tenga una descripción, un precio base, un usuario y una fecha de inicio y fin.
--Un usuario no pueda repetir su mail y además registre su DNI, apellidos y nombres.
--Una oferta tenga una subasta, un usuario, una fecha y un precio.

Create database Remates
GO
Use Remates
GO
Create table Usuarios(
	ID Int Primary Key Identity(1,1),
	DNI int Unique not null,
	Mail varchar(30) unique not null,
	Apellido varchar(20) not null,
	Nombres varchar(20) not null
)

GO
Create table Subastas(
	ID int Primary Key identity(1,1),
	Descripcion varchar (30) not null,
	PrecioBase Money not null,
	IDUsuario int Foreign Key references Usuarios(ID),
	FechaInicio date not null Check (FechaInicio>=GetDate()),
	FechaFin date not null --Check (FechaFin>FechaInicio)
)
ALTER TABLE Subastas add constraint CHK_Fechafin check(FechaFin>= FechaInicio)
GO
Create table Ofertas(
	IDSubaste Int Foreign Key References Subastas(ID),
	IDUsuario Int Foreign Key REferences Usuarios(ID),
	Fecha date not null,
	Precio money not null
)
