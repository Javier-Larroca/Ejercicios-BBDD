Use Parcial2
/*
1)Hacer un trigger que al registrar una captura se verifique que la misma se haya
realizado durante el horario de Inicio y Fin del torneo a la que pertenece. En caso que
se encuentre fuera de ese rango indicarlo con un mensaje de error. De lo contrario,
registrar la captura.
*/

GO
Create Trigger Tr_nueva_captura on Capturas
after insert
as
Begin
	--Capturamos el dato de la fecha y hora de la captura.
	declare @FechaHora datetime
	select @FechaHora = FechaHora from inserted
	--Capturamos el dato del ID del torneo.
	declare @IDTorneo bigint
	select @IDTorneo = IDTorneo from inserted
	--Traemos de la BBDD los horarios del torneo.
	declare @FInicio datetime
	Select @FInicio = T.Inicio from Torneos as T where T.ID=@IDTorneo
	declare @FFin datetime
	Select @FFin = T.Fin from Torneos as T where T.ID=@IDTorneo
	--Corroboramos si la fecha ingresada es correcta.
	if (@FechaHora < @FInicio or @FechaHora>@FFin) begin
        rollback transaction
        raiserror('No se pudo cargar la captura', 16, 1)
    end
End


/*
2)Hacer un trigger que no permita que se carguen un torneo en la misma ciudad a
menos que hayan pasado más de 5 años (desde la última vez que se realizó un
torneo en esa ciudad). Si esto ocurre indicarlo con un mensaje de error. Caso
contrario, registrar el torneo.
NOTA: Se debe usar el campo Año para la comprobación.
*/
GO
Create Trigger Tr_nuevo_torneo on Torneos
after insert
as 
Begin
	--Obetenemos la ciudad del torneo a insertar.
	declare @Ciudad varchar(50)
	select @Ciudad = Ciudad from inserted
	--Obtenemos el año del ultimo torneo en esa ciudad.
	declare @Anio SmallInt
	Select @Anio = Año from Torneos as T where T.Ciudad Like @Ciudad order by Año ASC
	--Comprobamos de que haya traido algun año, en caso contrario le asignamos 0.
	
	if not(@Anio>0) Begin
		Select @Anio = 0
	End
	
	--Obetenemos el año del torneo a ingresar.
	declare @AñoIngresado SmallInt
	Select @AñoIngresado = Año from inserted
	--Comprobamos de que ya hayan pasado 5 años o que no haya habido ningun torneo en esa ciudad.
	if ((@AñoIngresado-@Anio)<=5) Begin
	    rollback transaction
        raiserror('No se pudo cargar el torneo', 16, 1)
	End
End

/*
3)Hacer un trigger que al eliminar una captura sea marcada como devuelta y que al
eliminar una captura que ya se encuentra como devuelta se realice la baja física del
registro.
*/
GO
Create Trigger Tr_elimar_captura on Capturas
instead of delete
as 
Begin
	--Capturamos el nro de captura a eliminar.
	declare @ID bigint
	Select @ID = ID from deleted
	-- Buscamos el estado de esa captura (Si fue o no devuelta)
	declare @Devuelta bit
	Select @Devuelta = Devuelta from Capturas Where ID=@ID
	If (@Devuelta = 0) begin
		Delete from Capturas Where ID=@ID
	end
	If (@Devuelta = 1) begin
		Update Capturas Set Devuelta = 0 Where ID=@ID
	end   
End

/*
4)Hacer un procedimiento almacenado que a partir de un IDTorneo indique los datos del ganador del mismo. 
El ganador es aquel pescador que haya capturado la mayor cantidad (en peso) de peces. 
Indicar Nombre, Apellido, Kilos acumulados y Categoría del pescador: 
('El viejo Santiago' mayor a 65 años, 'Ilia Krusch' entre 23 y 65 años,'Manolín' entre 16 y 22 años).
NOTA: El primer puesto puede ser un empate entre varios competidores, en ese caso mostrar la información de 
todos los ganadores.
*/

Create Procedure Sp_creditos(
	 @IDTorneo bigint
)
as
Begin
	Select Co.Nombre, Co.Apellido, Sum(Ca.Peso) as 'Kilos Acumulados', 'Categoria' from
	Torneos as T
	Inner Join Capturas as Ca on T.ID=Ca.IDTorneo
	Inner Join Competidores as Co on Ca.IDCompetidor=Co.ID
	Where T.ID=@IDTorneo and Sum(Ca.Peso) = (
		Select top (1) Sum(Ca2.Peso) as 'Peso' from
		Torneos as T2
		Inner Join Capturas as Ca2 on T2.ID=Ca.IDTorneo
		Inner Join Competidores as Co2 on Ca.IDCompetidor=Co.ID
		Where T2.ID=@IDTorneo
		Order by Peso desc
	)
End


