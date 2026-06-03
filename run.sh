#!/bin/bash

# Create project directory structure
mkdir -p tiktok-ad-feed/src/components
mkdir -p tiktok-ad-feed/src/hooks
mkdir -p tiktok-ad-feed/public/images
mkdir -p tiktok-ad-feed/public/videos
mkdir -p tiktok-ad-feed/.github/workflows

cd tiktok-ad-feed

# Create package.json
cat > package.json << 'EOF'
{
  "name": "tiktok-ad-feed",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "deploy": "npm run build && gh-pages -d dist"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "embla-carousel-react": "^8.0.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@vitejs/plugin-react": "^4.0.0",
    "vite": "^5.0.0",
    "gh-pages": "^6.0.0"
  }
}
EOF

# Create vite.config.js
cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: '/tiktok-ad-feed/',
  server: {
    port: 3000
  }
})
EOF

# Create index.html
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />
    <meta name="theme-color" content="#000000" />
    <title>TikTok Ad Feed</title>
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOF

# Create main.jsx
cat > src/main.jsx << 'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
)
EOF

# Create index.css
cat > src/index.css << 'EOF'
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background: #000;
  overflow: hidden;
  height: 100vh;
}

#root {
  height: 100vh;
}
EOF

# Create App.jsx
cat > src/App.jsx << 'EOF'
import React, { useState, useEffect } from 'react';
import Feed from './components/Feed';
import CategoryFilter from './components/CategoryFilter';
import './App.css';

function App() {
  const [ads, setAds] = useState([]);
  const [filteredAds, setFilteredAds] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedCategory, setSelectedCategory] = useState('all');

  useEffect(() => {
    fetch('/ads.json')
      .then(res => res.json())
      .then(data => {
        setAds(data);
        setFilteredAds(data);
        setLoading(false);
      })
      .catch(err => {
        console.error('Failed to load ads:', err);
        setLoading(false);
      });
  }, []);

  useEffect(() => {
    if (selectedCategory === 'all') {
      setFilteredAds(ads);
    } else {
      setFilteredAds(ads.filter(ad => ad.category === selectedCategory));
    }
  }, [selectedCategory, ads]);

  if (loading) {
    return (
      <div className="loading">
        <div className="spinner"></div>
        <p>Loading ads...</p>
      </div>
    );
  }

  return (
    <div className="app">
      <CategoryFilter 
        selectedCategory={selectedCategory} 
        onCategoryChange={setSelectedCategory} 
      />
      <Feed ads={filteredAds} />
    </div>
  );
}

export default App;
EOF

# Create App.css
cat > src/App.css << 'EOF'
.app {
  position: relative;
  height: 100vh;
  background: #000;
}

.loading {
  height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  background: #000;
  color: white;
  gap: 16px;
}

.spinner {
  width: 48px;
  height: 48px;
  border: 4px solid rgba(255, 255, 255, 0.1);
  border-top-color: #fe2c55;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading p {
  font-size: 14px;
  color: #888;
}
EOF

# Create components/Feed.jsx
cat > src/components/Feed.jsx << 'EOF'
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
EOF

# Create components/Feed.css
cat > src/components/Feed.css << 'EOF'
.feed {
  height: 100vh;
  overflow-y: scroll;
  scroll-snap-type: y mandatory;
  scroll-behavior: smooth;
  -webkit-overflow-scrolling: touch;
}

.feed::-webkit-scrollbar {
  display: none;
}

