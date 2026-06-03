import React, { useRef, useEffect } from 'react';
import './VideoCard.css';

function VideoCard({ ad, isVisible }) {
  const videoRef = useRef(null);

  useEffect(() => {
    if (videoRef.current) {
      if (isVisible) {
        videoRef.current.play().catch(e => console.log('Autoplay prevented:', e));
      } else {
        videoRef.current.pause();
      }
    }
  }, [isVisible]);

  return (
    <video
      ref={videoRef}
      src={ad.video}
      poster={ad.poster}
      autoPlay
      muted
      loop
      playsInline
      controls={false}
      className="video-card"
    />
  );
}

export default VideoCard;
