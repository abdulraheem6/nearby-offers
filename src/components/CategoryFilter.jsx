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
