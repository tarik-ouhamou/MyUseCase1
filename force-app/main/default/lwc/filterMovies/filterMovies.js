import { LightningElement } from 'lwc';

export default class FilterMovies extends LightningElement {

    searchValue = '';

    searchHandler(event) {
        this.stopLoading();
        this.searchValue = event.target.value;
        this.debouncer();
    }

    debouncer() {
        window.clearTimeout(this.delayTimeout);
        
        this.delayTimeout = setTimeout(() => {
            this.startLoading();
            this.searchMovies();
        }, 300);
    }

    stopLoading() {
        const stopLoadingEvent = new CustomEvent('stoploading');
        this.dispatchEvent(stopLoadingEvent);
    }

    startLoading() {
        const startLoadingEvent = new CustomEvent('startloading');
        this.dispatchEvent(startLoadingEvent);
    }

    searchMovies() {
        const customEvent = new CustomEvent('search', {
            detail: this.searchValue
        });
        this.dispatchEvent(customEvent);
    }
}