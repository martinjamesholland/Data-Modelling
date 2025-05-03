import React from 'react';

function App() {
  return (
    <div className="container-fluid">
      <div className="row vh-100">
        {/* Sidebar */}
        <nav className="col-md-3 col-lg-2 d-md-block bg-light sidebar py-4">
          <div className="sidebar-sticky">
            <h5>Folders</h5>
            <ul className="nav flex-column">
              <li className="nav-item">conceptual/</li>
              <li className="nav-item">logical/enterprise/</li>
              <li className="nav-item">logical/application/</li>
              <li className="nav-item">business/</li>
              <li className="nav-item">physical/</li>
            </ul>
          </div>
        </nav>
        {/* Main Content */}
        <main className="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
          <h2>Data Model Browser</h2>
          <p>Select a folder to view its files and metadata.</p>
          {/* Placeholder for file list and details */}
        </main>
      </div>
    </div>
  );
}

export default App;
