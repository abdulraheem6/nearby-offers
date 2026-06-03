import React from 'react';
import './YouTubeCard.css';

function YouTubeCard({ ad, isVisible }) {
  return (
    <div className="youtube-container">
      {isVisible ? (
        <iframe
          src={`https://www.youtube.com/embed/${ad.youtubeId}?autoplay=1&mute=1&loop=1&playlist=${ad.youtubeId}&controls=0&modestbranding=1&rel=0`}
          title={ad.title}
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
          allowFullScreen
          className="youtube-iframe"
        />
      ) : (
        <div className="youtube-placeholder">
          <img 
            src={`https://img.youtube.com/vi/${ad.youtubeId}/maxresdefault.jpg`}
            alt={ad.title}
            className="youtube-thumb"
          />
        </div>
      )}
    </div>
  );
}

export default YouTubeCard;
