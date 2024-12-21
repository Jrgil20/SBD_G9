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
        subtotal: '450.00',
        recargoEnvio: '50.00',
        total: '500.00',
        lotes: [
            {
                id: '1',
                descripcion: 'Rosas Rojas',
                precioFinal: '250.00'
            },
            {
                id: '2',
                descripcion: 'Tulipanes Amarillos',
                precioFinal: '200.00'
            }
        ],
        envio: true
    },
    {
        id: '67890',
        subasta: {
            nombre: 'Subasta Otoñal',
            id: '2',
            contacto: '321-654-0987'
        },
        floristeria: {
            nombre: 'Floristeria Ejemplo 2',
            id: '3',
            contacto: '987-654-3210',
            email: 'contacto2@floristeria.com'
        },
        fecha: '2023-11-01',
        subtotal: '300.00',
        recargoEnvio: '0.00',
        total: '300.00',
        lotes: [
            {
                id: 'Lote3',
                descripcion: 'Lirios Blancos',
                precioFinal: '150.00'
            },
            {
                id: 'Lote4',
                descripcion: 'Orquídeas Rosas',
                precioFinal: '150.00'
            }
        ],
        envio: false
    }
    // Puedes añadir más facturas de prueba aquí
];

// Función para cargar datos de facturas
export async function cargarDatosFacturas() {
    const contenedor = document.querySelector('#facturas .cards-container .cards');
    if (!contenedor) {
        console.error('Contenedor de cards no encontrado para facturas');
        return;
    }
    contenedor.innerHTML = '';

    try {
        const response = await fetch('/api/facturas');
        if (!response.ok) {
            throw new Error(`Error fetching facturas: ${response.statusText}`);
        }
        const facturas = await response.json();

        facturas.forEach(factura => {
            const card = document.createElement('div');
            card.className = 'card';
            card.innerHTML = `
                <h3>Factura #${factura.numero_factura}</h3>
                <p>Subastadora: ${factura.nombresubastadora}</p>
                <p>Floristería: ${factura.nombre}</p>
                <p>Fecha: ${factura.fecha_emision_formateada}</p>
                <p>Monto: €${factura.montototal}</p>
            `;
            card.addEventListener('click', () => mostrarDetallesFactura(factura));
            contenedor.appendChild(card);
        });
    } catch (err) {
        console.error('Error fetching facturas:', err);
    }
}
// Función para mostrar detalles de una factura
function mostrarDetallesFactura(factura) {
    cambiarSeccion('detalles-factura');
    document.getElementById('vista-titulo').textContent = `Factura #${factura.id}`;
    document.getElementById('volver-btn').style.display = 'block';
    document.getElementById('volver-btn').onclick = () => cambiarSeccion('facturas');

    document.getElementById('subastadora-nombre').textContent = `${factura.subasta.nombre} [#${factura.subasta.id}]`;
    document.getElementById('subastadora-contacto').textContent = `Tel: ${factura.subasta.contacto}`;
    document.getElementById('factura-fecha').textContent = `${factura.fecha}`;
    document.getElementById('factura-numero').textContent = `${factura.id}`;

    document.getElementById('floristeria-nombre').textContent = `${factura.floristeria.nombre} [#${factura.floristeria.id}]`;
    document.getElementById('floristeria-contacto').textContent = `Tel: ${factura.floristeria.contacto}`;
    document.getElementById('floristeria-email').textContent = `Email: ${factura.floristeria.email}`;

    const lotesTableBody = document.getElementById('factura-lotes').querySelector('tbody');
    lotesTableBody.innerHTML = ''; // Limpiar contenido previo
    factura.lotes.forEach(lote => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td><a href="#" class="lote-link" data-lote-id="${lote.id}">${lote.id}</a></td>
            <td>${lote.descripcion}</td>
            <td>€${lote.precioFinal}</td>
        `;
        lotesTableBody.appendChild(row);
    });

    document.querySelectorAll('.lote-link').forEach(link => {
        link.addEventListener('click', (event) => {
            event.preventDefault();
            const loteId = event.target.getAttribute('data-lote-id');
            const lote = factura.lotes.find(l => l.id === loteId);
            mostrarModalLote(lote);
        });
    });

    document.getElementById('factura-envio').textContent = factura.envio ? 'Con envío' : 'Sin envío';
    document.getElementById('factura-subtotal').textContent = `Subtotal: €${factura.subtotal}`;
    document.getElementById('factura-recargo-envio').textContent = factura.envio ? `Recargo de envío: €${factura.recargoEnvio}` : '';
    document.getElementById('factura-total').textContent = `Total: €${factura.total}`;
}

// Función para aplicar filtro a las facturas
function aplicarFiltroFacturas() {
    const clienteFilter = document.getElementById('clienteFilter').value.toLowerCase();
    const fechaFilter = document.getElementById('fechaFilter').value;

    const facturasFiltradas = facturasPrueba.filter(factura => 
        factura.floristeria.nombre.toLowerCase().includes(clienteFilter) &&
        (!fechaFilter || factura.fecha === fechaFilter)
    );
}

window.cargarDatosFacturas = cargarDatosFacturas;
window.mostrarDetallesFactura = mostrarDetallesFactura;
window.aplicarFiltroFacturas = aplicarFiltroFacturas;