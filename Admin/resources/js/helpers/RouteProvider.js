import React, {useContext} from 'react';
import {AuthContext} from "./AuthProvider";
import {Redirect, Route} from 'react-router-dom';
import NotFound from "../pages/NotFound";

export const PrivateRouteProvider = ({children, ...rest}) => {
    const {isAuthenticated} = useContext(AuthContext);
    let localData = localStorage.getItem('permission');
    const permissions = localData != 'undefined' ? JSON.parse(localData) : [];
    let path = rest.path;
    let isNotAllowed = isAuthenticated && permissions != null && permissions.length > 0 && permissions.findIndex((item) => item['url'] == path) <= -1;
    return (
        isNotAllowed ?
            <Route>
                <NotFound/>
            </Route> :
            <Route
                {...rest}
                render={(props) =>
                    isAuthenticated ? (
                        React.cloneElement(children, props)
                    ) : (<Redirect
                        to={{
                            pathname: '/login',
                        }}
                    />)}
            />)
}
