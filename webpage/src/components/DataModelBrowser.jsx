import React, { useState } from 'react';
import { Container, Row, Col, Button, Card } from 'react-bootstrap';
import SidebarOffcanvas from './SidebarOffcanvas';
import FileList from './FileList';

const DataModelBrowser = ({ folders, filesByFolder }) => {
  const [showSidebar, setShowSidebar] = useState(false);
  const [selectedFolder, setSelectedFolder] = useState(folders[0]?.path || '');
  const [selectedFile, setSelectedFile] = useState(null);

  const handleSelectFolder = (folderPath) => {
    setSelectedFolder(folderPath);
    setSelectedFile(null);
    setShowSidebar(false);
  };

  const handleFileClick = (file) => {
    setSelectedFile(file);
    // Implement file view logic here if needed
  };

  return (
    <Container fluid className="py-4">
      <Row>
        <Col xs={12} className="mb-3 d-md-none">
          <Button
            variant="primary"
            onClick={() => setShowSidebar(true)}
            aria-label="Open folders sidebar"
          >
            <i className="bi bi-list"></i> Folders
          </Button>
        </Col>
        <SidebarOffcanvas
          show={showSidebar}
          onHide={() => setShowSidebar(false)}
          folders={folders}
          onSelectFolder={handleSelectFolder}
          selectedFolder={selectedFolder}
        />
        <Col md={3} className="d-none d-md-block">
          <Card>
            <Card.Header>
              <i className="bi bi-folder2-open me-2"></i>Folders
            </Card.Header>
            <Card.Body className="p-0">
              <FileList
                files={folders.map(f => ({ ...f, type: 'folder' }))}
                onFileClick={f => handleSelectFolder(f.path)}
              />
            </Card.Body>
          </Card>
        </Col>
        <Col md={9}>
          <Card>
            <Card.Header>
              Files in <span className="text-primary">{selectedFolder}</span>
            </Card.Header>
            <Card.Body>
              <FileList
                files={filesByFolder[selectedFolder] || []}
                onFileClick={handleFileClick}
              />
              {selectedFile && (
                <div className="mt-4">
                  <h5>
                    <i className="bi bi-file-earmark-text me-2"></i>
                    {selectedFile.name}
                  </h5>
                  {/* File preview logic here */}
                </div>
              )}
            </Card.Body>
          </Card>
        </Col>
      </Row>
    </Container>
  );
};

export default DataModelBrowser; 