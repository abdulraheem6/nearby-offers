// import React, { useRef, useEffect } from 'react';
// import './VideoCard.css';

// function VideoCard({ ad, isVisible }) {
//   const videoRef = useRef(null);

//   useEffect(() => {
//     if (videoRef.current) {
//       if (isVisible) {
//         videoRef.current.play().catch(e => console.log('Autoplay prevented:', e));
//       } else {
//         videoRef.current.pause();
//       }
//     }
//   }, [isVisible]);

//   return (
//     <video
//       ref={videoRef}
//       src={ad.video}
//       poster={ad.poster}
//       autoPlay
//       muted
//       loop
//       playsInline
//       controls={false}
//       className="video-card"
//     />
//   );
// }

// export default VideoCard;

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

  const videoSrc = ad.video || 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4';

  return (
    <video
      ref={videoRef}
      src={videoSrc}
      poster={ad.poster}
      autoPlay
      muted
      loop
      playsInline  // Critical for mobile - prevents fullscreen
      webkit-playsinline="true"  // iOS Safari support
      controls={false}
      className="video-card"
    />
  );
}

export default VideoCard;