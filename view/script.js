// Datos de muestra
const data = {
    floristerias: [
        { id: 1, nombre: "Floristería Bella", ciudad: "Madrid", telefono: "123-456-789", email: "bella@flores.com", flores: ["Rosa", "Tulipán", "Girasol"] },
        { id: 2, nombre: "Jardín Encantado", ciudad: "Barcelona", telefono: "987-654-321", email: "jardin@flores.com", flores: ["Orquídea", "Lirio", "Margarita"] },
        { id: 3, nombre: "Flores del Valle", ciudad: "Valencia", telefono: "456-789-123", email: "valle@flores.com", flores: ["Clavel", "Dalia", "Azucena"] }
    ],
    productores: [
        { id: 1, nombre: "Invernaderos García", region: "Andalucía", capacidad: "5000 m²", certificaciones: "Ecológico", flores: ["Rosa", "Clavel", "Girasol"] },
        { id: 2, nombre: "Cultivos Flores", region: "Cataluña", capacidad: "3000 m²", certificaciones: "GlobalGAP", flores: ["Tulipán", "Lirio", "Orquídea"] },
        { id: 3, nombre: "Jardines del Norte", region: "Galicia", capacidad: "4000 m²", certificaciones: "Veriflora", flores: ["Camelia", "Hortensia", "Azalea"] }
    ],
    subastadores: [
        { id: 1, nombre: "Subastas Flor", ciudad: "Sevilla", horario: "Lunes a Viernes, 8:00 - 14:00", metodo: "Subasta Holandesa", flores: ["Rosa", "Clavel", "Girasol"] },
        { id: 2, nombre: "Mercado de Flores", ciudad: "Barcelona", horario: "Martes y Jueves, 6:00 - 12:00", metodo: "Subasta Inglesa", flores: ["Orquídea", "Lirio", "Tulipán"] },
        { id: 3, nombre: "Floralia Subastas", ciudad: "Madrid", horario: "Lunes, Miércoles y Viernes, 7:00 - 13:00", metodo: "Mixta", flores: ["Gerbera", "Crisantemo", "Lilium"] }
    ],
    facturas: [
        { id: 1, cliente: "Floristería Bella", fecha: "2023-05-15", total: 500 },
        { id: 2, cliente: "Jardín Encantado", fecha: "2023-05-16", total: 750 },
        { id: 3, cliente: "Flores del Valle", fecha: "2023-05-17", total: 600 }
    ],
    flores: {
        "Rosa": { nombre: "Rosa", color: "Rojo", precio: 5, temporada: "Todo el año" },
        "Tulipán": { nombre: "Tulipán", color: "Varios", precio: 3, temporada: "Primavera" },
        "Girasol": { nombre: "Girasol", color: "Amarillo", precio: 4, temporada: "Verano" },
        "Orquídea": { nombre: "Orquídea", color: "Varios", precio: 10, temporada: "Todo el año" },
        "Lirio": { nombre: "Lirio", color: "Blanco", precio: 6, temporada: "Primavera-Verano" },
        "Margarita": { nombre: "Margarita", color: "Blanco y Amarillo", precio: 2, temporada: "Primavera-Verano" },
        "Clavel": { nombre: "Clavel", color: "Varios", precio: 3, temporada: "Todo el año" },
        "Dalia": { nombre: "Dalia", color: "Varios", precio: 4, temporada: "Verano-Otoño" },
        "Azucena": { nombre: "Azucena", color: "Blanco", precio: 5, temporada: "Verano" },
        "Camelia": { nombre: "Camelia", color: "Rojo, Blanco o Rosa", precio: 7, temporada: "Invierno-Primavera" },
        "Hortensia": { nombre: "Hortensia", color: "Azul o Rosa", precio: 8, temporada: "Primavera-Verano" },
        "Azalea": { nombre: "Azalea", color: "Rosa o Blanco", precio: 6, temporada: "Primavera" },
        "Gerbera": { nombre: "Gerbera", color: "Varios", precio: 3, temporada: "Primavera-Verano" },
        "Crisantemo": { nombre: "Crisantemo", color: "Varios", precio: 4, temporada: "Otoño" },
        "Lilium": { nombre: "Lilium", color: "Varios", precio: 7, temporada: "Verano" }
    }
};

