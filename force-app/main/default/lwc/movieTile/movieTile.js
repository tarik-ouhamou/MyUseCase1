import { LightningElement, api } from 'lwc';

export default class MovieTile extends LightningElement {
    @api movie;
    @api selectedMovieId;

    get backgroundStyle() {
        return "background:url('https://static.vecteezy.com/system/resources/thumbnails/005/919/290/small/video-play-film-player-movie-solid-icon-illustration-logo-template-suitable-for-many-purposes-free-vector.jpg')"
    }

    get tileClass() {
        return this.selectedMovieId === this.movie.Id ? 'pointer selected' : 'pointer';
    }

    selectMovie() {
        const event = new CustomEvent('selected', {
            detail: this.movie.Id
        });
        this.dispatchEvent(event);
    }
}