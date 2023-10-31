import { Controller } from "@hotwired/stimulus"

export default class DismissableController extends Controller {
  close() {
    this.element.remove();
  }
}
