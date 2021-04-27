Use BluePrint

--1 La cantidad de colaboradores
Select Count(Id) as 'Cantidad de colaboradores' From Colaboradores

--2 La cantidad de colaboradores nacidos entre 1990 y 2000.
SET DATEFORMAT 'DMY'
Select Count(Id) as 'Cantidad de colaboradores' From Colaboradores Where FechaNacimiento Between '01/01/1990' And '31/12/2000'

--3 El promedio de precio hora base de los tipos de tareas
Select Avg(PrecioHoraBase) From TiposTarea

--4 El promedio de costo de los proyectos iniciados en el año 2019.
Select Avg(CostoEstimado) From Proyectos Where Year(FechaInicio)=2019

--5 El costo más alto entre los proyectos de clientes de tipo 'Unicornio'
Select Max(CostoEstimado) From Proyectos Inner Join Clientes on Proyectos.IDCliente=Clientes.ID 
Inner Join TiposCliente on Clientes.IDTipo=TiposCliente.Id 
Where TiposCliente.Nombre='Unicornio'


--6 El costo más bajo entre los proyectos de clientes del país 'Argentina'
Select Min(CostoEstimado) From Proyectos Inner Join Clientes on Proyectos.IdCliente=Clientes.Id
Inner Join Ciudades on Clientes.ID=Ciudades.ID Inner Join Paises on Ciudades.IDPais=Paises.ID
Where Paises.Nombre In ('Argentina')

--7 La suma total de los costos estimados entre todos los proyectos.
Select Sum(CostoEstimado) From Proyectos

--8 Por cada ciudad, listar el nombre de la ciudad y la cantidad de clientes.
Select Ci.Nombre, Count(*) as 'Cantidad de clientes' 
From Ciudades as Ci Inner Join Clientes as Cl on Ci.ID=Cl.IDCiudad
Group by Ci.Nombre

--9 Por cada país, listar el nombre del país y la cantidad de clientes.
Select P.Nombre, Count(*) as 'Cantidad de Cliente' 
From Paises as P Inner Join Ciudades on P.ID=Ciudades.IDPais Inner Join Clientes on Ciudades.Id=Clientes.IDCiudad
Group by P.Nombre

--10 Por cada tipo de tarea, la cantidad de colaboraciones registradas. Indicar el
--tipo de tarea y la cantidad calculada.
Select TT.Nombre, Count(*) as 'Cantidad de colaboraciones'
From TiposTarea as TT Inner Join Tareas on TT.ID=Tareas.IDTipo Inner Join Colaboraciones on Tareas.ID=Colaboraciones.IDTarea
Group by TT.Nombre Order by TT.Nombre Asc

--11 Por cada tipo de tarea, la cantidad de colaboradores distintos que la hayan
--realizado. Indicar el tipo de tarea y la cantidad calculada.
Select TT.Nombre, count(Col.ID) From TiposTarea as TT Inner Join Tareas on TT.ID=Tareas.IDTipo
Inner Join Colaboraciones as Co on Tareas.ID=Co.IDTarea Inner Join Colaboradores as Col on Co.IDColaborador=Col.ID
Group by TT.Nombre 

--12 Por cada módulo, la cantidad total de horas trabajadas. Indicar el ID, nombre
--del módulo y la cantidad totalizada. Mostrar los módulos sin horas registradas con 0.
Select Distinct(M.Id), M.Nombre, Sum(Col.Tiempo) as 'Suma de tiempo'
From Modulos as M 
Right Join Tareas on M.ID=Tareas.IDModulo
Inner Join Colaboraciones as Col on Tareas.ID=Col.IDTarea
Group by M.Id, M.Nombre

--13 Por cada módulo y tipo de tarea, el promedio de horas trabajadas. Indicar el ID
--y nombre del módulo, el nombre del tipo de tarea y el total calculado.
Select M.Id, M.Nombre, TT.Nombre, Avg(Col.Tiempo) as 'Promedio de horas'
From Modulos as M
Inner Join Tareas on M.ID=Tareas.IDModulo
Inner Join Colaboraciones as Col on Tareas.Id=Col.IDTarea
Inner Join TiposTarea as TT on Tareas.IDTipo=TT.ID
Group By M.Id, M.Nombre, TT.Nombre

--14 Por cada módulo, indicar su ID, apellido y nombre del colaborador y total que
--se le debe abonar en concepto de colaboraciones realizadas en dicho módulo.
Select M.Id, M.Nombre as 'Nombre de Modulo', Col.Apellido, Col.Nombre, Sum(Co.PrecioHora*Co.Tiempo) as 'Total a abonar'
From Modulos as M
Inner Join Tareas on M.ID=Tareas.IDModulo
Inner Join Colaboraciones as Co on Tareas.Id=Co.IDTarea
Inner Join Colaboradores as Col on Co.IDColaborador=Col.Id
Group By M.Id, M.Nombre, Col.Apellido, Col.Nombre Order by M.Id Asc

