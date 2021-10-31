import React from 'react';
import {
    MessageOutlined
} from '@ant-design/icons';

const ChatButton = (props) => {
    return (
        <div className="fixed-bottom chat-button">
            <MessageOutlined style={{ fontSize: '24px', color: '#08c', marginTop: 'auto', marginBottom: 'auto' }}/>
        </div>
    );
}

export default ChatButton;
