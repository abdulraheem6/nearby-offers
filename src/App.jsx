// import React, { useState, useEffect } from 'react';
// import Feed from './components/Feed';
// import CategoryFilter from './components/CategoryFilter';
// import './App.css';

// function App() {
//   const [ads, setAds] = useState([]);
//   const [filteredAds, setFilteredAds] = useState([]);
//   const [loading, setLoading] = useState(true);
//   const [selectedCategory, setSelectedCategory] = useState('all');

//   useEffect(() => {
//     fetch('./ads.json')
//       .then(res => res.json())
//       .then(data => {
//         setAds(data);
//         setFilteredAds(data);
//         setLoading(false);
//       })
//       .catch(err => {
//         console.error('Failed to load ads:', err);
//         setLoading(false);
//       });
//   }, []);

//   useEffect(() => {
//     if (selectedCategory === 'all') {
//       setFilteredAds(ads);
//     } else {
//       setFilteredAds(ads.filter(ad => ad.category === selectedCategory));
//     }
//   }, [selectedCategory, ads]);

//   if (loading) {
//     return (
//       <div className="loading">
//         <div className="spinner"></div>
//         <p>Loading ads...</p>
//       </div>
//     );
//   }

//   return (
//     <div className="app">
//       <CategoryFilter 
//         selectedCategory={selectedCategory} 
//         onCategoryChange={setSelectedCategory} 
//       />
//       <Feed ads={filteredAds} />
//     </div>
//   );
// }

// export default App;


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
    // The correct path for GitHub Pages
    const adsUrl = '/nearby-offers/ads.json';
    
    console.log('Fetching ads from:', adsUrl);
    
    fetch(adsUrl)
      .then(res => {
        if (!res.ok) {
          throw new Error(`HTTP ${res.status}: ${res.statusText}`);
        }
        return res.json();
      })
      .then(data => {
        console.log('Ads loaded successfully:', data.length);
        setAds(data);
        setFilteredAds(data);
        setLoading(false);
      })
      .catch(err => {
        console.error('Failed to load ads:', err);
        // Show error on screen for debugging
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

  if (ads.length === 0) {
    return (
      <div className="loading">
        <p>No ads found. Check console for errors.</p>
        <button onClick={() => window.location.reload()} style={{marginTop: 20, padding: '10px 20px'}}>
          Retry
        </button>
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