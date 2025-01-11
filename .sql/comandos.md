# Lista de Comandos

## Comando 1
```sql
SELECT * FROM obtener_informacion_factura(1);
```
Descripción: Comando que ejecuta el programa almacenado para obtener información de la factura con ID 1.


-- Insertar más contratos de las mismas productoras y subastadoras en diferentes fechas
INSERT INTO CONTRATO (idSubastadora, idProductora, nContrato, fechaemision, porcentajeProduccion, tipoProductor, idrenovS, idrenovP, ren_nContrato, cancelado) VALUES
(1, 1, 1004, '2023-01-01', 0.60, 'Ca', 1, 1, 1001, NULL),
(2, 2, 1005, '2023-02-01', 0.25, 'Cb', 2, 2, 1002, NULL),
(3, 3, 1006, '2023-03-01', 0.15, 'Cc', 3, 3, 1003, NULL),
(1, 1, 1007, '2024-01-01', 0.60, 'Ca', 1, 1, 1004, NULL),
(2, 2, 1008, '2024-02-01', 0.25, 'Cb', 2, 2, 1005, NULL),
(3, 3, 1009, '2024-03-01', 0.15, 'Cc', 3, 3, 1006, NULL);
