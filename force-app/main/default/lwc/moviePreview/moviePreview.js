import { LightningElement, wire } from 'lwc';
import { MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import VIEW_MOVIE_MESSAGE from '@salesforce/messageChannel/View_Details__c';
import NAME_FIELD from '@salesforce/schema/Movie__c.Name';
import CATEGORY_FIELD from '@salesforce/schema/Movie__c.Category__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Movie__c.Description__c';
import RELEASE_DATE_FIELD from '@salesforce/schema/Movie__c.Release_date__c';

import MOVIE_OBJECT from '@salesforce/schema/Movie__c'

const fields = [ NAME_FIELD, CATEGORY_FIELD, DESCRIPTION_FIELD, RELEASE_DATE_FIELD ];
export default class MoviePreview extends LightningElement {

    movieId;

    nameField = NAME_FIELD;
    categoryField = CATEGORY_FIELD;
    descriptionField = DESCRIPTION_FIELD;
    releaseDate = RELEASE_DATE_FIELD;

    objectApiName = MOVIE_OBJECT;

    @wire(getRecord, { recordId: '$movieId', fields})
    movie;

    @wire(MessageContext)
    messageContext;

    subscription = null;

    connectedCallback() {
        this.subscription = subscribe(this.messageContext, VIEW_MOVIE_MESSAGE, (message) => this.handleMessage(message));
    }

    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    handleMessage(message) {
        console.log("message id : " + message.Id);
        this.movieId = message.Id;
    }

    editSuccess() {
        const event = new ShowToastEvent({
            title: 'Edit With Success',
            message: 'You have edited youre record successfully',
            variant: 'Success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}