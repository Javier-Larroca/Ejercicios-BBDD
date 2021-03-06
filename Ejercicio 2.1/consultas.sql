Use Blueprint
--  1) Listado de todos los clientes.
	Select * From Clientes
--  2) Listado de todos los proyectos.
	Select * From Proyectos
--  3) Listado con nombre, descripción, costo, fecha de inicio y de fin de todos los proyectos.
	Select Nombre, Descripcion, Costo, FechaInicio, FechaFin From Proyectos
--  4) Listado con nombre, descripción, costo y fecha de inicio de todos los proyectos con costo mayor a cien mil pesos.
	Select Nombre, Descripcion, Costo, FechaInicio from Proyectos where Costo>100000
--  5) Listado con nombre, descripción, costo y fecha de inicio de todos los proyectos con costo menor a cincuenta mil pesos .
	Select Nombre, Descripcion, Costo, FechaInicio from Proyectos where costo<50000
--  6) Listado con todos los datos de todos los proyectos que comiencen en el año 2020.
	Select * from Proyectos where YEAR(FechaInicio) = 2000
--  7) Listado con nombre, descripción y costo de los proyectos que comiencen en el año 2020 y cuesten más de cien mil pesos.
	Select Nombre, Descripcion, Costo From Proyectos Where Year(FechaInicio) = 2020 AND Costo > 100000
--  8) Listado con nombre del proyecto, costo y año de inicio del proyecto.
	Select Nombre, Costo, FechaInicio from Proyectos
--  9) Listado con nombre del proyecto, costo, fecha de inicio, fecha de fin y días de duración de los proyectos.
	Select Nombre, Costo, FechaInicio, FechaFin,DATEDIFF(DAY, FechaInicio,FechaFin) as Dias from Proyectos
-- 10) Listado con razón social, cuit y teléfono de todos los clientes cuyo IDTipo sea 1, 3, 5 o 6
	Select RazonSocial, Cuit, TelefonoFijo, TelefonoMovil From Clientes Where (IDTipoCliente = 1) OR (IDTipoCliente = 3) OR (IDTipoCliente = 5) OR (IDTipoCliente = 6)
	Select RazonSocial, Cuit, TelefonoFijo, TelefonoMovil From Clientes Where IDTipoCliente IN(1,3,5,6)
-- 11) Listado con nombre del proyecto, costo, fecha de inicio y fin de todos los proyectos que no pertenezcan a los clientes 1, 5 ni 10.
	Select Nombre, Costo, FechaInicio, FechaFin From Proyectos Where IDCliente NOT IN (1,5,10)
-- 12) Listado con nombre del proyecto, costo y descripción de aquellos proyectos que hayan comenzado entre el 1/1/2018 y el 24/6/2018.
	Select Nombre, Costo, Descripcion From Proyectos Where FechaInicio Between '01/01/2018' AND '24/06/2018' 
-- 13) Listado con nombre del proyecto, costo y descripción de aquellos proyectos que hayan finalizado entre el 1/1/2019 y el 12/12/2019.
	Select Nombre, Costo, Descripcion From Proyectos where FechaFin Between '01/01/2019' And '12/12/2019'
-- 14) Listado con nombre de proyecto y descripción de aquellos proyectos que aún no hayan finalizado.
	Select Nombre, Descripcion from Proyectos Where FechaFin Is NULL
-- 15) Listado con nombre de proyecto y descripción de aquellos proyectos que aún no hayan comenzado.
	Select Nombre, Descripcion From Proyectos Where FechaInicio<getDate()
-- 16) Listado de clientes cuya razón social comience con letra vocal.
	Select * from Clientes Where RazonSocial Like '[AEIOU]%'
-- 17) Listado de clientes cuya razón social finalice con vocal.
	Select * from Clientes Where RazonSocial Like '%[AEIOU]'
-- 18) Listado de clientes cuya razón social finalice con la palabra 'Inc'
	Select * From Clientes Where RazonSocial Like '%Inc'
-- 19) Listado de clientes cuya razón social no finalice con vocal.
	Select * From Clientes Where RazonSocial NOT Like '%[AEIOU]'
-- 20) Listado de clientes cuya razón social no contenga espacios.
	Select * From Clientes Where RazonSocial NOT Like '% %'
-- 21) Listado de clientes cuya razón social contenga más de un espacio.
	Select * From Clientes Where RazonSocial Like '% % %'
-- 22) Listado de razón social, cuit, email y celular de aquellos clientes que tengan mail pero no teléfono.
	Select RazonSocial, Cuit, Email, TelefonoMovil From Clientes Where Email Is NOT Null and TelefonoFijo Is NULL
-- 23) Listado de razón social, cuit, email y celular de aquellos clientes que no tengan mail pero sí teléfono.
	Select RazonSocial, Cuit, Email, TelefonoMovil From Clientes Where Email Is Null and TelefonoFijo Is NOT Null
-- 24) Listado de razón social, cuit, email, teléfono o celular de aquellos clientes que tengan mail o teléfono o celular .
	Select RazonSocial, Cuit, Email, TelefonoFijo, TelefonoMovil From Clientes Where Email Is NOT Null OR TelefonoFijo Is NOT Null OR TelefonoMovil Is Not Null
-- 25) Listado de razón social, cuit y mail. Si no dispone de mail debe aparecer el texto "Sin mail".
	Select RazonSocial, Cuit, IsNull(Email, 'Sin mail') From Clientes
-- 26) Listado de razón social, cuit y una columna llamada Contacto con el mail, si no posee mail, con el número de celular y si no posee número de celular con un texto que diga "Incontactable".
	Select RazonSocial, Cuit, Coalesce(Email, TelefonoMovil, TelefonoFijo, 'Incontactable') AS Contacto From Clientes 