Use BluePrint

-- 1)Por cada cliente listar razón social, cuit y nombre del tipo de cliente.
Select Cl.RazonSocial, Cl.Cuit, TC.Nombre as TipoCliente from Clientes as Cl Inner Join TiposCliente as TC ON Cl.IDTipo = TC.ID

-- 2)Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Sólo de aquellos clientes que posean ciudad y país.
Select CL.razonsocial, CL.cuit, C.nombre as Ciudad, P.nombre as Pais 
From Clientes as CL Inner Join Ciudades as C ON C.ID = CL.IDCiudad Inner Join Paises as P ON P.ID = C.IDPais

-- 3)Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Listar también los datos de aquellos clientes que no tengan ciudad relacionada.
Select CL.RazonSocial, CL.Cuit, C.Nombre as Ciudad, P.Nombre as Pais 
From Clientes as CL Left Join Ciudades as C ON C.ID = CL.IDCiudad Left Join Paises as P ON P.ID = C.IDPais

-- 4)Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Listar también los datos de aquellas ciudades y países 
--que no tengan clientes relacionados.
Select CL.RazonSocial, CL.Cuit, C.Nombre as Ciudad, P.Nombre as Pais 
From Clientes as CL Right Join Ciudades as C ON C.ID = CL.IDCiudad Right Join Paises as P ON P.ID = C.IDPais

-- 5)Listar los nombres de las ciudades que no tengan clientes asociados. Listar también el nombre del país al que pertenece la ciudad.
select C.nombre as Ciudad, P.nombre as Pais 
From Clientes as CL Right Join Ciudades as C ON C.ID = CL.IDCiudad Right Join Paises as P ON P.ID = C.IDPais Where CL.ID is null

--6)Listar para cada proyecto el nombre del proyecto, el costo, la razón social del cliente, el nombre del tipo de cliente y el nombre de la 
--ciudad (si la tiene registrada) de aquellos clientes cuyo tipo de cliente sea 'Extranjero' o 'Unicornio'.
Select Pr.Nombre, Pr.CostoEstimado, Cl.RazonSocial, TC.Nombre as NombreTipoCliente, Ci.Nombre as NombreCiudad 
From Proyectos as Pr Inner Join Clientes as Cl on Pr.IDCliente = Cl.ID Inner Join TiposCliente as TC on Cl.IDTipo = TC.ID 
Inner Join Ciudades as Ci on Cl.IDCiudad = Ci.ID Where TC.Nombre IN ('Extranjero', 'Unicornio')

--7)Listar los nombre de los proyectos de aquellos clientes que sean de los países'Argentina' o 'Italia'.
Select Pr.Nombre From Proyectos as Pr Inner Join  Clientes as Cl on Pr.IDCliente = Cl.ID Inner Join Ciudades as Ci on Cl.IDCiudad = Ci.ID 
Inner Join Paises as P on Ci.IDPais = P.ID Where P.Nombre IN ('Argentina', 'Italia')

--8)Listar para cada módulo el nombre del módulo, el costo estimado del módulo, el nombre del proyecto, 
--la descripción del proyecto y el costo estimado del proyecto de todos aquellos proyectos que hayan finalizado.
Select M.Nombre as NombreModulo, M.CostoEstimado, Pr.Nombre as NombreProyecto, Pr.Descripcion, Pr.CostoEstimado as CostoEstimadoProyecto 
From Modulos as M Inner Join Proyectos as Pr on M.IDProyecto = Pr.ID 
Where Pr.FechaFin Is Not Null And Pr.FechaFin<=getDate()

--9)Listar los nombres de los módulos y el nombre del proyecto de aquellos módulos cuyo tiempo estimado de realización sea de más de 100 horas.
Select M.Nombre as 'Nombre de Modulo', Pr.Nombre as 'Nombre de Proyecto' 
From Modulos as M inner join Proyectos as Pr on M.IDProyecto=Pr.ID
Where M.TiempoEstimado>100

--10)Listar nombres de módulos, nombre del proyecto, descripción y tiempo estimado de aquellos módulos cuya fecha estimada de fin 
--sea mayor a la fecha real de fin y el costo estimado del proyecto sea mayor a cien mil.
Select M.Nombre as 'Nombre de modulo', Pr.Nombre as 'Nombre de proyecto', Pr.Descripcion, M.TiempoEstimado
From Modulos as M Inner Join Proyectos as Pr on M.IDProyecto=Pr.ID
Where M.FechaEstimadaFin>M.FechaFin and Pr.CostoEstimado>100000
Order By M.Nombre Asc

--11)Listar nombre de proyectos, sin repetir, que registren módulos que hayan finalizado antes que el tiempo estimado.
Select Distinct Pr.Nombre 
From Proyectos as Pr Inner Join Modulos as M on Pr.ID = M.IDProyecto
Where M.FechaFin<M.FechaEstimadaFin	

--12)Listar nombre de ciudades, sin repetir, que no registren clientes pero sí colaboradores.
Select Distinct Ci.Nombre as 'Nombre ciudad'
From Ciudades as Ci Left Join Clientes as Cl on Ci.ID=IDCiudad inner join Colaboradores as Co on Ci.ID=Co.IDCiudad
Where Cl.ID Is Null 
Order by Ci.Nombre Asc

