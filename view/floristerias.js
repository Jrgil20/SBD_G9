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
            card.className = 'card floristeria-card';
            card.setAttribute('data-pais', floristeria.pais);
            card.setAttribute('data-nombre', floristeria.nombre || '');
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

// Inicializar filtros en el panel principal
const filtroPais = document.getElementById('filtro-pais-floristerias');
const filtroNombre = document.getElementById('filtro-nombre-floristerias');
const aplicarFiltroBtn = document.getElementById('aplicar-filtro-floristerias');

aplicarFiltroBtn.addEventListener('click', () => {
    const selectedPais = filtroPais.value.toLowerCase();
    const nombreInput = filtroNombre.value.toLowerCase();
    filtrarFloristerias(selectedPais, nombreInput);
});

function filtrarFloristerias(pais, nombre) {
    const cards = document.querySelectorAll('.floristeria-card');
    cards.forEach(card => {
        const cardPais = card.getAttribute('data-pais').toLowerCase();
        const cardNombre = card.getAttribute('data-nombre').toLowerCase();
        const matchesPais = pais === '' || cardPais.includes(pais);
        const matchesNombre = nombre === '' || cardNombre.includes(nombre);
        if (matchesPais && matchesNombre) {
            card.style.display = 'block';
        } else {
            card.style.display = 'none';
        }
    });
}

// Función para mostrar detalles de una floristería
export async function mostrarDetallesFloristeria(floristeria) {
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
        <option value="10">10 estrellas</option>
        <option value="9">9 estrellas</option>
        <option value="8">8 estrellas</option>
        <option value="7">7 estrellas</option>
        <option value="6">6 estrellas</option>
        <option value="5">5 estrellas</option>
        <option value="4">4 estrellas</option>
        <option value="3">3 estrellas</option>
        <option value="2">2 estrellas</option>
        <option value="1">1 estrella</option>
        <option value="0">0 estrellas</option>
    `;
    filtrosContainer.appendChild(filtroCalificacion);

    const botonAplicarFiltro = document.createElement('button');
    botonAplicarFiltro.id = 'aplicar-filtro-flores';
    botonAplicarFiltro.textContent = 'Aplicar Filtro';
    botonAplicarFiltro.addEventListener('click', () => filtrarFlores());
    filtrosContainer.appendChild(botonAplicarFiltro);

    const botonRecomendador = document.createElement('button');
    botonRecomendador.id = 'recomendador-btn';
    botonRecomendador.textContent = 'Recomendador';
    botonRecomendador.addEventListener('click', () => mostrarModalRecomendador(floristeria.nombre));
    filtrosContainer.appendChild(botonRecomendador);

    catalogo.appendChild(filtrosContainer);

    try {
        const response = await fetch(`/api/floresValoraciones/${floristeria.floristeriaid}`);
        if (!response.ok) {
            throw new Error(`Error fetching flores con valoraciones: ${response.statusText}`);
        }
        const flores = await response.json();

        // Ordenar flores por calificación
        flores.sort((a, b) => b.calificacion - a.calificacion);

        // Crear tabla para mostrar las flores
        const tablaFlores = document.createElement('table');
        tablaFlores.className = 'tabla-flores';
        tablaFlores.innerHTML = `
            <thead>
                <tr>
                    <th>Nombre</th>
                    <th>Calificación</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        `;

        const tbody = tablaFlores.querySelector('tbody');

        flores.forEach(flor => {
            const fila = document.createElement('tr');
            fila.innerHTML = `
                <td class="flor-nombre">${flor.nombrecomun}</td>
                <td class="flor-valoracion">${flor.valoracion_promedio !== null ? flor.valoracion_promedio : 'Sin calificación'}</td>
            `;
            fila.addEventListener('click', () => mostrarModalFlor(flor, floristeria.floristeriaid));
            tbody.appendChild(fila);
        });

        catalogo.appendChild(tablaFlores);
    } catch (err) {
        console.error('Error fetching flores con valoraciones:', err);
        catalogo.innerHTML = '<p>Error al cargar las flores con valoraciones.</p>';
    }
}

// Función para filtrar flores
function filtrarFlores() {
    const filtroNombre = document.getElementById('filtro-nombre-flores').value.toLowerCase();
    const filtroFecha = document.getElementById('filtro-fecha-flores').value;
    const filtroCalificacion = document.getElementById('filtro-calificacion-flores').value;
    const filas = document.querySelectorAll('.tabla-flores tbody tr');

    filas.forEach(fila => {
        const florNombre = fila.querySelector('.flor-nombre').textContent.toLowerCase();
        const florFecha = fila.querySelector('.flor-fecha') ? fila.querySelector('.flor-fecha').textContent : '';
        const florValoracion = parseFloat(fila.querySelector('.flor-valoracion').textContent);
        const matchesNombre = filtroNombre === '' || florNombre.includes(filtroNombre);
        const matchesFecha = filtroFecha === '' || florFecha === filtroFecha;
        const matchesCalificacion = filtroCalificacion === '' || florValoracion >= filtroCalificacion;
        if (matchesNombre && matchesFecha && matchesCalificacion) {
            fila.style.display = '';
        } else {
            fila.style.display = 'none';
        }
    });
}

// Función para mostrar el modal con la información completa de la flor
async function mostrarModalFlor(flor, floristeriaId) {
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');
    
    try {
        const response = await fetch(`/api/informacionFlor/${floristeriaId}/${flor.corteid}`);
        if (!response.ok) {
            throw new Error(`Error fetching información de la flor: ${response.statusText}`);
        }
        const informacionFlor = await response.json();
        const detalleFlor = informacionFlor[0]; // Asumiendo que solo hay un resultado
        console.log('Detalle de la flor:', detalleFlor);
        modalBody.innerHTML = `
            <h2>${detalleFlor.nombrepropio}</h2>
            <img src="images/${flor.imagen}" alt="${detalleFlor.nombrepropio}" onerror="this.onerror=null;this.src='images/default.jpg';">
            <p>Color: ${detalleFlor.nombre_color}</p>
            <p>Categoria: ${flor.nombrecomun}</p>
            <p>Longitud: ${detalleFlor.tallotamano} cm</p>
            <p>Tamaño del Bouquet: ${detalleFlor.cantidad}  piezas</p>
            <p>Precio: ${detalleFlor.precio} €</p>
        `;
        modal.style.display = 'block';
    } catch (err) {
        console.error('Error fetching información de la flor:', err);
        modalBody.innerHTML = '<p>Error al cargar la información de la flor.</p>';
        modal.style.display = 'block';
    }
}

// Función para mostrar el modal personalizado
function mostrarModalRecomendador(nombreFloristeria) {
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');
    modalBody.innerHTML = `
        <h2>Recomendador</h2>
        <img src="images/Florist-pana (1).png" alt="Florist">
        <p>Hola, soy <strong>María</strong>, trabajo en <strong>${nombreFloristeria}</strong>, y estoy aquí para recomendarte mis flores para cualquier ocasión que necesites. Por favor, cuéntame cómo te sientes y para qué ocasión estás buscando regalar nuestras maravillosas flores?</p>
        <div class="recomendador-form">
            <select id="emocion">
                <option value="feliz">Feliz</option>
                <option value="triste">Triste</option>
                <option value="enamorado">Enamorado</option>
                <option value="agradecido">Agradecido</option>
            </select>
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
window.mostrarModalPersonalizado = mostrarModalRecomendador;
window.cerrarModal = cerrarModal;

// Cargar datos iniciales
document.addEventListener('DOMContentLoaded', cargarDatosFloristerias);
