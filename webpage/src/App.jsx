import React, { useState } from 'react'
import DataModelBrowser from '../components/DataModelBrowser'
import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap-icons/font/bootstrap-icons.css'

const FOLDERS = [
  { name: 'conceptual', path: 'conceptual/' },
  { name: 'logical/enterprise', path: 'logical/enterprise/' },
  { name: 'logical/application', path: 'logical/application/' },
  { name: 'business', path: 'business/' },
  { name: 'physical', path: 'physical/' },
]

// Example static data; replace with dynamic fetch logic as needed
const filesByFolder = {
  'conceptual/': [
    { name: '.DS_Store', path: 'conceptual/.DS_Store' },
    { name: 'README.md', path: 'conceptual/README.md' },
    { name: 'cdm_to_eldm_mapping.csv', path: 'conceptual/cdm_to_eldm_mapping.csv' },
    { name: 'party-cdm.json', path: 'conceptual/party-cdm.json' },
    { name: 'svg', path: 'conceptual/svg', type: 'folder' },
  ],
  // Add other folders as needed
}

function App() {
  // For dynamic fetch, you can manage state here and pass to DataModelBrowser
  return (
    <DataModelBrowser folders={FOLDERS} filesByFolder={filesByFolder} />
  )
}

export default App
