// Datos de prueba
const facturaPrueba = {
    numeroFactura: '12345',
    subastadora: {
        nombre: 'Subastadora Ejemplo',
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
};

// Función para mostrar detalles de la factura
function mostrarDetallesFactura(factura) {
    cambiarSeccion('detalles-factura');
    document.getElementById('vista-titulo').textContent = `Factura #${factura.numeroFactura}`;
    document.getElementById('volver-btn').style.display = 'block';
    document.getElementById('volver-btn').onclick = () => cambiarSeccion('facturas');

    document.getElementById('subastadora-nombre').textContent = `${factura.subastadora.nombre} (#${factura.subastadora.id})`;
    document.getElementById('subastadora-contacto').textContent = `Contacto: ${factura.subastadora.contacto}`;
    document.getElementById('floristeria-nombre').textContent = `${factura.floristeria.nombre} (#${factura.floristeria.id})`;
    document.getElementById('floristeria-contacto').textContent = `Contacto: ${factura.floristeria.contacto}`;
    document.getElementById('floristeria-email').textContent = `Email: ${factura.floristeria.email}`;
    document.getElementById('factura-numero').textContent = `Número: ${factura.numeroFactura}`;
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

// Función para mostrar el modal con información de prueba
function mostrarModal(info) {
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');
    modalBody.innerHTML = info;
    modal.style.display = 'block';
}

// Función para cambiar entre secciones
function cambiarSeccion(seccion) {
    document.querySelectorAll('section').forEach(s => s.style.display = 'none');
    const seccionActiva = document.getElementById(seccion);
    if (seccionActiva) {
        seccionActiva.style.display = 'block';
    } else {
        console.error(`Sección no encontrada: ${seccion}`);
        return;
    }

    const tituloVista = document.getElementById('vista-titulo');
    const volverBtn = document.getElementById('volver-btn');
    
    if (seccion === 'detalles' || seccion === 'detalles-factura') {
        tituloVista.style.display = 'block';
        volverBtn.style.display = 'block';
    } else {
        tituloVista.style.display = 'block';
        volverBtn.style.display = 'none';
    }

    // Actualizar el título del menú
    switch (seccion) {
        case 'main':
            tituloVista.textContent = 'Panel Principal';
            break;
        case 'floristerias':
            tituloVista.textContent = 'Floristerías';
            break;
        case 'productores':
            tituloVista.textContent = 'Productores';
            cargarDatos('productores'); // Cargar datos de productores
            break;
        case 'subastadores':
            tituloVista.textContent = 'Subastadores';
            break;
        case 'facturas':
            tituloVista.textContent = 'Facturas';
            break;
        default:
            tituloVista.textContent = '';
    }
}

//Funcion que muestra los detalles de una productora
function mostrarDetalles(seccion, item) {
    cambiarSeccion('detalles');
    const titulo = document.getElementById('vista-titulo');
    const info = document.getElementById('detalles-info');
    const catalogo = document.querySelector('#catalogo-flores .cards');
    const volverBtn = document.getElementById('volver-btn');

    // Actualizar el encabezado con el nombre de la productora
    titulo.textContent = item.nombreproductora || item.nombre || item.nombreComun || item.cliente;
    volverBtn.style.display = 'block';
    volverBtn.onclick = () => cambiarSeccion(seccion);
    
    // Mostrar la información de la productora seleccionada
    info.innerHTML = `
        <p>${item.pais || item.fecha || item.descripcion || ''}</p>
        ${item.email ? `<p>Email: ${item.email}</p>` : ''}
        ${item.paginaWeb ? `<p>Página Web: <a href="http://${item.paginaWeb}" target="_blank">${item.paginaWeb}</a></p>` : ''}
        ${item.etimologia ? `<p>Etimología: ${item.etimologia}</p>` : ''}
        ${item.colores ? `<p>Colores: ${item.colores.join(', ')}</p>` : ''}
        ${item.temperatura ? `<p>Temperatura: ${item.temperatura}</p>` : ''}
    `;

    catalogo.innerHTML = '';
    if (item.flores) {
        item.flores.forEach(flor => {
            const florCard = document.createElement('div');
            florCard.className = 'card';
            florCard.innerHTML = `
                <h3>${flor.nombre}</h3>
                <p>${flor.descripcion}</p>
            `;
            catalogo.appendChild(florCard);
        });
    }
}

// Función para cargar datos en las tarjetas
async function cargarDatos(seccion) {
    if (seccion === 'main') return;

    const contenedor = document.querySelector(`#${seccion} .cards-container .cards`);
    if (!contenedor) {
        console.error(`Contenedor de cards no encontrado para la sección: ${seccion}`);
        return;
    }
    contenedor.innerHTML = '';

    let data;
    if (seccion === 'productores') {
        try {
            const response = await fetch('/api/productoras');
            data = await response.json();
        } catch (err) {
            console.error('Error fetching productoras:', err);
            return;
        }
    } else {
        data = window.data[seccion];
    }

    if (!data) {
        console.error(`No se encontraron datos para la sección: ${seccion}`);
        return;
    }

    data.forEach(item => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
            <h3>${item.nombreproductora || item.nombre || item.nombreComun || item.cliente}</h3>
            <p>${item.paginaWeb || item.pais || item.fecha || item.descripcion || ''}</p>
            ${item.total ? `<p>Total: €${item.total}</p>` : ''}
        `;
        card.addEventListener('click', () => {
            mostrarDetalles(seccion, item);
        });
        contenedor.appendChild(card);
    });
}


// Función para mostrar detalles de una flor
function mostrarDetallesFlor(flor, proveedor) {
    const detallesFlor = data.flores.find(f => f.nombreComun === flor);
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');
    modalBody.innerHTML = `
        <h2>${detallesFlor.nombreComun}</h2>
        <p>Proveedor: ${proveedor}</p>
        <p>Descripción: ${detallesFlor.descripcion}</p>
        <p>Género y Especie: ${detallesFlor.genero_especie}</p>
        <p>Etimología: ${detallesFlor.etimologia}</p>
        <p>Colores: ${detallesFlor.colores.join(', ')}</p>
        <p>Temperatura: ${detallesFlor.temperatura}</p>
    `;
    modal.style.display = 'block';
}

function toggleSidebar() {
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.getElementById('overlay');
    if (sidebar && overlay) {
        sidebar.classList.toggle('active');
        overlay.classList.toggle('active');
        document.body.style.overflow = sidebar.classList.contains('active') ? 'hidden' : '';
    }
}

// Event listeners
document.addEventListener('DOMContentLoaded', () => {
    // Event listeners para los enlaces del sidebar
    document.querySelectorAll('.sidebar a').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            cambiarSeccion(e.target.getAttribute('data-section'));
        });
    });

    // Event listeners para las tarjetas del panel principal
    document.querySelectorAll('.main-card').forEach(card => {
        card.addEventListener('click', (e) => {
            const seccion = e.currentTarget.getAttribute('data-section');
            cambiarSeccion(seccion);
        });
    });

    document.querySelector('.close').addEventListener('click', () => {
        document.getElementById('modal').style.display = 'none';
    });

    window.addEventListener('click', (e) => {
        if (e.target === document.getElementById('modal')) {
            document.getElementById('modal').style.display = 'none';
        }
    });

    // Filtro para facturas
    const aplicarFiltroBtn = document.getElementById('aplicarFiltro');
    if (aplicarFiltroBtn) {
        aplicarFiltroBtn.addEventListener('click', () => {
            const clienteFilter = document.getElementById('clienteFilter').value.toLowerCase();
            const fechaFilter = document.getElementById('fechaFilter').value;

            const facturasFiltradas = data.facturas.filter(factura => 
                factura.cliente.toLowerCase().includes(clienteFilter) &&
                (!fechaFilter || factura.fecha === fechaFilter)
            );

            const contenedor = document.querySelector('#facturas .cards-container .cards');
            if (contenedor) {
                contenedor.innerHTML = '';

                facturasFiltradas.forEach(factura => {
                    const card = document.createElement('div');
                    card.className = 'card';
                    card.innerHTML = `
                        <h3>${factura.cliente}</h3>
                        <p>Fecha: ${factura.fecha}</p>
                        <p>Total: €${factura.total}</p>
                    `;
                    contenedor.appendChild(card);
                });
            }
        });
    }

    // Event listener para el botón de toggle del sidebar
    const sidebarToggle = document.getElementById('sidebar-toggle');
    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', toggleSidebar);
    }

    // Event listener para el botón de cierre del sidebar
    const sidebarClose = document.getElementById('sidebar-close');
    if (sidebarClose) {
        sidebarClose.addEventListener('click', toggleSidebar);
    }

    // Event listener para cerrar el sidebar al hacer clic en el overlay
    const overlay = document.getElementById('overlay');
    if (overlay) {
        overlay.addEventListener('click', toggleSidebar);
    }

    // Event listener para cerrar el sidebar al hacer clic en un enlace (en móviles)
    document.querySelectorAll('.sidebar a').forEach(link => {
        link.addEventListener('click', () => {
            if (window.innerWidth <= 768) {
                toggleSidebar();
            }
        });
    });

    // Cargar el panel principal al inicio
    cambiarSeccion('main');
});

// Ajustar el sidebar al cambiar el tamaño de la ventana
window.addEventListener('resize', () => {
    const sidebar = document.querySelector('.sidebar');
    if (sidebar && window.innerWidth > 768) {
        sidebar.classList.remove('active');
    }
});

