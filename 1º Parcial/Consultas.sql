Use parcial1

--1)Listado con Apellido y nombres de los técnicos que hayan prestado servicios a más
--de veinte clientes distintos.

Select T.Apellido, T.Nombre
From Tecnicos as T
Where (
	Select Count(Distinct C.ID)
	From Clientes as C
	Inner Join Servicios as S on C.ID=S.IDCliente
	Inner Join Tecnicos as T1 on S.IDTecnico=T1.ID
	Where T1.ID=T.ID	
	) > 20

--2) Listado con ID, Apellido y nombres de los clientes que no hayan solicitado servicios
--de tipo "Reparacion de lavarropas" en el año 2020.

Select C.ID, C.Apellido, C.Nombre 
From Clientes as C
Where C.ID Not in (
	Select C1.ID
	From Clientes as C1
	Inner Join Servicios as S on C1.ID=S.IDCliente
	Inner Join TiposServicio as TS on S.IDTipo=TS.ID
	Where TS.Descripcion Like 'Reparacion de lavarropas' and YEAR(S.Fecha) = '2020')

--3) Listado con Apellido y nombres de los clientes, cantidad de servicios solicitados con
--garantía y cantidad de servicios solicitados sin garantía

Select C.Apellido, C.Nombre, (
	Select Count(S.ID)
	From Servicios as S
	Inner Join Clientes as C1 on S.IDCliente=C1.ID
	Where C.ID=C1.ID and S.DiasGarantia>0
) as 'Cant. Serv. C/ Garantia', (
	Select Count(S.ID)
	From Servicios as S
	Inner Join Clientes as C1 on S.IDCliente=C1.ID
	Where C.ID=C1.ID and S.DiasGarantia=0
) as 'Cant. Serv. S/ Garantia'
From Clientes as C

--4) Apellido y nombres de los técnicos que recaudaron más en servicios abonados en
--tarjeta que servicios abonados con efectivo. Pero que hayan recaudado con efectivo
--más de la mitad de su recaudación con tarjeta.

Select TablaTecnicos.Apellido, TablaTecnicos.Nombre
From (
	Select  T2.Apellido, T2.Nombre, (
		Select Sum(S.Importe)
		From Servicios as S
		Inner Join Tecnicos as T1 on S.IDTecnico=T1.ID
		Where T2.ID=T1.ID and S.FormaPago='T'
	) as TT, (
		Select Sum(S.Importe)
		From Servicios as S
		Inner Join Tecnicos as T1 on S.IDTecnico=T1.ID
		Where T2.ID=T1.ID and S.FormaPago='E'
	) as TE
	From Tecnicos as T2
	) as TablaTecnicos
Where TablaTecnicos.TT>TablaTecnicos.TE and TablaTecnicos.TE>TablaTecnicos.TT/2


--5) Agregar las tablas y/o restricciones que considere necesario para permitir a los
--técnicos registrar todos los insumos que le fueron necesarios para realizar un
--servicio. Por cada insumo necesario se registrará una descripción, un costo y un
--origen del insumo (I - Importado o N - Nacional)

USE parcial1
Create Table Insumos(
	ID Int Primary Key Identity (1,1),
	IDServicio int not null Foreign Key References Servicios(ID),
	Descripcion varchar(50) not null,
	Costo money not null Check (Costo>=0),
	Origen char not null Check (Origen= 'I' Or Origen = 'N')
)