// Función para cambiar entre secciones
function cambiarSeccion(seccion) {
    document.querySelectorAll('section').forEach(s => s.classList.remove('active'));
    document.getElementById(seccion).classList.add('active');
    const tituloVista = document.getElementById('vista-titulo');
    const volverBtn = document.getElementById('volver-btn');
    
    if (seccion === 'detalles') {
        volverBtn.style.display = 'block';
    } else {
        tituloVista.textContent = document.querySelector(`[data-section="${seccion}"]`).textContent.trim();
        volverBtn.style.display = 'none';
        cargarDatos(seccion);
    }

    // Actualizar el enlace activo en el sidebar
    document.querySelectorAll('.sidebar a').forEach(a => a.classList.remove('active'));
    const activeLink = document.querySelector(`.sidebar a[data-section="${seccion}"]`);
    if (activeLink) {
        activeLink.classList.add('active');
    }
}

// Función para cargar datos en las tarjetas
function cargarDatos(seccion) {
    const contenedor = document.querySelector(`#${seccion} .cards-container .cards`);
    contenedor.innerHTML = '';

    if (seccion === 'main') return; // El panel principal ya tiene contenido estático

    data[seccion].forEach(item => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
            <h3>${item.nombre}</h3>
            <p>${item.ciudad || item.region || item.fecha}</p>
            ${item.flores ? `<p>Flores: ${item.flores.length}</p>` : ''}
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

    titulo.textContent = item.nombre;
    volverBtn.style.display = 'block';
    volverBtn.onclick = () => cambiarSeccion(seccion);
    
    info.innerHTML = `
        <p>${item.ciudad || item.region}</p>
        ${item.telefono ? `<p>Teléfono: ${item.telefono}</p>` : ''}
        ${item.email ? `<p>Email: ${item.email}</p>` : ''}
        ${item.capacidad ? `<p>Capacidad: ${item.capacidad}</p>` : ''}
        ${item.certificaciones ? `<p>Certificaciones: ${item.certificaciones}</p>` : ''}
        ${item.horario ? `<p>Horario: ${item.horario}</p>` : ''}
        ${item.metodo ? `<p>Método de subasta: ${item.metodo}</p>` : ''}
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
    const detallesFlor = data.flores[flor];
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');
    modalBody.innerHTML = `
        <h2>${detallesFlor.nombre}</h2>
        <p>Proveedor: ${proveedor}</p>
        <p>Color: ${detallesFlor.color}</p>
        <p>Precio: €${detallesFlor.precio}</p>
        <p>Temporada: ${detallesFlor.temporada}</p>
    `;
    modal.style.display = 'block';
}

// Event listeners
document.querySelectorAll('.sidebar a').forEach(link => {
    link.addEventListener('click', (e) => {
        e.preventDefault();
        cambiarSeccion(e.target.getAttribute('data-section'));
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
document.getElementById('aplicarFiltro').addEventListener('click', () => {
    const clienteFilter = document.getElementById('clienteFilter').value.toLowerCase();
    const fechaFilter = document.getElementById('fechaFilter').value;

    const facturasFiltradas = data.facturas.filter(factura => 
        factura.cliente.toLowerCase().includes(clienteFilter) &&
        (!fechaFilter || factura.fecha === fechaFilter)
    );

    const contenedor = document.querySelector('#facturas .cards-container .cards');
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
});

// Función para toggle del sidebar en móviles
function toggleSidebar() {
    const sidebar = document.querySelector('.sidebar');
    sidebar.classList.toggle('active');
}

// Event listener para el botón de toggle del sidebar
document.getElementById('sidebar-toggle').addEventListener('click', toggleSidebar);

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

// Ajustar el sidebar al cambiar el tamaño de la ventana
window.addEventListener('resize', () => {
    const sidebar = document.querySelector('.sidebar');
    if (window.innerWidth > 768) {
        sidebar.classList.remove('active');
    }
});