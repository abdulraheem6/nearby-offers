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
