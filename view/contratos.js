export async function cargarDatosContratos() {
    // Datos de prueba de Productoras
    const productoras = [
        { id: 1, nombre: 'Productora A' },
        { id: 2, nombre: 'Productora B' }
    ];
    
    // Llenar el select de Productoras
    const productoraSelect = document.getElementById('productoraSelect');
    productoras.forEach(prod => {
        const option = document.createElement('option');
        option.value = prod.id;
        option.textContent = prod.nombre;
        productoraSelect.appendChild(option);
    });
    
    // Event listener para cargar los contratos de la Productora seleccionada
    productoraSelect.addEventListener('change', mostrarContratosPorProductora);
}

function mostrarContratosPorProductora() {
    const productoraId = document.getElementById('productoraSelect').value;
    const tablaBody = document.getElementById('tablaContratos').querySelector('tbody');
    tablaBody.innerHTML = '';

    // Datos de prueba de Contratos
    const contratos = [
        { numero: 1001, subastadora: 'Subastadora X', fecha: '2023-10-01', productoraId: '1' },
        { numero: 2001, subastadora: 'Subastadora Y', fecha: '2023-09-15', productoraId: '2' },
        { numero: 3001, subastadora: 'Subastadora Z', fecha: '2023-08-10', productoraId: '1' }
    ];

    // Filtrar solo los contratos de la productora seleccionada
    const filtrados = contratos.filter(c => c.productoraId === productoraId);
    
    filtrados.forEach(c => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${c.numero}</td>
            <td>${c.subastadora}</td>
            <td>${c.fecha}</td>
        `;
        tablaBody.appendChild(tr);
    });
}

// Exponer función para cargar Contratos al inicio
window.cargarDatosContratos = cargarDatosContratos;