--13)Listar el nombre del proyecto y nombre de módulos de aquellos módulos que contengan la palabra 'login' en su nombre o descripción.
Select Pr.Nombre as 'Nombre de Proyecto', M.Nombre as 'Nombre de Modulo' 
From Proyectos as Pr Inner Join Modulos as M on Pr.ID=M.IDProyecto
Where M.Nombre Like '%login%' Or M.Descripcion Like '%login%'

--14)Listar el nombre del proyecto y el nombre y apellido de todos los colaboradores que hayan realizado algún tipo de tarea cuyo nombre
--contenga 'Programación' o 'Testing'. Ordenarlo por nombre de proyecto de manera ascendente.
Select Pr.Nombre as 'Nombre de Proyecto', Col.Nombre, Col.Apellido 
From Proyectos as Pr Inner Join Modulos on Pr.ID=Modulos.IDProyecto Inner Join Tareas on Modulos.ID=Tareas.IDModulo 
Inner Join TiposTarea on Tareas.IDTipo=TiposTarea.ID
Inner Join Colaboraciones on Tareas.ID=Colaboraciones.IDTarea Inner Join Colaboradores as Col on Colaboraciones.IDColaborador=Col.ID
Where TiposTarea.Nombre Like '%Programacion%' Or TiposTarea.Nombre Like '%Testing%'
Order By Pr.Nombre Asc

--15)Listar nombre y apellido del colaborador, nombre del módulo, nombre del tipo de tarea, precio hora de la colaboración y precio hora
--base de aquellos colaboradores que hayan cobrado su valor hora de colaboración más del 50% del valor hora base.
Select Col.Nombre, Col.Apellido, M.Nombre as NombreModulo, TT.Nombre as NombreTipoTarea, Co.PrecioHora, TT.PrecioHoraBase
From Colaboradores as Col Inner Join Colaboraciones as Co On Col.ID = Co.IDColaborador Inner Join Tareas On Co.IDTarea = Tareas.ID 
Inner Join TiposTarea as TT On Tareas.IDTipo = TT.ID Inner Join Modulos as M on Tareas.IDModulo=M.ID
Where Co.PrecioHora>(TT.PrecioHoraBase * 1.5)

--16)Listar nombres y apellidos de las tres colaboraciones de colaboradores externos que más hayan demorado en realizar alguna tarea cuyo
--nombre de tipo de tarea contenga 'Testing'.
Select Top 3 Col.Nombre, Col.Apellido
From Colaboradores as Col Inner Join Colaboraciones on Col.ID=Colaboraciones.IDColaborador Inner Join Tareas On Colaboraciones.IDTarea=Tareas.Id
Inner Join TiposTarea on Tareas.IDTipo=TiposTarea.Id
Where TiposTarea.Nombre Like '%Testing%' And Col.Tipo ='E'
Order By Colaboraciones.Tiempo Desc

--17)Listar apellido, nombre y mail de los colaboradores argentinos que sean internos y cuyo mail no contenga '.com'.
Select Col.Apellido, Col.Nombre, Col.Email
From Colaboradores as Col Inner Join Ciudades on Col.IDCiudad=Ciudades.ID Inner Join Paises on Ciudades.IDPais=Paises.ID
Where Col.Tipo='I' And Col.Email Not Like '%.Com%'
Order by Col.Apellido  Asc

--18)Listar nombre del proyecto, nombre del módulo y tipo de tarea de aquellas tareas realizadas por colaboradores externos.
Select Distinct Pr.Nombre as 'Nombre de Proyecto', M.Nombre as 'Nombre de Modulo', TT.Nombre as 'Nombre de tarea'
From Proyectos as Pr Inner Join Modulos as M on Pr.ID=M.IDProyecto Inner Join Tareas as T on M.ID=T.IDModulo Inner Join TiposTarea as TT on T.IDTipo=TT.ID
Inner Join Colaboraciones on T.ID=Colaboraciones.IdTarea Inner Join Colaboradores on Colaboraciones.IDColaborador=Colaboradores.ID
Where Colaboradores.Tipo='E'

--19)Listar nombre de proyectos que no hayan registrado tareas.
Select PR.Nombre 
From Proyectos as PR
Left Join Modulos as M on PR.ID = M.IDProyecto
Left Join Tareas as T ON M.ID = T.IDModulo
Where T.ID IS NULL

--20)Listar apellidos y nombres, sin repeticiones, de aquellos colaboradores que hayan trabajado en algún proyecto que aún no haya finalizado.
Select Distinct Col.Apellido, Col.Nombre
From Proyectos as Pr Inner Join Modulos as M on Pr.ID=M.IDProyecto Inner Join Tareas as T on M.ID=T.IDModulo 
Inner Join Colaboraciones on T.ID=Colaboraciones.IdTarea Inner Join Colaboradores  as Col on Colaboraciones.IDColaborador=Col.ID
Where Pr.FechaFin Is Null Order By Col.Apellido Asc
