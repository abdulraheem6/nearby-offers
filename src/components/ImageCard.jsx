// import React, { useState } from 'react';
// import useEmblaCarousel from 'embla-carousel-react';
// import './ImageCard.css';

// function ImageCard({ ad }) {
//   const [emblaRef] = useEmblaCarousel({ loop: true });
//   const [selectedIndex, setSelectedIndex] = useState(0);

//   const images = ad.images || (ad.image ? [ad.image] : []);

//   if (!images.length) {
//     return <img src="/placeholder.jpg" alt={ad.title} className="image-card" />;
//   }

//   return (
//     <div className="image-carousel" ref={emblaRef}>
//       <div className="embla-container">
//         {images.map((img, idx) => (
//           <div className="embla-slide" key={idx}>
//             <img src={img} alt={`${ad.title} - ${idx + 1}`} className="image-card" />
//           </div>
//         ))}
//       </div>
//       {images.length > 1 && (
//         <div className="carousel-dots">
//           {images.map((_, idx) => (
//             <button
//               key={idx}
//               className={`dot ${idx === selectedIndex ? 'active' : ''}`}
//               onClick={() => setSelectedIndex(idx)}
//             />
//           ))}
//         </div>
//       )}
//     </div>
//   );
// }

// export default ImageCard;


import React, { useState, useEffect } from 'react';
import useEmblaCarousel from 'embla-carousel-react';
import './ImageCard.css';

function ImageCard({ ad, isVisible }) {
  const [emblaRef, emblaApi] = useEmblaCarousel({ 
    loop: true,
    dragFree: false,  // Better for mobile swiping
    containScroll: 'trimSnaps'
  });
  const [selectedIndex, setSelectedIndex] = useState(0);

  const images = ad.images || (ad.image ? [ad.image] : [
    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&q=80',
    'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800&q=80'
  ]);

  useEffect(() => {
    if (emblaApi) {
      emblaApi.on('select', () => {
        setSelectedIndex(emblaApi.selectedScrollSnap());
      });
    }
  }, [emblaApi]);

  return (
    <div className="image-carousel" ref={emblaRef}>
      <div className="embla-container">
        {images.map((img, idx) => (
          <div className="embla-slide" key={idx}>
            <img 
              src={img} 
              alt={`${ad.title} - ${idx + 1}`} 
              className="image-card"
              loading={idx === 0 ? 'eager' : 'lazy'}  // Lazy load off-screen images
              draggable={false}  // Prevents drag interference on mobile
            />
          </div>
        ))}
      </div>
      {images.length > 1 && (
        <div className="carousel-dots">
          {images.map((_, idx) => (
            <button
              key={idx}
              className={`dot ${idx === selectedIndex ? 'active' : ''}`}
              onClick={() => emblaApi && emblaApi.scrollTo(idx)}
            />
          ))}
        </div>
      )}
    </div>
  );
}

export default ImageCard;