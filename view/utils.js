import { cargarDatosFloristerias } from './floristerias.js';
import { cargarDatosProductoras } from './productoras.js';
import { cargarDatosSubastas } from './subastas.js';
import { cargarDatosFacturas } from './facturas.js';
import { cargarDatosContratos } from './contratos.js';
import { cargarDatosSubastadoras } from './subastadoras.js';

// Función para cambiar entre secciones
export function cambiarSeccion(seccion) {
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
            cargarDatosFloristerias();
            break;
        case 'productores':
            tituloVista.textContent = 'Productores';
            cargarDatosProductoras();
            break;
        case 'subastas':
            tituloVista.textContent = 'Subastas';
            cargarDatosSubastas();
            break;
        case 'facturas':
            tituloVista.textContent = 'Facturas';
            cargarDatosFacturas();
            break;
        case 'contratos':
            tituloVista.textContent = 'Contratos';
            cargarDatosContratos();
            break;
        case 'subastadoras':
            tituloVista.textContent = 'Subastadoras';
            cargarDatosSubastadoras();
            break;        
        default:
            tituloVista.textContent = '';
    }
}

// Función para mostrar el modal
function mostrarModal(info) {
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');
    modalBody.innerHTML = info;
    modal.style.display = 'block';
}

// Función para mostrar el modal con la información del lote
function mostrarModalLote(lote) {
    const info = `
        <h2>Información del Lote</h2>
        <p><strong>ID:</strong> ${lote.id}</p>
        <p><strong>Descripción:</strong> ${lote.descripcion}</p>
        <p><strong>Precio Final:</strong> €${lote.precioFinal}</p>
    `;
    mostrarModal(info);
}

// Función para toggle del sidebar
function toggleSidebar() {
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.getElementById('overlay');
    if (sidebar && overlay) {
        sidebar.classList.toggle('active');
        overlay.classList.toggle('active');
        document.body.style.overflow = sidebar.classList.contains('active') ? 'hidden' : '';
    }
}
window.cambiarSeccion = cambiarSeccion;
window.mostrarModal = mostrarModal;
window.mostrarModalLote = mostrarModalLote;
window.toggleSidebar = toggleSidebar;
