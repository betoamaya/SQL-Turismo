SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
-- =============================================
-- Responsable:		Roberto Amaya
-- Ultimo Cambio:	31/10/2018
-- Descripción:		Anexar XML
-- =============================================
ALTER PROCEDURE [dbo].[Interfaz_GastoAnexarXML]
    @Usuario CHAR(10),
    @Id INT,
    @PathDestino VARCHAR(255),
    @Partidas VARCHAR(MAX),
    @NumErr INT = NULL OUTPUT,
    @Descripcion VARCHAR(255) = NULL OUTPUT
AS
SET NOCOUNT ON;
SET DATEFORMAT YMD;

-- ******************************************************
--        VARIABLES
-- ******************************************************

DECLARE @LogParametrosXML XML;
SET @LogParametrosXML =
(
    SELECT @Usuario AS 'Usuario',
           @Id AS 'Id',
           @PathDestino AS 'PathDestino',
           @Partidas AS 'Partidas'
    FOR XML PATH('Parametros')
);

EXEC dbo.Interfaz_LogsInsertar 'Interfaz_GastoAnexarXML',
                               'Inserción',
                               '',
                               @Usuario,
                               @LogParametrosXML;

DECLARE @tPartidas AS TABLE
(
    ID INT IDENTITY(1, 1) NOT NULL,
    Nombre VARCHAR(255)
);

DECLARE @MensajeError AS VARCHAR(MAX),
        @Error AS INT,
        @Mensaje AS VARCHAR(512),
        @PathComprueba VARCHAR(255);

DECLARE @XML XML;
SET @XML = CAST(@Partidas AS XML);
IF NOT @Partidas IS NULL
BEGIN
    INSERT INTO @tPartidas
    SELECT T.Loc.value('@Nombre', 'varchar(255)') AS Nombre
    FROM @XML.nodes('//row/fila') AS T(Loc);
END;
ELSE
BEGIN
    SET @MensajeError = 'Parametro partidas vacio o Nulo. Por favor indique partidas a registrar';
    SELECT @NumErr = 0,
           @Descripcion = @MensajeError;
    EXEC dbo.Interfaz_LogsInsertar 'Interfaz_GastoAnexarXML',
                                   'Error de Validación',
                                   @MensajeError,
                                   @Usuario,
                                   @LogParametrosXML;
    RAISERROR(@MensajeError, 16, 1);
    RETURN;
END;

DECLARE @Result_SP TABLE
(
    ID INT IDENTITY(1, 1) NOT NULL,
    Empresa VARCHAR(5),
    Mov VARCHAR(20),
    MovId VARCHAR(20),
    EMPD VARCHAR(10),
    PROVD VARCHAR(20),
    EJERD VARCHAR(10),
    MESD VARCHAR(10),
    IDD VARCHAR(20),
    PathOrig VARCHAR(300),
    PathDest VARCHAR(300)
);

-- ******************************************************
--        OBTENER RUTA DESTINO
-- ******************************************************

INSERT @Result_SP
EXEC dbo.spSelUbicDestXmlyPdf_Macv @ID = @Id, @Mod = 'gas';

SELECT TOP 1
    @PathComprueba = rs.PathDest
FROM @Result_SP rs;

-- ******************************************************
--        VALIDACIONES
-- ******************************************************

IF @Usuario <> 'SITTI'
BEGIN
    SET @MensajeError = 'Usuario no valido. Por favor, indique un Usuario valido para la ejecución de este proceso.';
    SELECT @NumErr = 0,
           @Descripcion = @MensajeError;
    EXEC dbo.Interfaz_LogsInsertar 'Interfaz_GastoAnexarXML',
                                   'Error de Validación',
                                   @MensajeError,
                                   @Usuario,
                                   @LogParametrosXML;
    RAISERROR(@MensajeError, 16, 1);
    RETURN;
END;

IF EXISTS
(
    SELECT *
    FROM @tPartidas tp
    WHERE tp.Nombre IS NULL
          OR LEN(tp.Nombre) <= 5
)
BEGIN
    SET @MensajeError
        = 'Por lo menos una de las partidas no cumple con el formato correcto. Por favor, indique partidas validas a registrar.';
    SELECT @NumErr = 0,
           @Descripcion = @MensajeError;
    EXEC dbo.Interfaz_LogsInsertar 'Interfaz_GastoAnexarXML',
                                   'Error de Validación',
                                   @MensajeError,
                                   @Usuario,
                                   @LogParametrosXML;
    RAISERROR(@MensajeError, 16, 1);
    RETURN;
END;

IF @Id IS NULL
   OR @Id = 0
