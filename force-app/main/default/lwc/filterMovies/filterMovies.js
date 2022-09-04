import { LightningElement } from 'lwc';

export default class FilterMovies extends LightningElement {

    searchValue = '';

    searchHandler(event) {
        this.searchValue = event.target.value;

        window.clearTimeout(this.delayTimeout);
        
        this.delayTimeout = setTimeout(() => {
            const customEvent = new CustomEvent('search', {
                detail: this.searchValue
            });
            
            this.dispatchEvent(customEvent);
        }, 300);

    }
}