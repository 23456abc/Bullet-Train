import { Controller } from "stimulus"
import Sortable from "sortablejs"

export default class extends Controller{
    connect(){
        this.sortable=Sortable.create(this.element, {
            onEnd: this.end.blind(this)
        })
    }
    end(event){
        console.log(event)
    }
}
