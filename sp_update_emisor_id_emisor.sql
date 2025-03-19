USE paycash;
DROP PROCEDURE IF EXISTS sp_update_emisor_id_emisor;
DELIMITER ;;
CREATE PROCEDURE `sp_update_emisor_id_emisor`( 
	IN ck_nIdEmisor INT,
    IN ck_nIdTipoEmisor INT,
    IN ck_sNombreEmisor VARCHAR(80),
    IN ck_sRFC VARCHAR(20),
    IN ck_sIrs VARCHAR(20),
    IN ck_sRazonSocial VARCHAR(150),
    IN ck_sRegimenSocietario  VARCHAR(300),
    IN ck_sNombreComercial VARCHAR(150),
    IN ck_sTelefono VARCHAR(15),
    IN ck_nIdEmpleado INT,
    IN ck_nIdUnidadNegocio INT,
    IN ck_nIdSerie INT,
    IN ck_sSerie CHAR(5),
    IN ck_nComisionAdicional DECIMAL(10, 6),
    IN ck_nIdIntegrador INT,
    IN ck_sEmail VARCHAR(150),
    IN ck_sNombre VARCHAR(50),
    IN ck_sPaterno VARCHAR(50),
	IN ck_sMaterno VARCHAR(50),
	IN ck_nSolicitante INT,
	IN ck_sActividadEconomica VARCHAR(50),
	IN ck_nIdSegmento INT,
    IN ck_nIdPais INT,
    IN ck_nVigencia INT,
    IN ck_dFechaRevision DATE,
    IN ck_transaccionesEstimadas INT,
	IN ck_sBeneficiario VARCHAR(35),
	IN CkdFecContrato VARCHAR(10),
    IN CkbEntidadRegulada BIT,
	IN ck_nIdZonaHoraria INT,
	IN ck_nFacturacionTercero INT,
    IN ck_bCancelaOperaciones BIT,
	IN chkValidacionRegulada BIT

)
    COMMENT 'Actualizara los datos de los emisores'
