import { LightningElement, api } from 'lwc';
import NAME from '@salesforce/schema/Movie__c.Name';
import CATEGORY from '@salesforce/schema/Movie__c.Category__c';
import DESCRIPTION from '@salesforce/schema/Movie__c.Description__c';
import RELEASE_DATE from '@salesforce/schema/Movie__c.Release_date__c';

export default class NewMovieModal extends LightningElement {
    fields = [NAME, CATEGORY, DESCRIPTION, RELEASE_DATE];
    
    @api isOpen;

    closeModal() {
        const modalEvent = new CustomEvent('close');

        this.dispatchEvent(modalEvent);
    }
}