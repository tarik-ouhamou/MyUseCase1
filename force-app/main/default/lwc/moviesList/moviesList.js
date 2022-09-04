import { LightningElement, wire, api } from 'lwc';
import searchMovies from '@salesforce/apex/MoviesController.searchMovies';

export default class MoviesList extends LightningElement {
    @api searchValue = '';

    @wire(searchMovies, {searchTerm: '$searchValue' })
    movies;
}