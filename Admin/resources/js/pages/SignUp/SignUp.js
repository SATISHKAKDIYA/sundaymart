import React from 'react';
import {Button, Card, Checkbox, Form, Input, Layout, Modal, Select, Upload} from "antd";
import {PlusOutlined} from "@ant-design/icons";
import managerSave from "../../requests/Managers/ManagersSave";

const {Option} = Select;

class SignUp extends React.Component {
    state = {
        previewImage: "",
        previewVisible: false,
        previewTitle: "",
        fileList: [],
        error: "",
        success: false
    }

    onFinish = async (values) => {
        if(values.password_admin !== values.confirm_password) {
            this.setState({
                error: "Password and confirm password mismatch"
            });

            setTimeout(() => {
                this.setState({
                    error: ""
                });
            }, 5000);

            return;
        }

        var data = await managerSave(values.name, values.surname, values.email_admin, values.phone, values.password_admin, this.state.fileList[0].name);

        if (data.data.success == 1) {
            this.setState({
                success: true
            });
        } else {
            this.setState({
                error: data.data.msg
            });

            setTimeout(() => {
                this.setState({error: ""});
            }, 5000);
        }
    };

    onFinishFailed = (errorInfo) => {
    };

    normFile = (e) => {
        if (Array.isArray(e)) {
            return e;
        }

        return e && e.fileList;
    };

    getBase64 = (file) => {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = () => resolve(reader.result);
            reader.onerror = error => reject(error);
        });
    }

    handleCancel = () => this.setState({previewVisible: false});

    handlePreview = async file => {
        if (!file.url && !file.preview) {
            file.preview = await this.getBase64(file.originFileObj);
        }

        this.setState({
            previewImage: file.url || file.preview,
            previewVisible: true,
            previewTitle: file.name || file.url.substring(file.url.lastIndexOf('/') + 1),
        });
    };

    handleChange = ({fileList}) => {
        fileList = fileList.map(file => {
            if (file.response) {
                return {
                    uid: file.uid,
                    name: file.response.name,
                    status: 'done',
                    url: '/uploads/' + file.response.name,
                };
            }
            return file;
        });

        this.setState({fileList});
    };

    render() {
        return (<Layout className="site-layout-background justify-content-center" style={{minHeight: '100vh'}}>
            <div className="container">
                <Card className="overflow-hidden">
                    {
                        !this.state.success ? (
                            <Form
                                name="basic"
                                initialValues={{
                                    remember: true,
                                }}
                                layout="vertical"
                                onFinish={this.onFinish}
                                onFinishFailed={this.onFinishFailed}
                            >
                                <h1 className="h4 text-gray-900 mb-4 text-center">Welcome to <b
                                    className="text-success">Gmarket</b></h1>
                                {
                                    this.state.error.length > 0 && (
                                        <div className="text-center">
                                            <span className="text-danger">{this.state.error}</span>
                                        </div>
                                    )
                                }
                                <div className="row">
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Name" name="name"
                                                   rules={[{required: true, message: 'Missing name'}]}
                                                   tooltip="Enter name">
                                            <Input placeholder="Name"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Surname" name="surname"
                                                   rules={[{required: true, message: 'Missing surname'}]}
                                                   tooltip="Enter surname">
                                            <Input placeholder="Surname"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Email" name="email_admin"
                                                   rules={[{required: true, message: 'Missing email'}]}
                                                   tooltip="Enter email">
                                            <Input placeholder="Email"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Phone" name="phone"
                                                   rules={[{required: true, message: 'Missing phone'}]}
                                                   tooltip="Enter phone">
                                            <Input addonBefore={(<Form.Item name="prefix_phone" noStyle>
                                                <Select
                                                    style={{
                                                        width: 70,
                                                    }}
                                                >
                                                    <Option value="+1">+1</Option>
                                                    <Option value="+8">+8</Option>
                                                </Select>
                                            </Form.Item>)} placeholder="Phone"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item
                                            label="Password"
                                            name="password_admin"
                                            tooltip="Enter password"
                                            rules={[
                                                {
                                                    required: true,
                                                    message: 'Missing password',
                                                },
                                            ]}
                                        >
                                            <Input.Password placeholder="Password"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item
                                            label="Confirm password"
                                            name="confirm_password"
                                            tooltip="Enter confirm password"
                                            rules={[
                                                {
                                                    required: true,
                                                    message: 'Missing confirm password',
                                                },
                                            ]}
                                        >
                                            <Input.Password placeholder="Confirm password"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Avatar" tooltip="Upload avatar">
                                            <Form.Item name="dragger" valuePropName="fileList"
                                                       getValueFromEvent={this.normFile}
                                                       rules={[{
                                                           required: true,
                                                           message: 'Missing avatar'
                                                       }]}
                                                       noStyle>
                                                <Upload
                                                    action="/api/auth/upload"
                                                    listType="picture-card"
                                                    fileList={this.state.fileList}
                                                    defaultFileList={this.state.fileList}
                                                    onPreview={this.handlePreview}
                                                    onChange={this.handleChange}
                                                >
                                                    {this.state.fileList.length >= 1 ? null : (
                                                        <div>
                                                            <PlusOutlined/>
                                                            <div style={{marginTop: 8}}>Upload</div>
                                                        </div>
                                                    )}
                                                </Upload>
                                            </Form.Item>
                                            <Modal
                                                visible={this.state.previewVisible}
                                                title={this.state.previewTitle}
                                                footer={null}
                                                onCancel={this.handleCancel}
                                            >
                                                <img alt="example" style={{width: '100%'}}
                                                     src={this.state.previewImage}/>
                                            </Modal>
                                        </Form.Item>
                                    </div>
                                </div>
                                <Form.Item>
                                    <Button type="primary" htmlType="submit">
                                        Submit
                                    </Button>
                                </Form.Item>
                            </Form>
                        ):(
                            <h1 className="h4 text-gray-900 mb-4 text-center text-success">Your application saved successfully. We will contact with you in short time</h1>
                        )
                    }
                </Card>
            </div>
        </Layout>);
    }
}

export default SignUp;
