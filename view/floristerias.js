// Función para cargar datos de floristerías
export async function cargarDatosFloristerias() {
    const contenedor = document.querySelector('#floristerias .cards-container .cards');
    if (!contenedor) {
        console.error('Contenedor de cards no encontrado para floristerías');
        return;
    }
    contenedor.innerHTML = '';

    try {
        const response = await fetch('/api/floristerias');
        if (!response.ok) {
            throw new Error(`Error fetching floristerias: ${response.statusText}`);
        }
        const data = await response.json();

        data.forEach(floristeria => {
            const card = document.createElement('div');
            card.className = 'card';
            card.innerHTML = `
                <h3>${floristeria.nombre}</h3>
                <p>${floristeria.email || ''}</p>
                <p>${floristeria.paginaweb || ''}</p>
                <p>País: ${floristeria.pais || 'Desconocido'}</p>
            `;
            card.addEventListener('click', () => mostrarDetallesFloristeria(floristeria));
            contenedor.appendChild(card);
        });

        // Generar opciones de países
        const filtroPaisSelect = document.getElementById('filtro-pais-floristerias');
        const paises = [...new Set(data.map(floristeria => floristeria.pais))];
        paises.forEach(pais => {
            const option = document.createElement('option');
            option.value = pais;
            option.textContent = pais;
            filtroPaisSelect.appendChild(option);
        });

        // Mostrar la fecha de hoy
        const fechaHoy = new Date().toLocaleDateString();
        document.getElementById('fecha-hoy-floristerias').textContent = `Fecha: ${fechaHoy}`;
    } catch (err) {
        console.error('Error fetching floristerias:', err);
    }
}

// Función para mostrar detalles de una floristería
function mostrarDetallesFloristeria(floristeria) {
    cambiarSeccion('detalles');
    const titulo = document.getElementById('vista-titulo');
    const info = document.getElementById('detalles-info');
    const catalogo = document.querySelector('#catalogo-flores');
    const volverBtn = document.getElementById('volver-btn');

    titulo.textContent = floristeria.nombre;
    volverBtn.style.display = 'block';
    volverBtn.onclick = () => cambiarSeccion('floristerias');
    
    info.innerHTML = `
        <p>${floristeria.email ? `Email: ${floristeria.email}` : ''}</p>
        ${floristeria.paginaweb ? `<p>Página Web: <a href="http://${floristeria.paginaweb}" target="_blank">${floristeria.paginaweb}</a></p>` : ''}
        <p>País: ${floristeria.pais || 'Desconocido'}</p>
    `;

    catalogo.innerHTML = '';

    // Filtros
    const filtrosContainer = document.createElement('div');
    filtrosContainer.className = 'filters';

    const filtroNombre = document.createElement('input');
    filtroNombre.type = 'text';
    filtroNombre.id = 'filtro-nombre-flores';
    filtroNombre.placeholder = 'Filtrar por nombre';
    filtrosContainer.appendChild(filtroNombre);

    const filtroFecha = document.createElement('input');
    filtroFecha.type = 'date';
    filtroFecha.id = 'filtro-fecha-flores';
    filtrosContainer.appendChild(filtroFecha);

    const filtroCalificacion = document.createElement('select');
    filtroCalificacion.id = 'filtro-calificacion-flores';
    filtroCalificacion.innerHTML = `
        <option value="">Todas las calificaciones</option>
        <option value="5">5 estrellas</option>
        <option value="4">4 estrellas</option>
        <option value="3">3 estrellas</option>
        <option value="2">2 estrellas</option>
        <option value="1">1 estrella</option>
    `;
    filtrosContainer.appendChild(filtroCalificacion);

    const botonAplicarFiltro = document.createElement('button');
    botonAplicarFiltro.id = 'aplicar-filtro-flores';
    botonAplicarFiltro.textContent = 'Aplicar Filtro';
    botonAplicarFiltro.addEventListener('click', () => filtrarFlores(floristeria.flores));
    filtrosContainer.appendChild(botonAplicarFiltro);

    catalogo.appendChild(filtrosContainer);

    // Datos de prueba para las flores
    const flores = [
        { nombre: 'Gerbera Roja', vbn: '12345', imagen: 'gerbera_roja.jpg', calificacion: 4.5 },
        { nombre: 'Gerbera Amarilla', vbn: '12346', imagen: 'gerbera_amarilla.jpg', calificacion: 4.0 },
        { nombre: 'Rosa Roja', vbn: '12347', imagen: 'rosa_roja.jpg', calificacion: 5.0 },
        { nombre: 'Rosa Blanca', vbn: '12348', imagen: 'rosa_blanca.jpg', calificacion: 3.5 },
        { nombre: 'Tulipán Rojo', vbn: '12349', imagen: 'tulipan_rojo.jpg', calificacion: 4.8 },
        { nombre: 'Tulipán Amarillo', vbn: '12350', imagen: 'tulipan_amarillo.jpg', calificacion: 4.2 }
    ];

    // Ordenar flores por calificación
    flores.sort((a, b) => b.calificacion - a.calificacion);

    // Crear contenedor deslizable verticalmente
    const catalogoFloresContainer = document.createElement('div');
    catalogoFloresContainer.className = 'catalogo-flores-container';

    // Mostrar flores
    flores.forEach(flor => {
        const florCard = document.createElement('div');
        florCard.className = 'card flor-card';
        florCard.innerHTML = `
            <img src="images/${flor.imagen}" alt="${flor.nombre}" onerror="this.onerror=null;this.src='images/default.jpg';">
            <div class="flor-info">
                <h3>${flor.nombre}</h3>
                <p>VBN: ${flor.vbn}</p>
                <p>Calificación: ${flor.calificacion}</p>
            </div>
        `;
        florCard.addEventListener('click', () => mostrarModalFlor(flor));
        catalogoFloresContainer.appendChild(florCard);
    });

    catalogo.appendChild(catalogoFloresContainer);

    // Crear botón flotante
    const botonFlotante = document.createElement('div');
    botonFlotante.className = 'boton-flotante';
    botonFlotante.innerHTML = `
        <img src="images/Florist-pana (2).png" alt="Florist">
    `;
    botonFlotante.addEventListener('click', () => mostrarModalPersonalizado(floristeria.nombre));
    document.body.appendChild(botonFlotante);
}

