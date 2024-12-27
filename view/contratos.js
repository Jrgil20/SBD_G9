export async function cargarDatosContratos() {
    // Obtener productoras desde la base de datos
    const response = await fetch('/api/productoras');
    const productoras = await response.json();
    
    console.log('Productoras fetched:', productoras); 

    // Llenar el select de Productoras
    const productoraSelect = document.getElementById('productoraSelect');
    productoras.forEach(prod => {
        const option = document.createElement('option');
        option.value = prod.productoraid; 
        option.textContent = prod.nombreproductora; 
        productoraSelect.appendChild(option);
    });
    
    // Event listener para cargar los contratos de la Productora seleccionada
    productoraSelect.addEventListener('change', mostrarContratosPorProductora);
}

async function mostrarContratosPorProductora() {
    const productoraSelect = document.getElementById('productoraSelect');
    const productoraId = productoraSelect.value;
    
    if (!productoraId) {
        console.error('No productoraId selected');
        return;
    }

    const response = await fetch(`/api/obtener-contratos-productora?productoraId=${productoraId}`);
    const data = await response.json();
    
    const tablaBody = document.getElementById('tablaContratos').querySelector('tbody');
    tablaBody.innerHTML = ''; // Limpiar el contenido anterior
    
    data.forEach(c => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${c.ncontrato}</td>
            <td>${c.idsubastadora}</td>
            <td>${new Date(c.fechaemision).toLocaleDateString()}</td>
            <td>${(c.porcentajeproduccion * 100).toFixed(2)}%</td>
            <td>${c.tipoproductor}</td>
            <td>${c.esactivo ? 'Activo' : 'Cancelado'}</td>
        `;
        tablaBody.appendChild(tr);
    });
}

// Exponer función para cargar Contratos al inicio
window.cargarDatosContratos = cargarDatosContratos;

document.addEventListener('DOMContentLoaded', () => {
    const modalAgregarContrato = document.getElementById('modalAgregarContrato');
    const modalRenovarContrato = document.getElementById('modalRenovarContrato');
    const modalRegistrarPago = document.getElementById('modalRegistrarPago');

    const btnAgregarContrato = document.getElementById('agregarContratoBtn');
    const btnRenovarContrato = document.getElementById('renovarContratoBtn');
    const btnRegistrarPago = document.getElementById('registrarPagoBtn');

    const closeButtons = document.querySelectorAll('.modal .close');

    btnAgregarContrato.addEventListener('click', () => {
        modalAgregarContrato.style.display = 'block';
    });

    btnRenovarContrato.addEventListener('click', () => {
        modalRenovarContrato.style.display = 'block';
    });

    btnRegistrarPago.addEventListener('click', () => {
        modalRegistrarPago.style.display = 'block';
    });

    closeButtons.forEach(button => {
        button.addEventListener('click', () => {
            button.closest('.modal').style.display = 'none';
        });
    });

    window.addEventListener('click', (event) => {
        if (event.target.classList.contains('modal')) {
            event.target.style.display = 'none';
        }
    });
});