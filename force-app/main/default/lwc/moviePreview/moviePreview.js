import { LightningElement, wire } from 'lwc';
import { MessageContext, subscribe, unsubscribe, publish } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, deleteRecord } from 'lightning/uiRecordApi';

import VIEW_MOVIE_MESSAGE from '@salesforce/messageChannel/View_Details__c';
import REFRESH_LIST from '@salesforce/messageChannel/Refresh_List__c';

import NAME_FIELD from '@salesforce/schema/Movie__c.Name';
import CATEGORY_FIELD from '@salesforce/schema/Movie__c.Category__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Movie__c.Description__c';
import RELEASE_DATE_FIELD from '@salesforce/schema/Movie__c.Release_date__c';
import MOVIE_OBJECT from '@salesforce/schema/Movie__c';

const fields = [ NAME_FIELD, CATEGORY_FIELD, DESCRIPTION_FIELD, RELEASE_DATE_FIELD ];

const EDIT_SUCCESS_TITLE = 'Record edited successfuly';
const EDIT_SUCCESS_MESSAGE = 'You have edited your record successfully';
const EDIT_SUCCESS_VARIANT = 'success';

const DELETE_SUCCESS_TITLE = 'Record deleted successfuly';
const DELETE_SUCCESS_MESSAGE = 'You have deleted your record successfully';
const DELETE_SUCCESS_VARIANT = 'success';

const DELETE_ERROR_TITLE = 'Record not deleted';
const DELETE_ERROR_MESSAGE = 'Error while deleting record';
const DELETE_ERROR_VARIANT = 'error';

export default class MoviePreview extends LightningElement {

    movieId;
    formFields = [ NAME_FIELD, CATEGORY_FIELD, DESCRIPTION_FIELD, RELEASE_DATE_FIELD ];
    nameField = NAME_FIELD;
    categoryField = CATEGORY_FIELD;
    descriptionField = DESCRIPTION_FIELD;
    releaseDate = RELEASE_DATE_FIELD;

    objectApiName = MOVIE_OBJECT;

    @wire(getRecord, { recordId: '$movieId', fields })
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
        this.movieId = message.Id;
    }

    successHandler() {
        this.showToastMessage(EDIT_SUCCESS_TITLE, EDIT_SUCCESS_MESSAGE, EDIT_SUCCESS_VARIANT);
    }

    deleteHandler() {
        deleteRecord(this.movieId).then(() => {
            publish(this.messageContext, REFRESH_LIST);
            this.showToastMessage(DELETE_SUCCESS_TITLE, DELETE_SUCCESS_MESSAGE, DELETE_SUCCESS_VARIANT);
            this.movieId = null;
            this.movie.data = null;
            this.movie.error = null;
        }).catch(err => {
            this.showToastMessage(DELETE_ERROR_TITLE, DELETE_ERROR_MESSAGE, DELETE_ERROR_VARIANT);
            console.log(err);
        })
    }

    showToastMessage(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });

        this.dispatchEvent(event);
    }
}