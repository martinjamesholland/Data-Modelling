import React, { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

const GITHUB_API_BASE = 'https://api.github.com/repos/martinjamesholland/Data-Modelling/contents/'
const FOLDERS = [
  'conceptual',
  'logical/enterprise',
  'logical/application',
  'business',
  'physical',
]

function App() {
  const [selectedFolder, setSelectedFolder] = useState(null)
  const [files, setFiles] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const handleFolderClick = async (folder) => {
    setSelectedFolder(folder)
    setLoading(true)
    setError(null)
    setFiles([])
    try {
      const res = await fetch(GITHUB_API_BASE + folder)
      if (!res.ok) throw new Error('Failed to fetch folder contents')
      const data = await res.json()
      setFiles(data)
    } catch (err) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="container-fluid">
      <div className="row vh-100">
        {/* Sidebar */}
        <nav className="col-md-3 col-lg-2 d-md-block bg-light sidebar py-4">
          <div className="sidebar-sticky">
            <h5>Folders</h5>
            <ul className="nav flex-column">
              {FOLDERS.map((folder) => (
                <li
                  key={folder}
                  className={`nav-item ${selectedFolder === folder ? 'active' : ''}`}
                  style={{ cursor: 'pointer' }}
                  onClick={() => handleFolderClick(folder)}
                >
                  {folder}/
                </li>
              ))}
            </ul>
          </div>
        </nav>
        {/* Main Content */}
        <main className="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
          <h2>Data Model Browser</h2>
          <p>Select a folder to view its files and metadata.</p>
          {loading && <div className="alert alert-info">Loading...</div>}
          {error && <div className="alert alert-danger">{error}</div>}
          {selectedFolder && !loading && !error && (
            <div>
              <h4>Files in <code>{selectedFolder}/</code></h4>
              <ul className="list-group">
                {files.map((file) => (
                  <li key={file.sha} className="list-group-item d-flex align-items-center">
                    <span className="me-2">
                      {file.type === 'dir' ? '📁' : '📄'}
                    </span>
                    <span>{file.name}</span>
                  </li>
                ))}
                {files.length === 0 && <li className="list-group-item">No files found.</li>}
              </ul>
            </div>
          )}
        </main>
      </div>
    </div>
  )
}

export default App
