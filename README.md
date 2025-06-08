# SBD_G9
Sistemas de Base de datos, grupo 9 

## Changes in `commands.sql`

### Table Creation
- **PAIS**: Created with a sequence `pais_seq` and a check constraint on `continente`.
- **SUBASTADORA**: Created with a sequence `subastadora_seq` and a foreign key constraint on `idPais`.
- **PRODUCTORAS**: Created with a sequence `productoras_seq` and a foreign key constraint on `idPais`.
- **FLORISTERIAS**: Created with a sequence `floristerias_seq` and a foreign key constraint on `idPais`.
- **CLIENTE_NATURAL**: Created with a sequence `cliente_natural_seq`.
- **CLIENTE_JURIDICO**: Created with a sequence `cliente_juridico_seq` and a unique constraint on `RIF`.
- **FLOR_CORTES**: Created with a sequence `flor_cortes_seq`.
- **SIGNIFICADO**: Created with a sequence `significado_seq` and a check constraint on `Tipo`.
- **COLOR**: Created with a sequence `color_seq`.
- **ENLACES**: Created with a sequence `enlaces_seq` and foreign key constraints on `IdSignificado`, `idColor`, and `idCorte`.
- **CATALOGOPRODUCTOR**: Created with foreign key constraints on `idCorte` and `idProductora`, and a unique constraint on `vbn`.
- **CONTRATO**: Created with foreign key constraints on `idSubastadora`, `idProductora`, and `ren_nContrato`, and check constraints on `tipoProductor` and `porcentajeProduccion`.
- **CANTIDAD_OFRECIDA**: Created with foreign key constraints on `idContratoSubastadora`, `idContratoProductora`, `idNContrato`, `idCatalogoProductora`, `idCatalogoCorte`, and `idVnb`.
- **PAGOS**: Created with a sequence `pagos_seq` and foreign key constraints on `idContratoSubastadora`, `idContratoProductora`, and `idNContrato`.
- **CONTACTOS**: Created with a foreign key constraint on `idFloristeria`.
- **AFILIACION**: Created with foreign key constraints on `idFloristeria` and `idSubastadora`.
- **FACTURA**: Created with foreign key constraints on `idAfiliacionFloristeria` and `idAfiliacionSubastadora`.
- **LOTE**: Created with foreign key constraints on `idCantidadContratoSubastadora`, `idCantidadContratoProductora`, `idCantidad_NContrato`, `idCantidadCatalogoProductora`, `idCantidadCorte`, `idCantidadvnb`, and `idFactura`.
- **CATALOGO_FLORISTERIA**: Created with foreign key constraints on `idFloristeria`, `idCorteFlor`, and `idColor`.
- **HISTORICO_PRECIO_FLOR**: Created with foreign key constraints on `idCatalogoFloristeria` and `idCatalogocodigo`.
- **DETALLE_BOUQUET**: Created with foreign key constraints on `idCatalogoFloristeria` and `idCatalogocodigo`.
- **FACTURA_FINAL**: Created with foreign key constraints on `idFloristeria`, `idClienteNatural`, and `idClienteJuridico`.
- **DETALLE_FACTURA**: Created with foreign key constraints on `idFActuraFloristeria`, `idNumFactura`, `catalogoFloristeria`, `catalogoCodigo`, `bouquetFloristeria`, `bouquetcodigo`, and `bouquetId`.
- **TELEFONOS**: Created with foreign key constraints on `idSubastadora`, `idProductora`, and `idFloristeria`.

### Sequences
- Created sequences for various tables to auto-increment primary keys.

### Constraints
- Added check constraints to ensure data integrity.
- Added foreign key constraints to maintain relationships between tables.

### Triggers and Functions
- Created triggers and functions for various operations such as checking nationality of producers, verifying active contracts, calculating commissions, and more.

## Changes in `app.js`

### Routes and Functions
- **GET /api/productoras**: Fetches all productoras.
- **GET /api/catalogoProductor/:id**: Fetches catalogo for a specific productora.
- **GET /api/detalleFlores/:florId/:productorId**: Fetches details of specific flores.
- **GET /api/floristerias**: Fetches all floristerias.
- **GET /api/floresValoraciones/:idFloristeria**: Fetches flores with valoraciones for a specific floristeria.
- **GET /api/informacionFlor/:idFloristeria/:idFlor**: Fetches information of a specific flor.
- **GET /api/facturas**: Fetches all facturas.
- **GET /api/florCortes**: Fetches all flor cortes.
- **GET /api/coloresDeCorte/:corteId**: Fetches colores for a specific corte.
- **GET /api/coloresDeCortePorNombre/:nombre**: Fetches colores for a specific corte by name.
- **GET /api/obtener-contratos-productora**: Fetches contratos for a specific productora.
- **GET /api/informacionFactura/:facturaId**: Fetches information of a specific factura.

