import React from 'react';
import {Result, Button} from 'antd';

class NotFound extends React.Component {
    render() {
        return (
            <Result
                status="404"
                title="404"
                subTitle="Sorry, the page you visited does not exist."
                extra={<Button type="primary" onClick={() => {
                    window.history.back();
                }}>Back Home</Button>}
            />
        );
    }
}

export default NotFound;
