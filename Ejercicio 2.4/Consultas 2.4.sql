Use BluePrint

--1 Listar los nombres de proyecto y costo estimado de aquellos proyectos cuyo
--costo estimado sea mayor al promedio de costos.
Select Pr.Nombre, Pr.CostoEstimado
From Proyectos as Pr
Where IsNull(Pr.CostoEstimado,0) >
	(
	Select Avg(Pro.CostoEstimado)
	From Proyectos as Pro
	) 

--2 Listar razón social, cuit y contacto (email, celular o teléfono) de aquellos
--clientes que no tengan proyectos que comiencen en el año 2020.
SET DATEFORMAT 'DMY'

select C.RazonSocial, C.CUIT, COALESCE(C.EMail, C.Celular, C.Telefono) as Contacto  from Clientes as C
where C.ID not in (
	select P.IDCliente 
	from Proyectos as P
	where YEAR(P.FechaInicio) = '2020'
)

--3 Listado de países que no tengan clientes relacionados.
select * from paises where id not in (
    select distinct p.id from paises p
    inner join ciudades c on p.id = c.IDPais
    inner join clientes cl on c.ID = cl.IDCiudad
)

--4 Listado de proyectos que no tengan tareas registradas.

Select Nombre 
from Proyectos 
Where ID not in (
	Select Distinct Pr.ID from Proyectos as Pr
	Inner Join Modulos on Pr.ID=Modulos.IDProyecto
	Inner Join Tareas on Modulos.ID=Tareas.IDModulo
	)

--5 Listado de tipos de tareas que no registren tareas pendientes.

Select Nombre from TiposTarea Where ID not in (
	Select TT.ID from TiposTarea as TT 
	Inner Join Tareas on TT.ID=Tareas.IDTipo
	Where Tareas.FechaFin is null
	)

--6 Listado con ID, nombre y costo estimado de proyectos cuyo costo estimado sea menor al costo estimado de cualquier 
-- proyecto de clientes extranjeros (clientes que no sean de Argentina o no tengan asociado un país).

Select ID, Nombre, CostoEstimado 
From Proyectos 
Where CostoEstimado < (
	Select min(Pr.CostoEstimado) 
	from Proyectos as Pr
	Inner Join Clientes on Pr.IDCliente=Clientes.ID
	Left Join Ciudades on Clientes.IDCiudad=Ciudades.ID
	Left Join Paises on Ciudades.IDPais=Paises.ID
	where Paises.Nombre = 'Argentina' or Clientes.IDCiudad is null
	)

--7 Listado de apellido y nombres de colaboradores que hayan demorado más en
--una tarea que el colaborador de la ciudad de 'Buenos Aires' que más haya demorado.

Select Distinct Col.Apellido, Col.Nombre 
From Colaboradores as Col
Inner Join Colaboraciones as Co on Col.ID=Co.IDColaborador
Where Co.Tiempo > (
	Select Max(Co2.Tiempo) 
	From Colaboraciones as Co2
	Inner Join Colaboradores as Col2 on Co2.IDColaborador=Col2.ID
	Inner Join Ciudades on Col2.IDCiudad=Ciudades.Id
	Where Ciudades.Nombre like 'Buenos Aires'
	)


--8 Listado de clientes indicando razón social, nombre del país (si tiene) y
--cantidad de proyectos comenzados y cantidad de proyectos por comenzar.

Select Cl.RazonSocial, COALESCE(Pa.Nombre, 'No tiene'), 
(
	Select Count(Pr.ID) 
	from Proyectos as Pr 
	Inner Join Clientes as Cli on Pr.IDCliente=Cli.ID 
	Where Cli.ID=Cl.ID and Pr.FechaInicio>GETDATE()
) as 'Proyec sin comenzar', 
(
	Select Count(Pr.ID) 
	from Proyectos as Pr 
	Inner Join Clientes as Cli on Pr.IDCliente=Cli.ID 
	Where Cli.ID=Cl.ID and Pr.FechaInicio<=GETDATE()
) as 'Proyectos comenzados'
From Clientes as Cl 
Left Join Ciudades as Ci on Cl.IDCiudad=Ci.ID
Left Join Paises as Pa on Ci.IDPais=Pa.ID


--9 Listado de tareas indicando nombre del módulo, nombre del tipo de tarea,
--cantidad de colaboradores externos que la realizaron y cantidad de colaboradores internos que la realizaron.