--15 Por cada proyecto indicar el nombre del proyecto y la cantidad de horas
--registradas en concepto de colaboraciones y el total que debe abonar en concepto de colaboraciones.
Select Pr.Nombre, Sum(Co.Tiempo) as 'Cantidad de horas', Sum(Co.Tiempo * Co.PrecioHora) as 'Total a abonar'
From Proyectos as Pr
Inner Join Modulos on Pr.ID=Modulos.IDProyecto
Inner Join Tareas on Modulos.ID=Tareas.IDModulo
Inner Join Colaboraciones as Co on Tareas.ID=Co.IDTarea
Group By Pr.Nombre

--16 Listar los nombres de los proyectos que hayan registrado menos de cinco
--colaboradores distintos y más de 100 horas total de trabajo.
Select Pr.Nombre
From Proyectos as Pr
Inner Join Modulos on Pr.ID=Modulos.IDProyecto
Inner Join Tareas on Modulos.ID=Tareas.IDModulo
Inner Join Colaboraciones as Co on Tareas.ID=Co.IDTarea 
Group By Pr.Nombre
Having (Count(Co.IDColaborador)<5) And (Sum(Co.Tiempo)>100)


--17 Listar los nombres de los proyectos que hayan comenzado en el año 2020 que
--hayan registrado más de tres módulos.
Select Pr.Nombre
From Proyectos as Pr
Inner Join Modulos as M on Pr.ID=M.IDProyecto
Where Year(Pr.FechaInicio) = '2020'
Group By Pr.Nombre
Having Count(M.ID)>3

--18 Listar para cada colaborador externo, el apellido y nombres y el tiempo
--máximo de horas que ha trabajo en una colaboración.
Select Col.Apellido, Col.Nombre, Max(Co.Tiempo)
From Colaboradores as Col
Inner Join Colaboraciones as Co on Col.ID=Co.IDColaborador
Where Col.Tipo= 'E'
Group By Col.Apellido, Col.Nombre

--19 Listar para cada colaborador interno, el apellido y nombres y el promedio
--percibido en concepto de colaboraciones.
Select Col.Apellido, Col.Nombre, Avg(Co.Tiempo*Co.PrecioHora)
From Colaboradores as Col
Inner Join Colaboraciones as Co on Col.ID=Co.IDColaborador
Where Col.Tipo= 'I'
Group By Col.Apellido, Col.Nombre

--20 Listar el promedio percibido en concepto de colaboraciones para
--colaboradores internos y el promedio percibido en concepto de
--colaboraciones para colaboradores externos.
Select Col.Tipo, Avg(Co.Tiempo*Co.PrecioHora)
From Colaboradores as Col
Inner Join Colaboraciones as Co on Col.ID=Co.IDColaborador
Group By Col.Tipo

--21 Listar el nombre del proyecto y el total neto estimado. Este último valor surge
--del costo estimado menos los pagos que requiera hacer en concepto de
--colaboraciones.
Select Pr.Nombre as 'Nombre Proyecto', Pr.CostoEstimado-IsNull(Sum(Co.Tiempo*Co.PrecioHora),0) as 'Total neto'
From Proyectos as Pr
Inner Join Modulos as M on Pr.Id=M.IDProyecto
Inner Join Tareas as T on M.Id=T.IDModulo
Inner Join Colaboraciones as Co on T.ID=Co.IDTarea
Group By Pr.Nombre, Pr.CostoEstimado

--22 Listar la cantidad de colaboradores distintos que hayan colaborado en alguna
--tarea que correspondan a proyectos de clientes de tipo 'Unicornio'.
Select Count(Distinct(Col.Id)) as 'Cantidad de colaboradores'
From Colaboradores as Col
Inner Join Colaboraciones on Col.ID=Colaboraciones.IDColaborador
Inner Join Tareas on Colaboraciones.IDTarea=Tareas.ID
Inner Join Modulos on Tareas.IDModulo=Modulos.ID
Inner Join Proyectos on Modulos.IDProyecto=Proyectos.ID
Inner Join Clientes on Proyectos.IDCliente=Clientes.ID
Inner Join TiposCliente on Clientes.IDTipo=TiposCliente.ID
Where TiposCliente.Nombre='Unicornio'

--23 La cantidad de tareas realizadas por colaboradores del país 'Argentina'.
Select Count(Distinct T.Id)
From Tareas as T
Inner Join Colaboraciones on T.ID=Colaboraciones.IDTarea
Inner Join Colaboradores on Colaboraciones.IDColaborador=Colaboradores.ID
Inner Join Ciudades on Colaboradores.IDCiudad=Ciudades.ID
Inner Join Paises on Ciudades.IDPais=Paises.ID
Where Paises.Nombre='Argentina'

--24 Por cada proyecto, la cantidad de módulos que se haya estimado mal la fecha
--de fin. Es decir, que se haya finalizado antes o después que la fecha estimada.
--Indicar el nombre del proyecto y la cantidad calculada.
Select Pr.Nombre, Count(M.Id) as 'Cantidad'
From Proyectos as Pr
Inner Join Modulos as M on Pr.ID=M.IDProyecto
Where M.FechaEstimadaFin<>M.FechaFin
Group By Pr.Nombre
Order by Cantidad desc