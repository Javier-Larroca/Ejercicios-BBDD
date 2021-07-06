Use BluePrint

--1) Hacer un reporte que liste por cada tipo de tarea se liste el nombre, el precio de hora base y el promedio
--de valor hora real (obtenido de las colaboraciones).

Alter View VWA_ReporrttesTiposTareas as	
Select Aux.*, Aux.PromPrecioHora-Aux.PrecioHoraBase as Dif From (
Select TT.Nombre, TT.PrecioHoraBase, (
	Select AVG(C.Preciohora) 
	From Colaboraciones as C
	Inner Join Tareas as T on C.IDTarea=T.ID
	Inner Join TiposTarea as TTT on T.IDTipo=TTT.Id
	Where TTT.ID=TT.ID) as Prom
from TiposTarea as TT
)as aux

Select * from VWA_ReporrttesTiposTareas

--2) Modificar el reporte de (1) para que también liste una columna llamada
--Variación con las siguientes reglas:
--Poca → Si la diferencia entre el promedio y el precio de hora base es menor a $500.
--Mediana → Si la diferencia entre el promedio y el precio de hora base está entre $501 y $999.
--Alta → Si la diferencia entre el promedio y el precio de hora base es $1000 o más.

Alter View VWA_ReporrttesTiposTareas as	
Select TT.Nombre, TT.PrecioHoraBase, (
	Select AVG(C.Preciohora) 
	From Colaboraciones as C
	Inner Join Tareas as T on C.IDTarea=T.ID
	Inner Join TiposTarea as TTT on T.IDTipo=TTT.Id
	Where TTT.ID=TT.ID) as Prom
from TiposTarea as TT

Select * from VWA_ReporrttesTiposTareas

