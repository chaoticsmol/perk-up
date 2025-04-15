import React from 'react';
import { Outlet } from 'react-router-dom';

function MainLayout() {
  return (
    <div className="app-container">
      <header className="app-header">
        <h1>Perk Up!</h1>
      </header>
      <main className="app-main">
        <Outlet />
      </main>
      <footer className="app-footer">
        <p>&copy; {new Date().getFullYear()} Perk Up!</p>
      </footer>
    </div>
  );
}

export default MainLayout; 