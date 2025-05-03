import React from 'react';
import { ListGroup } from 'react-bootstrap';

const getFileIcon = (file) => {
  if (file.type === 'folder') return 'bi-folder2';
  if (file.name.endsWith('.md')) return 'bi-file-earmark-text';
  if (file.name.endsWith('.csv')) return 'bi-filetype-csv';
  if (file.name.endsWith('.json')) return 'bi-filetype-json';
  if (file.name.endsWith('.svg')) return 'bi-filetype-svg';
  return 'bi-file-earmark';
};

const FileList = ({ files, onFileClick }) => (
  <ListGroup>
    {files.map(file => (
      <ListGroup.Item
        key={file.path}
        action
        onClick={() => onFileClick(file)}
        className="d-flex align-items-center"
      >
        <i className={`bi ${getFileIcon(file)} me-2`}></i>
        {file.name}
      </ListGroup.Item>
    ))}
  </ListGroup>
);

export default FileList; 