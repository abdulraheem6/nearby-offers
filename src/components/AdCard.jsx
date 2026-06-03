import React, { useRef, useState, useEffect } from 'react';
import VideoCard from './VideoCard';
import ImageCard from './ImageCard';
import YouTubeCard from './YouTubeCard';
import './AdCard.css';

function AdCard({ ad }) {
  const [isVisible, setIsVisible] = useState(false);
  const cardRef = useRef(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach(entry => {
          setIsVisible(entry.isIntersecting);
        });
      },
      { threshold: 0.6 }
    );

    if (cardRef.current) {
      observer.observe(cardRef.current);
    }

    return () => {
      if (cardRef.current) {
        observer.unobserve(cardRef.current);
      }
    };
  }, []);

  const renderContent = () => {
    switch (ad.type) {
      case 'video':
        return <VideoCard ad={ad} isVisible={isVisible} />;
      case 'image':
        return <ImageCard ad={ad} />;
      case 'youtube':
        return <YouTubeCard ad={ad} isVisible={isVisible} />;
      default:
        return <VideoCard ad={ad} isVisible={isVisible} />;
    }
  };

  return (
    <div className="ad-card" ref={cardRef}>
      {renderContent()}
      <div className="ad-overlay">
        <div className="ad-info">
          <h3 className="ad-title">{ad.title}</h3>
          {ad.featured && <span className="featured-badge">Featured</span>}
          <a 
            href={`https://wa.me/?text=Check out this ad: ${ad.title}`}
            target="_blank"
            rel="noopener noreferrer"
            className="whatsapp-btn"
          >
            <svg className="whatsapp-icon" viewBox="0 0 24 24" fill="currentColor">
              <path d="M12.04 2c-5.46 0-9.91 4.45-9.91 9.91 0 1.75.46 3.45 1.32 4.95L2.05 22l5.25-1.38c1.45.79 3.08 1.21 4.74 1.21 5.46 0 9.91-4.45 9.91-9.91 0-5.46-4.45-9.91-9.91-9.91zm0 18.23c-1.49 0-2.96-.4-4.23-1.16l-.3-.18-3.12.82.83-3.04-.2-.31c-.82-1.31-1.25-2.82-1.25-4.36 0-4.54 3.7-8.24 8.24-8.24 4.54 0 8.24 3.7 8.24 8.24 0 4.54-3.7 8.24-8.24 8.24zm4.52-6.17c-.25-.12-1.47-.72-1.7-.81-.23-.08-.4-.12-.57.12-.17.25-.66.81-.81.98-.15.17-.3.19-.55.06-.25-.12-1.06-.39-2.01-1.24-.74-.66-1.24-1.47-1.39-1.72-.15-.25-.02-.38.11-.51.11-.11.25-.29.38-.44.12-.15.16-.25.25-.42.09-.17.04-.31-.02-.43-.06-.12-.57-1.37-.78-1.88-.2-.49-.41-.42-.57-.43h-.48c-.17 0-.44.06-.66.31-.22.25-.85.83-.85 2.02 0 1.19.87 2.34.99 2.5.12.17 1.7 2.59 4.11 3.63.57.25 1.02.39 1.37.5.58.18 1.1.15 1.51.09.46-.06 1.47-.6 1.68-1.18.21-.58.21-1.07.15-1.18-.06-.11-.23-.18-.48-.3z"/>
            </svg>
            WhatsApp
          </a>
        </div>
      </div>
    </div>
  );
}

export default AdCard;
