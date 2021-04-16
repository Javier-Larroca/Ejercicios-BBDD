Use BluePrint

-- 1)Por cada cliente listar razón social, cuit y nombre del tipo de cliente.
--Select Cl.RazonSocial, Cl.Cuit, TC.Nombre as TipoCliente from Clientes as Cl Inner Join TiposCliente as TC ON Cl.IDTipo = TC.ID

-- 2)Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Sólo de aquellos clientes que posean ciudad y país.
--select CL.razonsocial, CL.cuit, C.nombre as Ciudad, P.nombre as Pais From Clientes as CL Inner Join Ciudades as C ON C.ID = CL.IDCiudad Inner Join Paises as P ON P.ID = C.IDPais

-- 3)Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Listar también los datos de aquellos clientes que no tengan ciudad relacionada.
--select CL.razonsocial, CL.cuit, C.nombre as Ciudad, P.nombre as Pais From Clientes as CL Left Join Ciudades as C ON C.ID = CL.IDCiudad Left Join Paises as P ON P.ID = C.IDPais

-- 4)Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Listar también los datos de aquellas ciudades y países que no tengan clientes relacionados.
--select CL.razonsocial, CL.cuit, C.nombre as Ciudad, P.nombre as Pais 
--From Clientes as CL Right Join Ciudades as C ON C.ID = CL.IDCiudad Right Join Paises as P ON P.ID = C.IDPais

-- 5)Listar los nombres de las ciudades que no tengan clientes asociados. Listar también el nombre del país al que pertenece la ciudad.
--select C.nombre as Ciudad, P.nombre as Pais 
--From Clientes as CL Right Join Ciudades as C ON C.ID = CL.IDCiudad Right Join Paises as P ON P.ID = C.IDPais Where CL.ID is null

--6)Listar para cada proyecto el nombre del proyecto, el costo, la razón social del cliente, el nombre del tipo de cliente y el nombre de la 
--ciudad (si la tiene registrada) de aquellos clientes cuyo tipo de cliente sea 'Extranjero' o 'Unicornio'.
Select Pr.Nombre, Pr.CostoEstimado, Cl.RazonSocial, TC.Nombre as NombreTipoCliente, Ci.Nombre as NombreCiudad 
From Proyectos as Pr Inner Join Clientes as Cl on Pr.IDCliente = Cl.ID Inner Join TiposCliente as TC on Cl.IDTipo = TC.ID 
Inner Join Ciudades as Ci on Cl.IDCiudad = Ci.ID Where TC.Nombre IN ('Extranjero', 'Unicornio')

--7)Listar los nombre de los proyectos de aquellos clientes que sean de los países'Argentina' o 'Italia'.

--8)Listar para cada módulo el nombre del módulo, el costo estimado del módulo, el nombre del proyecto, 
--la descripción del proyecto y el costo estimado del proyecto de todos aquellos proyectos que hayan finalizado.

--9)Listar los nombres de los módulos y el nombre del proyecto de aquellos módulos cuyo tiempo estimado de realización sea de más de 100 horas.

--10)Listar nombres de módulos, nombre del proyecto, descripción y tiempo estimado de aquellos módulos cuya fecha estimada de fin 
--sea mayor a la fecha real de fin y el costo estimado del proyecto sea mayor a cien mil.

--11)Listar nombre de proyectos, sin repetir, que registren módulos que hayan finalizado antes que el tiempo estimado.

--12)

--13)

--14)

--15)

--16)

--17)

--18)

--19)

--20)