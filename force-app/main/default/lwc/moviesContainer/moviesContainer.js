import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class MoviesContainer extends NavigationMixin(LightningElement) {

    searchValue = '';
    isOpen = false;

    searchHandler(event) {
        this.searchValue = event.detail;
    }

    openModal() {
        this.isOpen = true;
    }

    closeModal() {
        this.isOpen = false;
    }
}