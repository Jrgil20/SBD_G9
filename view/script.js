import { cambiarSeccion } from './utils.js';

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
        aplicarFiltroBtn.addEventListener('click', aplicarFiltroFacturas);
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

