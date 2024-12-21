

// Datos de prueba para subastas
const subastasPrueba = [
    {
        id: '1',
        nombre: 'Subasta Primaveral',
        fecha: '2023-05-15',
        hora: '10:00',
        lugar: 'Centro de Convenciones Flora',
        estado: 'Próxima'
    },
    {
        id: '2',
        nombre: 'Subasta de Verano',
        fecha: '2023-07-20',
        hora: '14:00',
        lugar: 'Jardín Botánico Central',
        estado: 'Abierta para inscripciones'
    },
    {
        id: '3',
        nombre: 'Subasta de Otoño',
        fecha: '2023-09-10',
        hora: '11:00',
        lugar: 'Salón de Eventos Flor de Lis',
        estado: 'Finalizada'
    }
];

// Función para cargar datos de subastadores
function cargarDatosSubastadores() {
    const contenedor = document.querySelector('#subastadores .cards-container .cards');
    if (!contenedor) {
        console.error('Contenedor de cards no encontrado para subastadores');
        return;
    }
    contenedor.innerHTML = '';

    // Asumimos que los datos de subastadores están en window.data.subastadores
    const subastadores = window.data.subastadores;

    subastadores.forEach(subastador => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
            <h3>${subastador.nombre}</h3>
            <p>${subastador.ciudad || ''}</p>
        `;
        card.addEventListener('click', () => mostrarDetallesSubastador(subastador));
        contenedor.appendChild(card);
    });
}

// Función para mostrar detalles de un subastador
function mostrarDetallesSubastador(subastador) {
    cambiarSeccion('detalles');
    const titulo = document.getElementById('vista-titulo');
    const info = document.getElementById('detalles-info');
    const volverBtn = document.getElementById('volver-btn');

    titulo.textContent = subastador.nombre;
    volverBtn.style.display = 'block';
    volverBtn.onclick = () => cambiarSeccion('subastadores');
    
    info.innerHTML = `
        <p>${subastador.ciudad || ''}</p>
        ${subastador.horario ? `<p>Horario: ${subastador.horario}</p>` : ''}
        ${subastador.metodo ? `<p>Método de subasta: ${subastador.metodo}</p>` : ''}
    `;

    // No mostramos catálogo de flores para subastadores
    document.querySelector('#catalogo-flores').style.display = 'none';
}


// Función para cargar datos de subastas
export function cargarDatosSubastas() {
    const contenedor = document.querySelector('#subastas .cards-container .cards');
    if (!contenedor) {
        console.error('Contenedor de cards no encontrado para subastas');
        return;
    }
    contenedor.innerHTML = '';

    subastasPrueba.forEach(subasta => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
            <h3>${subasta.nombre}</h3>
            <p>Fecha: ${subasta.fecha}</p>
            <p>Estado: ${subasta.estado}</p>
        `;
        card.addEventListener('click', () => mostrarDetallesSubasta(subasta));
        contenedor.appendChild(card);
    });
}

// Función para mostrar detalles de una subasta
function mostrarDetallesSubasta(subasta) {
    cambiarSeccion('detalles');
    const titulo = document.getElementById('vista-titulo');
    const info = document.getElementById('detalles-info');
    const volverBtn = document.getElementById('volver-btn');

    titulo.textContent = subasta.nombre;
    volverBtn.style.display = 'block';
    volverBtn.onclick = () => cambiarSeccion('subastas');
    
    info.innerHTML = `
        <p>Fecha: ${subasta.fecha}</p>
        <p>Hora: ${subasta.hora}</p>
        <p>Lugar: ${subasta.lugar}</p>
        <p>Estado: ${subasta.estado}</p>
    `;

    // No mostramos catálogo de flores para subastas
    document.querySelector('#catalogo-flores').style.display = 'none';
}

window.cargarDatosSubastas = cargarDatosSubastas;
window.mostrarDetallesSubasta = mostrarDetallesSubasta;
