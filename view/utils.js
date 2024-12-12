import { cargarDatosFloristerias } from './floristerias.js';
import { cargarDatosProductoras } from './productoras.js';
import { cargarDatosSubastas } from './subastas.js';
import { cargarDatosFacturas } from './facturas.js';

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
window.toggleSidebar = toggleSidebar;