Select M.Nombre as 'Nombre Modulo', TT.Nombre as 'Nombre Tipo Tarea',
(
	Select Count(Cola.ID) 
	from Colaboradores as Cola 
	Inner Join Colaboraciones as Colab on Cola.ID=Colab.IDColaborador 
	Inner Join Tareas as Ta on Colab.IDTarea=Ta.ID 
	Where Cola.Tipo='E' and Ta.ID=T.ID
) as 'Colaboradores Externos',
(
	Select Count(Cola.ID) 
	from Colaboradores as Cola 
	Inner Join Colaboraciones as Colab on Cola.ID=Colab.IDColaborador 
	Inner Join Tareas as Ta on Colab.IDTarea=Ta.ID 
	Where Cola.Tipo='I' and Ta.ID=T.ID
) as 'Colaboradores Internos'
From Modulos as M
Inner Join Tareas as T on M.ID=T.IDModulo
Inner Join TiposTarea as TT on T.IDTipo=TT.ID


--10 Listado de proyectos indicando nombre del proyecto, costo estimado,
--cantidad de módulos cuya estimación de fin haya sido exacta, cantidad de
--módulos con estimación adelantada y cantidad de módulos con estimación demorada.
--Adelantada → estimación de fin haya sido inferior a la real.
--Demorada → estimación de fin haya sido superior a la real.

--11 Listado con nombre del tipo de tarea y total abonado en concepto de
--honorarios para colaboradores internos y total abonado en concepto de
--honorarios para colaboradores externos.

--12 Listado con nombre del proyecto, razón social del cliente y saldo final del
--proyecto. El saldo final surge de la siguiente fórmula:
--Costo estimado - Σ(HCE) - Σ(HCI) * 0.1
--Siendo HCE → Honorarios de colaboradores externos y HCI → Honorarios de colaboradores internos.

--13 Para cada módulo listar el nombre del proyecto, el nombre del módulo, el total
--en tiempo que demoraron las tareas de ese módulo y qué porcentaje de
--tiempo representaron las tareas de ese módulo en relación al tiempo total de tareas del proyecto.

--14 Por cada colaborador indicar el apellido, el nombre, 'Interno' o 'Externo' según
--su tipo y la cantidad de tareas de tipo 'Testing' que haya realizado y la
--cantidad de tareas de tipo 'Programación' que haya realizado.
--NOTA: Se consideran tareas de tipo 'Testing' a las tareas que contengan la
--palabra 'Testing' en su nombre. Ídem para Programación.

--15 Listado apellido y nombres de los colaboradores que no hayan realizado tareas de 'Diseño de base de datos'.

Select Col.Apellido, Col.Nombre 
From Colaboradores Col
Where Col.Id Not In (
	Select Cola.Id
	From Colaboradores as Cola 
	Inner Join Colaboraciones as Colab on Cola.ID=Colab.IDColaborador
	Inner Join Tareas as T on Colab.IDTarea=T.ID
	Inner Join TiposTarea as TT on T.IDTipo=TT.ID
	Where TT.Nombre='Diseño de base de datos'
	)


--16 Por cada país listar el nombre, la cantidad de clientes y la cantidad de colaboradores

select p.Nombre,
(
    select count(*) from Clientes C
    inner join Ciudades C1 on C1.ID = C.IDCiudad
    where C1.IDPais = p.ID
) as Clientes,
(
    select count(*) from Colaboradores C
    inner join Ciudades C1 on C1.ID = C.IDCiudad
    where C1.IDPais = p.ID
) as Colaboradores
 from paises p


-- 17 Listar por cada país el nombre, la cantidad de clientes y la cantidad de colaboradores de aquellos países que no tengan clientes pero sí colaboradores.
Select *
from (
    select p.Nombre,
    (
        select count(*) from Clientes C
        inner join Ciudades C1 on C1.ID = C.IDCiudad
        where C1.IDPais = p.ID
    ) as Clientes,
    (
        select count(*) from Colaboradores C
        inner join Ciudades C1 on C1.ID = C.IDCiudad
        where C1.IDPais = p.ID
    ) as Colaboradores
    from paises p
) as MiTabla
Where MiTabla.Clientes = 0 and MiTabla.Colaboradores > 0

--18 Listar apellidos y nombres de los colaboradores internos que hayan realizado
--más tareas de tipo 'Testing' que tareas de tipo 'Programación'.

--19 Listar los nombres de los tipos de tareas que hayan abonado más del
--cuádruple en colaboradores internos que externos

--20 Listar los proyectos que hayan registrado igual cantidad de estimaciones
--demoradas que adelantadas y que al menos hayan registrado alguna
--estimación adelantada y que no hayan registrado ninguna estimación exacta.