BEGIN
    SET @MensajeError = 'Parametro Id nulo o igual a 0. Por favor indique Id valido';
    SELECT @NumErr = 0,
           @Descripcion = @MensajeError;
    EXEC dbo.Interfaz_LogsInsertar 'Interfaz_GastoAnexarXML',
                                   'Error de Validación',
                                   @MensajeError,
                                   @Usuario,
                                   @LogParametrosXML;
    RAISERROR(@MensajeError, 16, 1);
    RETURN;
END;

IF NOT EXISTS (SELECT * FROM dbo.Gasto g WHERE g.ID = @Id)
BEGIN
    SET @MensajeError = 'El Id indicado no es valido. Por favor indique Id valido.';
    SELECT @NumErr = 0,
           @Descripcion = @MensajeError;
    EXEC dbo.Interfaz_LogsInsertar 'Interfaz_GastoAnexarXML',
                                   'Error de Validación',
                                   @MensajeError,
                                   @Usuario,
                                   @LogParametrosXML;
    RAISERROR(@MensajeError, 16, 1);
    RETURN;
END;

IF @PathDestino IS NULL
   OR RTRIM(@PathDestino) = ''
BEGIN
    SET @MensajeError = 'Ruta del archivo es nula o vacia. Por favor indique Ruta de archivo valida';
    SELECT @NumErr = 0,
           @Descripcion = @MensajeError;
    EXEC dbo.Interfaz_LogsInsertar 'Interfaz_GastoAnexarXML',
                                   'Error de Validación',
                                   @MensajeError,
                                   @Usuario,
                                   @LogParametrosXML;
    RAISERROR(@MensajeError, 16, 1);
    RETURN;
END;

IF @PathDestino <> @PathComprueba
BEGIN
    SET @MensajeError = 'Ruta del archivo no es correcta. Compruebe la Ruta del archivo e indique Ruta valida';
    SELECT @NumErr = 0,
           @Descripcion = @MensajeError;
    EXEC dbo.Interfaz_LogsInsertar 'Interfaz_GastoAnexarXML',
                                   'Error de Validación',
                                   @MensajeError,
                                   @Usuario,
                                   @LogParametrosXML;
    RAISERROR(@MensajeError, 16, 1);
    RETURN;
END;

-- ******************************************************
--        Anexar XML
-- ******************************************************


DECLARE @Min INT,
        @Max INT,
        @NombreA VARCHAR(255),
        @PathDestinoA VARCHAR(255);
SELECT @Min = MIN(tp.ID)
FROM @tPartidas tp;
SELECT @Max = MAX(tp.ID)
FROM @tPartidas tp;

WHILE @Min <= @Max
BEGIN
    SELECT @NombreA = RTRIM(tp.Nombre),
           @PathDestinoA = RTRIM(@PathDestino) + '\' + RTRIM(tp.Nombre)
    FROM @tPartidas tp
    WHERE tp.ID = @Min;
    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.AnexoMov am
        WHERE am.Rama = 'GAS'
              AND am.ID = @Id
              AND am.Nombre = am.Nombre
              AND Direccion = @PathDestinoA
    )
    BEGIN
        BEGIN TRY
            EXEC dbo.spInsArchAnexoMov @Rama = 'GAS',
                                       @ID = @Id,
                                       @Nombre = @NombreA,
                                       @Direccion = @PathDestinoA;
        END TRY
        BEGIN CATCH

            SELECT @Error = ERROR_NUMBER(),
                   @Mensaje
                       = '(SP ' + ISNULL(ERROR_MESSAGE(), '') + ', ln ' + ISNULL(CAST(ERROR_LINE() AS VARCHAR), '')
                         + ') ' + ISNULL(ERROR_MESSAGE(), '');
        END CATCH;

        IF @@ERROR <> 0
        BEGIN
            SET @MensajeError
                = '/ Error = ' + RTRIM(CAST(ISNULL(@Error, -1) AS VARCHAR(255))) + ', Mensaje = '
                  + RTRIM(ISNULL(@Mensaje, ''));
            SELECT @NumErr = 0,
                   @Descripcion = @MensajeError;
            EXEC dbo.Interfaz_LogsInsertar 'Interfaz_GastoAnexarXML',
                                           'Error',
                                           @MensajeError,
                                           @Usuario,
                                           @LogParametrosXML;
            RAISERROR(@MensajeError, 16, 1);
            RETURN;
        END;
    END;

    -- Se incrementa el ciclo
    SELECT @Min = MIN(tp.ID)
    FROM @tPartidas tp
    WHERE tp.ID > @Min;
END;

-- ******************************************************
--        Parametros de Retorno
-- ******************************************************

SELECT @NumErr = 1,
       @Descripcion = 'Se anexo correctamente los archivos indicados.';
SELECT @NumErr AS 'NumErr',
       @Descripcion AS 'Descripcion';

GO
