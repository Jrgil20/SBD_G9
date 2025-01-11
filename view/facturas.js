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
        console.log(facturas);

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
async function mostrarDetallesFactura(factura) {
    cambiarSeccion('detalles-factura');
    document.getElementById('vista-titulo').textContent = `Factura #${factura.numero_factura}`;
    document.getElementById('volver-btn').style.display = 'block';
    document.getElementById('volver-btn').onclick = () => cambiarSeccion('facturas');

    try {
        const response = await fetch(`/api/informacionFactura/${factura.numero_factura}`);
        if (!response.ok) {
            throw new Error(`Error fetching factura details: ${response.statusText}`);
        }
        const facturaInfo = await response.json();
        console.log(facturaInfo);

        const subastadoraTelefono = facturaInfo.telefonos.find(t => t.idproductora == null && t.idfloristeria == null);
        const floristeriaTelefono = facturaInfo.telefonos.find(t => t.idproductora == null && t.idsubastadora == null);

        const subastadoraTelefonoCompleto = subastadoraTelefono ? `+${subastadoraTelefono.codpais} ${subastadoraTelefono.codarea} ${subastadoraTelefono.numero}` : 'No disponible';
        const floristeriaTelefonoCompleto = floristeriaTelefono ? `+${floristeriaTelefono.codpais} ${floristeriaTelefono.codarea} ${floristeriaTelefono.numero}` : 'No disponible';

        document.getElementById('subastadora-nombre').textContent = `${facturaInfo.subastadora_info.nombresubastadora} [#${facturaInfo.id_afiliacion_subastadora}]`;
        document.getElementById('subastadora-contacto').textContent = `Telefono: ${subastadoraTelefonoCompleto}`;

        document.getElementById('factura-fecha').textContent = `${factura.fecha_emision_formateada}`;
        document.getElementById('factura-numero').textContent = `${factura.numero_factura}`;

        document.getElementById('floristeria-nombre').textContent = `${facturaInfo.floristeria_info.nombre} [#${facturaInfo.id_afiliacion_floristeria}]`;
        document.getElementById('floristeria-contacto').textContent = `Telefono: ${floristeriaTelefonoCompleto}`;
        document.getElementById('floristeria-email').textContent = `Email: ${facturaInfo.floristeria_info.email}`;

        const lotesTableBody = document.getElementById('factura-lotes').querySelector('tbody');
        lotesTableBody.innerHTML = '';
        facturaInfo.lotes.forEach(lote => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${lote.numlote}</td>
                <td>${lote.cantidad}</td>
                <td>€${lote.preciofinal}</td>
            `;
            lotesTableBody.appendChild(row);
        });

        //NECESITA ARREGLARSE
        
        document.getElementById('factura-envio').textContent = factura.numeroenvio ? 'Con envío' : 'Sin envío';
        //document.getElementById('factura-subtotal').textContent = `Subtotal: €${facturaInfo.subtotal}`;
        document.getElementById('factura-recargo-envio').textContent = factura.envio ? `Recargo de envío: €${factura.recargoEnvio}` : '';
        document.getElementById('factura-total').textContent = `Total: €${factura.montototal}`;

    } catch (err) {
        console.error('Error fetching factura details:', err);
    }
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