import React, { useRef, useEffect } from 'react';
import AdCard from './AdCard';
import './Feed.css';

function Feed({ ads }) {
  const feedRef = useRef(null);

  // Reset scroll position when ads change (category filter)
  useEffect(() => {
    if (feedRef.current) {
      feedRef.current.scrollTop = 0;
    }
  }, [ads]);

  if (ads.length === 0) {
    return (
      <div className="empty-feed">
        <p>No ads available in this category</p>
      </div>
    );
  }

  return (
    <div className="feed" ref={feedRef}>
      {ads.map((ad, index) => (
        <AdCard key={`${ad.id}-${index}`} ad={ad} />
      ))}
    </div>
  );
}

export default Feed;
