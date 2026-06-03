import React, { useState } from 'react';
import useEmblaCarousel from 'embla-carousel-react';
import './ImageCard.css';

function ImageCard({ ad }) {
  const [emblaRef] = useEmblaCarousel({ loop: true });
  const [selectedIndex, setSelectedIndex] = useState(0);

  const images = ad.images || (ad.image ? [ad.image] : []);

  if (!images.length) {
    return <img src="/placeholder.jpg" alt={ad.title} className="image-card" />;
  }

  return (
    <div className="image-carousel" ref={emblaRef}>
      <div className="embla-container">
        {images.map((img, idx) => (
          <div className="embla-slide" key={idx}>
            <img src={img} alt={`${ad.title} - ${idx + 1}`} className="image-card" />
          </div>
        ))}
      </div>
      {images.length > 1 && (
        <div className="carousel-dots">
          {images.map((_, idx) => (
            <button
              key={idx}
              className={`dot ${idx === selectedIndex ? 'active' : ''}`}
              onClick={() => setSelectedIndex(idx)}
            />
          ))}
        </div>
      )}
    </div>
  );
}

export default ImageCard;
