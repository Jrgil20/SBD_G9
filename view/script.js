// Datos de muestra
const data = {
    floristerias: [
        { id: 1, nombre: "Floristería Bella", email: "bella@flores.com", paginaWeb: "www.floristeriabella.com", pais: "España", flores: ["Rosa", "Tulipán"] },
        { id: 2, nombre: "Jardín Encantado", email: "jardin@flores.com", paginaWeb: "www.jardinencantado.com", pais: "España", flores: ["Girasol", "Tulipán"] },
        { id: 3, nombre: "Flores del Valle", email: "valle@flores.com", paginaWeb: "www.floresdelvalle.com", pais: "España", flores: ["Rosa", "Girasol"] }
    ],
    productores: [
        { id: 1, nombre: "Invernaderos García", paginaWeb: "www.invernaderosgarcia.com", pais: "España", flores: ["Rosa", "Girasol"] },
        { id: 2, nombre: "Cultivos Flores", paginaWeb: "www.cultivosflores.com", pais: "España", flores: ["Tulipán", "Girasol"] },
        { id: 3, nombre: "Jardines del Norte", paginaWeb: "www.jardinesdelnorte.com", pais: "España", flores: ["Rosa", "Tulipán"] }
    ],
    subastadores: [
        { id: 1, nombre: "Subastas Flor", pais: "España", flores: ["Rosa", "Tulipán"] },
        { id: 2, nombre: "Mercado de Flores", pais: "España", flores: ["Girasol", "Tulipán"] },
        { id: 3, nombre: "Floralia Subastas", pais: "España", flores: ["Rosa", "Girasol"] }
    ],
    flores: [
        { id: 1, nombreComun: "Rosa", descripcion: "Flor de color rojo", genero_especie: "Rosa spp.", etimologia: "Del latín rosa", colores: ["Rojo", "Blanco", "Amarillo"], temperatura: "18" },
        { id: 2, nombreComun: "Tulipán", descripcion: "Flor de varios colores", genero_especie: "Tulipa spp.", etimologia: "Del turco tülbend", colores: ["Rojo", "Amarillo", "Rosa"], temperatura: "15" },
        { id: 3, nombreComun: "Girasol", descripcion: "Flor de color amarillo", genero_especie: "Helianthus annuus", etimologia: "Del griego helios y anthos", colores: ["Amarillo"], temperatura: "20" },
        { id: 4, nombreComun: "Lirio", descripcion: "Flor de varios colores", genero_especie: "Lilium spp.", etimologia: "Del latín lilium", colores: ["Blanco", "Rosa", "Amarillo"], temperatura: "12" },
        { id: 5, nombreComun: "Orquídea", descripcion: "Flor exótica de varios colores", genero_especie: "Orchidaceae", etimologia: "Del griego orkhis", colores: ["Blanco", "Rosa", "Morado"], temperatura: "15" }
    ],
    facturas: [
        { id: 1, cliente: "Juan Pérez", fecha: "2023-01-15", total: 150.00 },
        { id: 2, cliente: "María López", fecha: "2023-02-20", total: 200.00 },
        { id: 3, cliente: "Carlos García", fecha: "2023-03-10", total: 250.00 }
    ]
};

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
    
    if (seccion === 'detalles') {
        if (volverBtn) volverBtn.style.display = 'block';
    } else {
        const enlaceSeccion = document.querySelector(`[data-section="${seccion}"]`);
        if (tituloVista && enlaceSeccion) {
            tituloVista.textContent = enlaceSeccion.textContent.trim();
        }
        if (volverBtn) volverBtn.style.display = 'none';
        if (seccion !== 'main') {
            cargarDatos(seccion);
        }
    }

    // Actualizar el enlace activo en el sidebar
    document.querySelectorAll('.sidebar a').forEach(a => a.classList.remove('active'));
    const activeLink = document.querySelector(`.sidebar a[data-section="${seccion}"]`);
    if (activeLink) {
        activeLink.classList.add('active');
    }

    // Ocultar o mostrar el panel principal
    const mainSection = document.getElementById('main');
    if (mainSection) {
        mainSection.style.display = seccion === 'main' ? 'block' : 'none';
    }
}

// Función para cargar datos en las tarjetas
function cargarDatos(seccion) {
    if (seccion === 'main') return;

    const contenedor = document.querySelector(`#${seccion} .cards-container .cards`);
    if (!contenedor) {
        console.error(`Contenedor de cards no encontrado para la sección: ${seccion}`);
        return;
    }
    contenedor.innerHTML = '';

    if (!data[seccion]) {
        console.error(`No se encontraron datos para la sección: ${seccion}`);
        return;
    }

    data[seccion].forEach(item => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
            <h3>${item.nombre || item.nombreComun || item.cliente}</h3>
            <p>${item.pais || item.fecha || item.descripcion || ''}</p>
            ${item.total ? `<p>Total: €${item.total}</p>` : ''}
        `;
        card.addEventListener('click', () => mostrarDetalles(seccion, item));
        contenedor.appendChild(card);
    });
}

// Función para mostrar detalles
function mostrarDetalles(seccion, item) {
    cambiarSeccion('detalles');
    const titulo = document.getElementById('vista-titulo');
    const info = document.getElementById('detalles-info');
    const catalogo = document.querySelector('#catalogo-flores .cards');
    const volverBtn = document.getElementById('volver-btn');

    titulo.textContent = item.nombre || item.nombreComun || item.cliente;
    volverBtn.style.display = 'block';
    volverBtn.onclick = () => cambiarSeccion(seccion);
    
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
            const card = document.createElement('div');
            card.className = 'card';
            card.innerHTML = `
                <img src="https://via.placeholder.com/150?text=${flor}" alt="${flor}">
                <h3>${flor}</h3>
            `;
            card.addEventListener('click', () => mostrarDetallesFlor(flor, item.nombre));
            catalogo.appendChild(card);
        });
    }
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

