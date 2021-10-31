import React, {useContext, useState} from 'react';
import {Layout, Form, Input, Checkbox, Button, Card} from "antd";
import LoginRequest from "../requests/LoginRequest";
import {AuthContext} from "../helpers/AuthProvider";
import {Redirect, Link} from "react-router-dom";

const Login = (props) => {
    const {signin, isAuthenticated} = useContext(AuthContext);
    const [error, setError] = useState("");
    const [url, setUrl] = useState("/");
    var [redirect, setRedirect] = useState(false);

    const onFinish = async (values) => {
        const data = await LoginRequest(values.email, values.password);
        if (data.data.success == 1) {
            signin(true, data.data.token);
            await localStorage.setItem('user', JSON.stringify(data.data.data));
            await localStorage.setItem('permission', JSON.stringify(data.data.permissions));

            setUrl(data.data.permissions[0].url);

            setRedirect(true);
        } else {
            setError(data.data.msg);
            //remove error after 5 seconds
            setTimeout(() => {
                setError("");
            }, 5000);
        }
    };

    const onFinishFailed = (errorInfo) => {
        console.log('Failed:', errorInfo);
    };

    if (redirect)
        return (<Redirect to={url}/>);

    return (<Layout className="site-layout-background login justify-content-center" style={{minHeight: '100vh'}}>
        <div className="container">
            <div className="row justify-content-center">
                <div className="col-xl-5 col-lg-6 col-md-5">
                    <Card className="shadow-lg my-5 border-0 overflow-hidden">
                        <Form
                            name="basic"
                            initialValues={{
                                remember: true,
                            }}
                            onFinish={onFinish}
                            onFinishFailed={onFinishFailed}
                        >
                            <h1 className="h4 text-gray-900 mb-4 text-center">Welcome to <b
                                className="text-success">Gmarket</b></h1>
                            <Form.Item
                                name="email"
                                rules={[
                                    {
                                        required: true,
                                        message: 'Please input your email!',
                                    },
                                ]}
                            >
                                <Input placeholder="Email"/>
                            </Form.Item>

                            <Form.Item
                                name="password"
                                rules={[
                                    {
                                        required: true,
                                        message: 'Please input your password!',
                                    },
                                ]}
                            >
                                <Input.Password placeholder="Password"/>
                            </Form.Item>

                            <Form.Item name="remember" valuePropName="checked">
                                <Checkbox>Remember me</Checkbox>
                            </Form.Item>

                            <Form.Item>
                                <Button type="primary" htmlType="submit">
                                    Submit
                                </Button>
                            </Form.Item>

                            <Form.Item style={{textAlign: 'center'}}>
                                Dou you have shop ? <Link to="sign-up">join us</Link>
                            </Form.Item>

                            {
                                error.length > 0 && (
                                    <div className="text-center">
                                        <span className="text-danger">{error}</span>
                                    </div>
                                )
                            }
                        </Form>
                    </Card>
                </div>
            </div>
        </div>
    </Layout>);
}

export default Login;
