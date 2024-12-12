

// Datos de prueba para facturas
const facturasPrueba = [
    {
        id: '12345',
        subasta: {
            nombre: 'Subasta Primaveral',
            id: '1',
            contacto: '123-456-7890'
        },
        floristeria: {
            nombre: 'Floristeria Ejemplo',
            id: '2',
            contacto: '098-765-4321',
            email: 'contacto@floristeria.com'
        },
        fecha: '2023-10-01',
        monto: '500.00',
        lotes: [
            {
                productor: 'Productor Ejemplo',
                vbn: 'VBN123',
                lote: 'Lote1',
                cantidad: 100,
                precio: '5.00'
            },
            {
                productor: 'Productor Ejemplo 2',
                vbn: 'VBN456',
                lote: 'Lote2',
                cantidad: 200,
                precio: '2.50'
            }
        ],
        envio: 'Sí'
    },
    // Puedes añadir más facturas de prueba aquí
];

// Función para cargar datos de facturas
export function cargarDatosFacturas() {
    const contenedor = document.querySelector('#facturas .cards-container .cards');
    if (!contenedor) {
        console.error('Contenedor de cards no encontrado para facturas');
        return;
    }
    contenedor.innerHTML = '';

    facturasPrueba.forEach(factura => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
            <h3>Factura #${factura.id}</h3>
            <p>Subasta: ${factura.subasta.nombre}</p>
            <p>Floristería: ${factura.floristeria.nombre}</p>
            <p>Fecha: ${factura.fecha}</p>
            <p>Monto: €${factura.monto}</p>
        `;
        card.addEventListener('click', () => mostrarDetallesFactura(factura));
        contenedor.appendChild(card);
    });
}

// Función para mostrar detalles de una factura
function mostrarDetallesFactura(factura) {
    cambiarSeccion('detalles-factura');
    document.getElementById('vista-titulo').textContent = `Factura #${factura.id}`;
    document.getElementById('volver-btn').style.display = 'block';
    document.getElementById('volver-btn').onclick = () => cambiarSeccion('facturas');

    document.getElementById('subastadora-nombre').textContent = `${factura.subasta.nombre} (#${factura.subasta.id})`;
    document.getElementById('subastadora-contacto').textContent = `Contacto: ${factura.subasta.contacto}`;
    document.getElementById('floristeria-nombre').textContent = `${factura.floristeria.nombre} (#${factura.floristeria.id})`;
    document.getElementById('floristeria-contacto').textContent = `Contacto: ${factura.floristeria.contacto}`;
    document.getElementById('floristeria-email').textContent = `Email: ${factura.floristeria.email}`;
    document.getElementById('factura-numero').textContent = `Número: ${factura.id}`;
    document.getElementById('factura-fecha').textContent = `Fecha: ${factura.fecha}`;
    document.getElementById('factura-envio').textContent = `Envío: ${factura.envio}`;
    document.getElementById('factura-monto-total').textContent = `Monto Total: €${factura.monto}`;

    const lotesTableBody = document.getElementById('factura-lotes').querySelector('tbody');
    lotesTableBody.innerHTML = '';
    factura.lotes.forEach(lote => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td><a href="#" onclick="mostrarModal('Información del productor: ${lote.productor}')">${lote.productor}</a></td>
            <td><a href="#" onclick="mostrarModal('Información del VBN: ${lote.vbn}')">${lote.vbn}</a></td>
            <td><a href="#" onclick="mostrarModal('Información del lote: ${lote.lote}')">${lote.lote}</a></td>
            <td>${lote.cantidad}</td>
            <td>€${lote.precio}</td>
        `;
        lotesTableBody.appendChild(row);
    });
}

// Función para aplicar filtro a las facturas
function aplicarFiltroFacturas() {
    const clienteFilter = document.getElementById('clienteFilter').value.toLowerCase();
    const fechaFilter = document.getElementById('fechaFilter').value;

    const facturasFiltradas = facturasPrueba.filter(factura => 
        factura.floristeria.nombre.toLowerCase().includes(clienteFilter) &&
        (!fechaFilter || factura.fecha === fechaFilter)
    );

    const contenedor = document.querySelector('#facturas .cards-container .cards');
    if (contenedor) {
        contenedor.innerHTML = '';

        facturasFiltradas.forEach(factura => {
            const card = document.createElement('div');
            card.className = 'card';
            card.innerHTML = `
                <h3>Factura #${factura.id}</h3>
                <p>Subasta: ${factura.subasta.nombre}</p>
                <p>Floristería: ${factura.floristeria.nombre}</p>
                <p>Fecha: ${factura.fecha}</p>
                <p>Monto: €${factura.monto}</p>
            `;
            card.addEventListener('click', () => mostrarDetallesFactura(factura));
            contenedor.appendChild(card);
        });
    }
}

window.cargarDatosFacturas = cargarDatosFacturas;
window.mostrarDetallesFactura = mostrarDetallesFactura;
window.aplicarFiltroFacturas = aplicarFiltroFacturas;