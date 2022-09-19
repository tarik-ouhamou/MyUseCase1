import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { subscribe, MessageContext, unsubscribe } from 'lightning/messageService';
import REFRESH_LIST from '@salesforce/messageChannel/Refresh_List__c';

export default class MoviesContainer extends NavigationMixin(LightningElement) {

    searchValue = '';
    isOpen = false;
    isLoading = false;
    subscription = null;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscription = subscribe(this.messageContext, REFRESH_LIST, () => {
            this.refreshMoviesList();
        });
    }

    disconnectedCallback() {
        unsubscribe(this.subscription);
    }

    searchHandler(event) {
        this.searchValue = event.detail;
    }

    openModal() {
        this.isOpen = true;
    }

    closeModal() {
        this.isOpen = false;
        this.refreshMoviesList();
    }

    startLoading() {
        this.isLoading = true;
    }

    stopLoading() {
        this.isLoading = false;
    }

    refreshMoviesList() {
        this.template.querySelector('c-movies-list').refresh();
    }

    
}