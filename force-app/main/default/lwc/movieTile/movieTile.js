import { LightningElement, api, wire } from 'lwc';
import { MessageContext, publish } from 'lightning/messageService';
import VIEW_MOVIE_MESSAGE from '@salesforce/messageChannel/View_Details__c';

export default class MovieTile extends LightningElement {
    @api movie;

    @wire(MessageContext)
    messageContext;

    previewMovie() {
        const payload = { Id : this.movie.Id };
        console.log("payload  : " + payload.Id);
        publish(this.messageContext, VIEW_MOVIE_MESSAGE, payload);
    }
}