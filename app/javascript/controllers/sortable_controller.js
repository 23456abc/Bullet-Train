// import { Controller } from "stimulus";

// export default class extends Controller {
//   debugger
//   static targets = ["sortable"];

//   connect() {
//     this.initializeSortable();
//   }

//   initializeSortable() {
//     this.sortable = new Sortable(this.sortableWrapperTarget, {
//       // Add options for Sortable.js here
//       onUpdate: this.handleSortUpdate.bind(this),
//     });
//   }

//   handleSortUpdate(event) {
//     const itemIds = Array.from(this.sortableWrapperTarget.children).map((item) => item.dataset.itemId);
//     this.saveSortOrder(itemIds);
//   }

//   async saveSortOrder(itemIds) {
//     const url = this.data.get("rreorder Path");
//     try {
//       await fetch(url, {
//         method: "POST",
//         headers: {
//           "Content-Type": "application/json",
//           "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").getAttribute("content"),
//         },
//         body: JSON.stringify({ item_ids: itemIds }),
//       });
//     } catch (error) {
//       console.error("Failed to save sort order:", error);
//     }
//   }
// }