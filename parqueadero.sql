-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-03-2025 a las 22:04:01
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `parqueadero`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerarFacturaSimple` (IN `p_id_registro` INT)   BEGIN
    INSERT INTO Factura (id_registro, fecha, total)
    VALUES (p_id_registro, CURDATE(), (SELECT total_pagar FROM Registro WHERE id_registro = p_id_registro));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarIngresoSimple` (IN `p_id_vehiculo` INT)   BEGIN
    INSERT INTO Registro (id_vehiculo, hora_ingreso) VALUES (p_id_vehiculo, NOW());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SalidaVehiculoSimple` (IN `p_id_registro` INT, IN `p_tarifa` DECIMAL(10,2))   BEGIN
    UPDATE Registro
    SET hora_egreso = NOW(),
        total_pagar = TIMESTAMPDIFF(HOUR, hora_ingreso, NOW()) * p_tarifa
    WHERE id_registro = p_id_registro;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

CREATE TABLE `factura` (
  `id_factura` int(11) NOT NULL,
  `id_registro` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL,
  `impuesto` decimal(10,2) DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `factura`
--

INSERT INTO `factura` (`id_factura`, `id_registro`, `fecha`, `subtotal`, `impuesto`, `total`) VALUES
(1, 1, '2025-03-19', 50.00, 9.50, 59.50);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `puesto`
--

CREATE TABLE `puesto` (
  `id_puesto` int(11) NOT NULL,
  `estado` enum('ocupado','libre') DEFAULT 'libre',
  `id_registro` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `puesto`
--

INSERT INTO `puesto` (`id_puesto`, `estado`, `id_registro`) VALUES
(1, 'ocupado', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registro`
--

CREATE TABLE `registro` (
  `id_registro` int(11) NOT NULL,
  `id_vehiculo` int(11) DEFAULT NULL,
  `hora_ingreso` datetime DEFAULT NULL,
  `hora_egreso` datetime DEFAULT NULL,
  `total_pagar` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `registro`
--

INSERT INTO `registro` (`id_registro`, `id_vehiculo`, `hora_ingreso`, `hora_egreso`, `total_pagar`) VALUES
(1, 1, '2025-03-19 15:46:20', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `serviciolavado`
--

CREATE TABLE `serviciolavado` (
  `id_servicio` int(11) NOT NULL,
  `tipo_lavado` varchar(50) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `id_registro` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `serviciolavado`
--

INSERT INTO `serviciolavado` (`id_servicio`, `tipo_lavado`, `precio`, `id_registro`) VALUES
(1, 'Lavado Completo', 50.00, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `nombre`, `apellido`, `telefono`, `correo`) VALUES
(1, 'Carlos', 'Pérez', '1234567890', 'carlos.perez@email.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vehiculo`
--

CREATE TABLE `vehiculo` (
  `id_vehiculo` int(11) NOT NULL,
  `placa` varchar(20) DEFAULT NULL,
  `marca` varchar(50) DEFAULT NULL,
  `modelo` varchar(50) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `vehiculo`
--

INSERT INTO `vehiculo` (`id_vehiculo`, `placa`, `marca`, `modelo`, `color`, `id_usuario`) VALUES
(1, 'ABC123', 'Toyota', 'Corolla', 'Rojo', 1);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_facturacion`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_facturacion` (
`id_factura` int(11)
,`fecha` date
,`total` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_puestos_ocupados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_puestos_ocupados` (
`id_puesto` int(11)
,`estado` enum('ocupado','libre')
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_vehiculos_con_duenos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_vehiculos_con_duenos` (
`placa` varchar(20)
,`marca` varchar(50)
,`modelo` varchar(50)
,`nombre` varchar(50)
,`apellido` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_facturacion`
--
DROP TABLE IF EXISTS `vista_facturacion`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_facturacion`  AS SELECT `factura`.`id_factura` AS `id_factura`, `factura`.`fecha` AS `fecha`, `factura`.`total` AS `total` FROM `factura` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_puestos_ocupados`
--
DROP TABLE IF EXISTS `vista_puestos_ocupados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_puestos_ocupados`  AS SELECT `puesto`.`id_puesto` AS `id_puesto`, `puesto`.`estado` AS `estado` FROM `puesto` WHERE `puesto`.`estado` = 'ocupado' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_vehiculos_con_duenos`
--
DROP TABLE IF EXISTS `vista_vehiculos_con_duenos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_vehiculos_con_duenos`  AS SELECT `v`.`placa` AS `placa`, `v`.`marca` AS `marca`, `v`.`modelo` AS `modelo`, `u`.`nombre` AS `nombre`, `u`.`apellido` AS `apellido` FROM (`vehiculo` `v` join `usuario` `u` on(`v`.`id_usuario` = `u`.`id_usuario`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `factura`
--
ALTER TABLE `factura`
  ADD PRIMARY KEY (`id_factura`),
  ADD KEY `id_registro` (`id_registro`);

--
-- Indices de la tabla `puesto`
--
ALTER TABLE `puesto`
  ADD PRIMARY KEY (`id_puesto`),
  ADD KEY `id_registro` (`id_registro`);

--
-- Indices de la tabla `registro`
--
ALTER TABLE `registro`
  ADD PRIMARY KEY (`id_registro`),
  ADD KEY `id_vehiculo` (`id_vehiculo`);

--
-- Indices de la tabla `serviciolavado`
--
ALTER TABLE `serviciolavado`
  ADD PRIMARY KEY (`id_servicio`),
  ADD KEY `id_registro` (`id_registro`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`);

--
-- Indices de la tabla `vehiculo`
--
ALTER TABLE `vehiculo`
  ADD PRIMARY KEY (`id_vehiculo`),
  ADD UNIQUE KEY `placa` (`placa`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `factura`
--
ALTER TABLE `factura`
  MODIFY `id_factura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `puesto`
--
ALTER TABLE `puesto`
  MODIFY `id_puesto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `registro`
--
ALTER TABLE `registro`
  MODIFY `id_registro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `serviciolavado`
--
ALTER TABLE `serviciolavado`
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `vehiculo`
--
ALTER TABLE `vehiculo`
  MODIFY `id_vehiculo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `factura`
--
ALTER TABLE `factura`
  ADD CONSTRAINT `factura_ibfk_1` FOREIGN KEY (`id_registro`) REFERENCES `registro` (`id_registro`);

--
-- Filtros para la tabla `puesto`
--
ALTER TABLE `puesto`
  ADD CONSTRAINT `puesto_ibfk_1` FOREIGN KEY (`id_registro`) REFERENCES `registro` (`id_registro`);

--
-- Filtros para la tabla `registro`
--
ALTER TABLE `registro`
  ADD CONSTRAINT `registro_ibfk_1` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculo` (`id_vehiculo`);

--
-- Filtros para la tabla `serviciolavado`
--
ALTER TABLE `serviciolavado`
  ADD CONSTRAINT `serviciolavado_ibfk_1` FOREIGN KEY (`id_registro`) REFERENCES `registro` (`id_registro`);

--
-- Filtros para la tabla `vehiculo`
--
ALTER TABLE `vehiculo`
  ADD CONSTRAINT `vehiculo_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