## Changes in `db.js`

### Database Connection
- Configured database connection using `pg` and environment variables.

### Query Functions
- **getProductoras**: Fetches all productoras.
- **getCatalogoProductoraById**: Fetches catalogo for a specific productora.
- **getDetalleFlores**: Fetches details of specific flores.
- **getFloristerias**: Fetches all floristerias.
- **getFloresValoraciones**: Fetches flores with valoraciones for a specific floristeria.
- **getInformacionFlor**: Fetches information of a specific flor.
- **getFacturas**: Fetches all facturas.
- **getInformacionFactura**: Fetches information of a specific factura.
- **getFlorCortes**: Fetches all flor cortes.
- **getContratosProductora**: Fetches contratos for a specific productora.

## Examples of API Endpoints Usage

### Fetching Productoras
```bash
curl -X GET http://localhost:3000/api/productoras
```

### Fetching Catalogo for a Specific Productora
```bash
curl -X GET http://localhost:3000/api/catalogoProductor/1
```

### Fetching Details of Specific Flores
```bash
curl -X GET http://localhost:3000/api/detalleFlores/1/1
```

### Fetching Floristerias
```bash
curl -X GET http://localhost:3000/api/floristerias
```

### Fetching Flores with Valoraciones for a Specific Floristeria
```bash
curl -X GET http://localhost:3000/api/floresValoraciones/1
```

### Fetching Information of a Specific Flor
```bash
curl -X GET http://localhost:3000/api/informacionFlor/1/1
```

### Fetching Facturas
```bash
curl -X GET http://localhost:3000/api/facturas
```

### Fetching Flor Cortes
```bash
curl -X GET http://localhost:3000/api/florCortes
```

### Fetching Colores for a Specific Corte
```bash
curl -X GET http://localhost:3000/api/coloresDeCorte/1
```

### Fetching Colores for a Specific Corte by Name
```bash
curl -X GET http://localhost:3000/api/coloresDeCortePorNombre/rosa
```

### Fetching Contratos for a Specific Productora
```bash
curl -X GET http://localhost:3000/api/obtener-contratos-productora?productoraId=1
```

### Fetching Information of a Specific Factura
```bash
curl -X GET http://localhost:3000/api/informacionFactura/1
```

## Setting Up the Database and Running the Project Locally

### Prerequisites
- Node.js
- PostgreSQL

### Environment Variables
Create a `.env` file in the root directory of the project and add the following environment variables:
```
DB_USER=your_database_user
DB_HOST=your_database_host
DB_DATABASE=your_database_name
DB_PASSWORD=your_database_password
DB_PORT=your_database_port
```

### Installing Dependencies
```bash
npm install
```

### Running the Project
```bash
npm start
```

### Setting Up the Database
1. Create a new PostgreSQL database.
2. Run the SQL scripts in the `.sql` directory to create tables, sequences, constraints, triggers, and functions.
3. Insert initial data into the tables using the provided SQL scripts.

## Additional Information

### Project Overview
This project is a database management system for a flower auction platform. It includes various SQL scripts for creating and managing tables, sequences, constraints, triggers, and functions. The project also includes an API built with Node.js and Express to interact with the database.

### API Documentation
The API provides endpoints for fetching data related to productoras, floristerias, flores, facturas, and more. Each endpoint is documented with examples of how to use them.

### Database Design
The database is designed to handle various entities such as countries, auction houses, producers, florists, customers, flowers, contracts, payments, and more. Each entity is represented by a table, and relationships between entities are maintained using foreign key constraints.

### SQL Scripts
The SQL scripts in the `.sql` directory include commands for creating tables, sequences, constraints, triggers, and functions. These scripts are organized into different files based on their functionality.

### Running the Project Locally
To run the project locally, follow the steps mentioned in the "Setting Up the Database and Running the Project Locally" section. Make sure to configure the environment variables and install the necessary dependencies.

### Contributing
If you would like to contribute to this project, please fork the repository and submit a pull request with your changes. Make sure to follow the coding standards and include appropriate documentation for your changes.

### License
This project is licensed under the MIT License. See the `LICENSE` file for more details.
