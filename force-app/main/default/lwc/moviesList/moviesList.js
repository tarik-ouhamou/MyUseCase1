import { LightningElement, wire, api } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { MessageContext, publish } from 'lightning/messageService';
import VIEW_MOVIE_MESSAGE from '@salesforce/messageChannel/View_Details__c';
import searchMovies from '@salesforce/apex/MoviesController.searchMovies';

export default class MoviesList extends LightningElement {
    @api searchValue;
    selectedMovieId;
    movies;
    error;

    @wire(MessageContext)
    messageContext;

    movieRefresh;

    @wire(searchMovies, {searchTerm: '$searchValue' })
    moviesAdapter(resp) {
        this.movieRefresh = resp;
        const { data, error } = resp;
        if (data) {
            this.movies = data
        } else if (error) {
            this.error = error;
        }

        this.stopLoading();
    }

    stopLoading() {
        const stopLoadingEvent = new CustomEvent('stoploading');
        this.dispatchEvent(stopLoadingEvent);
    }

    selectedMovie(event) {
        this.selectedMovieId = event.detail;

        const payload = { Id : this.selectedMovieId };
        publish(this.messageContext, VIEW_MOVIE_MESSAGE, payload);
    }

    @api refresh() {
        refreshApex(this.movieRefresh);
    }
}