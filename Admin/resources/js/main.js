import React from 'react';
import ReactDOM from 'react-dom';
import Routes from "./routes";

class Main extends React.Component {
    render() {
        return <Routes/>;
    }
}

export default Main;

if (document.getElementById('app')) {
    ReactDOM.render(<Main/>, document.getElementById('app'));
}