.feed {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

.empty-feed {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  color: #888;
  font-size: 16px;
  background: #000;
}
EOF

# Create components/AdCard.jsx
cat > src/components/AdCard.jsx << 'EOF'
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
EOF

# Create components/AdCard.css
cat > src/components/AdCard.css << 'EOF'
.ad-card {
  height: 100vh;
  scroll-snap-align: start;
  position: relative;
  background: #000;
  overflow: hidden;
}

.ad-card > video,
.ad-card > img,
.ad-card > iframe {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.ad-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(to top, rgba(0,0,0,0.8) 0%, rgba(0,0,0,0) 100%);
  padding: 80px 20px 30px;
  pointer-events: none;
}

.ad-info {
  pointer-events: auto;
}

.ad-title {
  color: white;
  font-size: 24px;
  font-weight: 600;
  margin-bottom: 8px;
  text-shadow: 0 1px 2px rgba(0,0,0,0.3);
}

.featured-badge {
  display: inline-block;
  background: linear-gradient(135deg, #fe2c55, #ff6b8b);
  color: white;
  font-size: 12px;
  font-weight: 600;
  padding: 4px 10px;
  border-radius: 20px;
  margin-bottom: 12px;
}

.whatsapp-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: #25D366;
  color: white;
  text-decoration: none;
  padding: 10px 20px;
  border-radius: 30px;
  font-weight: 600;
  font-size: 14px;
  margin-top: 8px;
  transition: transform 0.2s, opacity 0.2s;
  border: none;
  cursor: pointer;
}

.whatsapp-btn:hover {
  transform: scale(1.02);
  opacity: 0.9;
}

.whatsapp-icon {
  width: 20px;
  height: 20px;
}
EOF

# Create components/VideoCard.jsx
cat > src/components/VideoCard.jsx << 'EOF'
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
EOF

# Create components/VideoCard.css
cat > src/components/VideoCard.css << 'EOF'
.video-card {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
EOF

# Create components/ImageCard.jsx
cat > src/components/ImageCard.jsx << 'EOF'
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
EOF

# Create components/ImageCard.css
cat > src/components/ImageCard.css << 'EOF'
.image-carousel {
  height: 100%;
  position: relative;
  overflow: hidden;
}

.embla-container {
  display: flex;
  height: 100%;
}

.embla-slide {
  flex: 0 0 100%;
  min-width: 0;
}

.image-card {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.carousel-dots {
  position: absolute;
  bottom: 100px;
  left: 0;
  right: 0;
  display: flex;
  justify-content: center;
  gap: 8px;
  pointer-events: auto;
}

.dot {
  width: 8px;
  height: 8px;
  border-radius: 4px;
  background: rgba(255,255,255,0.5);
  border: none;
  padding: 0;
  cursor: pointer;
  transition: all 0.2s;
}

.dot.active {
  width: 20px;
  background: white;
}
EOF

# Create components/YouTubeCard.jsx
cat > src/components/YouTubeCard.jsx << 'EOF'
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
EOF

# Create components/YouTubeCard.css
cat > src/components/YouTubeCard.css << 'EOF'
.youtube-container {
  width: 100%;
  height: 100%;
  background: #000;
}

.youtube-iframe {
  width: 100%;
  height: 100%;
  border: none;
}

.youtube-placeholder {
  width: 100%;
  height: 100%;
  background: #111;
}

.youtube-thumb {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
EOF

# Create components/CategoryFilter.jsx
cat > src/components/CategoryFilter.jsx << 'EOF'
import React from 'react';
import './CategoryFilter.css';

const categories = [
  { id: 'all', label: 'All', icon: '🔥' },
  { id: 'electronics', label: 'Electronics', icon: '📱' },
  { id: 'food', label: 'Food', icon: '🍔' },
  { id: 'home', label: 'Home', icon: '🏠' },
  { id: 'fashion', label: 'Fashion', icon: '👕' },
  { id: 'beauty', label: 'Beauty', icon: '💄' },
  { id: 'automotive', label: 'Auto', icon: '🚗' },
];

function CategoryFilter({ selectedCategory, onCategoryChange }) {
  return (
    <div className="category-filter">
      {categories.map(cat => (
        <button
          key={cat.id}
          className={`category-btn ${selectedCategory === cat.id ? 'active' : ''}`}
          onClick={() => onCategoryChange(cat.id)}
        >
          <span className="category-icon">{cat.icon}</span>
          <span className="category-label">{cat.label}</span>
        </button>
      ))}
    </div>
  );
}

export default CategoryFilter;
EOF

# Create components/CategoryFilter.css
cat > src/components/CategoryFilter.css << 'EOF'
.category-filter {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  display: flex;
  gap: 8px;
  padding: 12px 16px;
  background: rgba(0,0,0,0.6);
  backdrop-filter: blur(10px);
  overflow-x: auto;
  white-space: nowrap;
  -webkit-overflow-scrolling: touch;
}

.category-filter::-webkit-scrollbar {
  display: none;
}

.category-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  background: rgba(255,255,255,0.15);
  border: none;
  border-radius: 30px;
  color: white;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  flex-shrink: 0;
}

.category-btn.active {
  background: #fe2c55;
  color: white;
}

.category-icon {
  font-size: 16px;
}

.category-label {
  font-size: 14px;
}

@media (max-width: 480px) {
  .category-filter {
    padding: 10px 12px;
    gap: 6px;
  }
  
  .category-btn {
    padding: 6px 12px;
    font-size: 12px;
  }
  
  .category-label {
    font-size: 12px;
  }
}
EOF

# Create public/ads.json
cat > public/ads.json << 'EOF'
[
  {
    "id": 1,
    "title": "iPhone 15 Pro Max Sale",
    "type": "video",
    "video": "/videos/sample-video.mp4",
    "poster": "https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=500",
    "featured": true,
    "category": "electronics"
  },
  {
    "id": 2,
    "title": "Burger Feast - 50% OFF",
    "type": "image",
    "images": [
      "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800",
      "https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800",
      "https://images.unsplash.com/photo-1551782450-17144efb9c50?w=800"
    ],
    "featured": false,
    "category": "food"
  },
  {
    "id": 3,
    "title": "Modern Sofa Collection",
    "type": "image",
    "images": [
      "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800",
      "https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=800"
    ],
    "featured": true,
    "category": "home"
  },
  {
    "id": 4,
    "title": "Summer Fashion Lookbook",
    "type": "video",
    "video": "/videos/sample-video.mp4",
    "featured": false,
    "category": "fashion"
  },
  {
    "id": 5,
    "title": "Amazing Trailer",
    "type": "youtube",
    "youtubeId": "dQw4w9WgXcQ",
    "featured": false,
    "category": "electronics"
  },
  {
    "id": 6,
    "title": "Samsung Galaxy S24 Ultra",
    "type": "image",
    "images": [
      "https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=800"
    ],
    "featured": false,
    "category": "electronics"
  },
  {
    "id": 7,
    "title": "Pizza & Pasta Deal",
    "type": "image",
    "images": [
      "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800",
      "https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800"
    ],
    "featured": false,
    "category": "food"
  }
]
EOF

# Create sample video placeholder note
cat > public/videos/placeholder-note.txt << 'EOF'
Place your MP4 video files here.
For testing, you can download a sample video from:
https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4

Save it as sample-video.mp4 in this folder.
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
node_modules/
dist/
.DS_Store
*.log
.env
EOF

# Create GitHub Actions workflow
cat > .github/workflows/deploy.yml << 'EOF'
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build
        run: npm run build
      
      - name: Setup Pages
        uses: actions/configure-pages@v4
      
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: dist

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
EOF

