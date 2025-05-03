import React from 'react';
import { Offcanvas, ListGroup } from 'react-bootstrap';

const SidebarOffcanvas = ({ show, onHide, folders, onSelectFolder, selectedFolder }) => (
  <Offcanvas show={show} onHide={onHide} backdrop="static" scroll>
    <Offcanvas.Header closeButton>
      <Offcanvas.Title>
        <i className="bi bi-folder2-open me-2"></i>Folders
      </Offcanvas.Title>
    </Offcanvas.Header>
    <Offcanvas.Body>
      <ListGroup variant="flush">
        {folders.map(folder => (
          <ListGroup.Item
            key={folder.path}
            action
            active={selectedFolder === folder.path}
            onClick={() => onSelectFolder(folder.path)}
            className="d-flex align-items-center"
          >
            <i className="bi bi-folder-fill me-2"></i>
            {folder.name}
          </ListGroup.Item>
        ))}
      </ListGroup>
    </Offcanvas.Body>
  </Offcanvas>
);

export default SidebarOffcanvas; 