

// document.addEventListener('DOMContentLoaded', function () {
//     const table = document.querySelector('.table');
  
//     if (table) {
//       const tbody = table.querySelector('tbody');
  
//       new Sortable(tbody, {
//         handle: '.drag-handle',
//         animation: 150,
//         onEnd: function (event) {
//           const siteId = event.item.dataset.siteId;
//           const newPosition = Array.from(tbody.children).indexOf(event.item) + 1;
  
//           Rails.ajax({
//             type: 'POST',
//             url: '/sites/reorder',
//             data: `site_id=${siteId}&new_position=${newPosition}`,
//             success: function (data) {
//               console.log('Reordering successful');
//             },
//             error: function (data) {
//               console.error('Error reordering sites:', data);
//             },
//           });
//         },
//       });
//     }
//   });