BEGIN
	/*******************************************************************************
	* Nombre..........: sp_update_emisor_id_emisor
	* Propósito.......: Actualizara los datos de los emisores
	* Autor...........: 
	* Empresa.........: Red Efectiva
	* F. Creación.....: 
	* Modificaciones..:
	* 	Fecha/Autor...: 21/jun/24 - Roberto Bonilla Acosta
	* 	Modificación..: Agregar data de facturación a terceros
	*
	* Ejemplo:
	* 	CALL sp_update_emisor_id_emisor(...);
	*
	********************************************************************************/
 	SET @paso = 1;
	SET @code = 1;
	SET @msg = 'Sin cambios efectuados';

    START TRANSACTION;

    SET @nIdEmisor = ck_nIdEmisor;
	SET @nIdTipoEmisor = ck_nIdTipoEmisor;
	SET @sNombreEmisor = ck_sNombreEmisor;
	SET @sRFC = ck_sRFC;
	SET @sIrs = ck_sIrs;
	SET @sRazonSocial = ck_sRazonSocial;
	SET @sRegimenSocietario = ck_sRegimenSocietario;
	SET @sNombreComercial = ck_sNombreComercial;
	SET @sTelefono = ck_sTelefono;
	SET @nIdEmpleado = ck_nIdEmpleado;
	SET @nIdUnidadNegocio = ck_nIdUnidadNegocio;
	SET @nIdSerie = ck_nIdSerie;
	SET @sSerie = ck_sSerie;
	SET @nComisionAdicional = ck_nComisionAdicional;
	SET @nIdIntegrador = ck_nIdIntegrador;
    SET @sEmail = ck_sEmail;
    SET @sNombre = ck_sNombre;
    SET @sPaterno = ck_sPaterno;
	SET @sMaterno = ck_sMaterno;
	SET @nSolicitante = ck_nSolicitante;
	SET @sActividadEconomica = ck_sActividadEconomica;
	SET @nIdSegmento = ck_nIdSegmento;
    SET @nIdPais = ck_nIdPais;
    SET @nVigencia = ck_nVigencia;
    SET @dFechaRevision = ck_dFechaRevision;
    SET @transaccionesEstimadas = ck_transaccionesEstimadas;
	SET @sBeneficiario = ck_sBeneficiario;
	SET @dFecContrato = CkdFecContrato;
	SET @bEntidadRegulada = CkbEntidadRegulada;
	SET @time_zone = fn_set_zona_horaria();
	SET @nIdZonaHoraria = ck_nIdZonaHoraria;
	SET @nFacturacionTercero = ck_nFacturacionTercero;
    IF @paso = 1 THEN

		SELECT sRFC INTO @sRFC_Actual FROM dat_emisor WHERE nIdEmisor = @nIdEmisor;

        IF @sRFC_Actual = @sRFC THEN
			UPDATE dat_emisor SET
				nIdTipoEmisor = @nIdTipoEmisor,
				sNombreEmisor = @sNombreEmisor,
				sRazonSocial = @sRazonSocial,
				sRegimenSocietario = @sRegimenSocietario,
				sNombreComercial =  @sNombreComercial,
				sTelefono = @sTelefono,
				nIdEmpleado = @nIdEmpleado,
				nIdUnidadNegocio = @nIdUnidadNegocio,
				nIdSerie = @nIdSerie,
				sSerie = @sSerie,
				nComisionAdicional = @nComisionAdicional,
				nIdIntegrador = @nIdIntegrador,
				sEmail = @sEmail,
				sNombre = @sNombre,
				sPaterno = @sPaterno,
				sMaterno = @sMaterno,
				nSolicitante = @nSolicitante,
				sActividadEconomica = @sActividadEconomica,
				nIdSegmento = @nIdSegmento,
                nIdZonaHoraria = @nIdZonaHoraria
			WHERE
				nIdEmisor = @nIdEmisor;


			UPDATE cfg_cuenta_banco SET
				sCorreo = @sEmail,
				sBeneficiario = @sBeneficiario
			WHERE
				nNumCuenta = @nIdEmisor;

			SELECT nIdDireccion INTO @direccion FROM dat_emisor WHERE  nIdEmisor = @nIdEmisor;

			UPDATE dat_direccion SET
				nIdPais = @nIdPais
			WHERE nIdDireccion = @direccion;


			UPDATE cfg_emisor SET
				nVigencia = @nVigencia,
				dFechaRevision = @dFechaRevision,
				transaccionesEstimadas = @transaccionesEstimadas,
				dFecContrato = CkdFecContrato,
                bEntidadRegulada = @bEntidadRegulada,
                nFacturacionTercero= @nFacturacionTercero,
                bCancelaOperaciones = ck_bCancelaOperaciones ,
                bValidacionRegulada=chkValidacionRegulada
			WHERE
				nIdEmisor = @nIdEmisor;

			IF @nIdPais != 164 THEN
				UPDATE cfg_emisor_factura SET
					nDiasLiquidaFactura = 0
				WHERE nIdEmisor = @nIdEmisor
					AND nTipoFactura = 1
					AND nIdFacturaEmisor > 1;

				UPDATE cfg_emisor_factura SET
					nDiasLiquidaFactura = 0
				WHERE nIdEmisor = @nIdEmisor
					AND nTipoFactura = 2
					AND nIdFacturaEmisor > 1;

				UPDATE cfg_emisor_factura SET
					nDiasLiquidaFactura = 0
					WHERE nIdEmisor = @nIdEmisor
						AND nTipoFactura = 3
						AND nIdFacturaEmisor > 1;

				UPDATE cfg_emisor_factura SET
					nDiasLiquidaFactura = 0
					WHERE nIdEmisor = @nIdEmisor
						AND nTipoFactura = 6
						AND nIdFacturaEmisor > 1;
			END IF;

            SET @paso = 2;
		ELSE
			SET @msg = 'No se pudo actualizar los datos del emisor, contacte a soporte.';
        END IF;
    END IF;

    IF @paso = 2 THEN
		SET @code = 0;
		SET @msg = 'Cambios efectuados correctamente.';
        COMMIT;
	ELSE
		SET @code = 1;
        ROLLBACK;
    END IF;

    SELECT  @code as code, @msg as msg;

END ;;