// Función para filtrar flores
function filtrarFlores(flores) {
    const filtroNombre = document.getElementById('filtro-nombre-flores').value.toLowerCase();
    const filtroFecha = document.getElementById('filtro-fecha-flores').value;
    const filtroCalificacion = document.getElementById('filtro-calificacion-flores').value;
    const catalogoFloresContainer = document.querySelector('.catalogo-flores-container');
    catalogoFloresContainer.innerHTML = '';

    const floresFiltradas = flores.filter(flor => {
        const cumpleNombre = flor.nombre.toLowerCase().includes(filtroNombre);
        const cumpleFecha = filtroFecha === '' || flor.fecha === filtroFecha;
        const cumpleCalificacion = filtroCalificacion === '' || flor.calificacion >= filtroCalificacion;
        return cumpleNombre && cumpleFecha && cumpleCalificacion;
    });

    floresFiltradas.forEach(flor => {
        const florCard = document.createElement('div');
        florCard.className = 'card flor-card';
        florCard.innerHTML = `
            <img src="images/${flor.imagen}" alt="${flor.nombre}" onerror="this.onerror=null;this.src='images/default.jpg';">
            <div class="flor-info">
                <h3>${flor.nombre}</h3>
                <p>VBN: ${flor.vbn}</p>
                <p>Calificación: ${flor.calificacion}</p>
            </div>
        `;
        florCard.addEventListener('click', () => mostrarModalFlor(flor));
        catalogoFloresContainer.appendChild(florCard);
    });
}

// Función para mostrar el modal con la información completa de la flor
function mostrarModalFlor(flor) {
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');
    modalBody.innerHTML = `
        <h2>${flor.nombre}</h2>
        <img src="images/${flor.imagen}" alt="${flor.nombre}" onerror="this.onerror=null;this.src='images/default.jpg';">
        <p>VBN: ${flor.vbn}</p>
        <p>Calificación: ${flor.calificacion}</p>
    `;
    modal.style.display = 'block';
}

// Función para mostrar el modal personalizado
function mostrarModalPersonalizado(nombreFloristeria) {
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');
    modalBody.innerHTML = `
        <h2>Recomendador</h2>
        <img src="images/Florist-pana (1).png" alt="Florist">
        <p>Hola, soy <strong>María</strong>, trabajo en <strong>${nombreFloristeria}</strong>, y estoy aquí para recomendarte mis flores para cualquier ocasión que necesites. Por favor, cuéntame cómo te sientes y para qué ocasión estás buscando regalar nuestras maravillosas flores?</p>
        <div>
            <label for="emocion">Emoción:</label>
            <select id="emocion">
                <option value="feliz">Feliz</option>
                <option value="triste">Triste</option>
                <option value="enamorado">Enamorado</option>
                <option value="agradecido">Agradecido</option>
            </select>
            <label for="ocasion">Ocasion:</label>
            <input type="text" id="ocasion" placeholder="Describe la ocasión">
        </div>
        <button id="recomendar-btn">Recomiéndame!</button>
    `;
    modal.style.display = 'block';

    document.getElementById('recomendar-btn').addEventListener('click', () => {
        const emocion = document.getElementById('emocion').value;
        const ocasion = document.getElementById('ocasion').value;
        filtrarFloresPorRecomendacion(emocion, ocasion);
    });
}

// Función para filtrar flores basado en la recomendación
function filtrarFloresPorRecomendacion(emocion, ocasion) {
    // Aquí puedes implementar la lógica para filtrar las flores basado en la emoción y la ocasión
    console.log(`Emoción: ${emocion}, Ocasion: ${ocasion}`);
    // Por ahora, solo cerramos el modal
    cerrarModal();
}

// Función para cerrar el modal
function cerrarModal() {
    const modal = document.getElementById('modal');
    modal.style.display = 'none';
}

window.cargarDatosFloristerias = cargarDatosFloristerias;
window.mostrarDetallesFloristeria = mostrarDetallesFloristeria;
window.mostrarModalFlor = mostrarModalFlor;
window.mostrarModalPersonalizado = mostrarModalPersonalizado;
window.cerrarModal = cerrarModal;

// Cargar datos iniciales
document.addEventListener('DOMContentLoaded', cargarDatosFloristerias);