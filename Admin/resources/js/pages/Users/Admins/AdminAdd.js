import React from 'react';
import {
    Breadcrumb,
    Button,
    Checkbox,
    Form,
    Input,
    Layout,
    Modal,
    PageHeader,
    Select,
    Spin,
    Upload,
    message
} from "antd";
import {Link} from "react-router-dom";
import PageLayout from "../../../layouts/PageLayout";
import {PlusOutlined} from "@ant-design/icons";
import shopActive from "../../../requests/Shops/ShopActive";
import roleActive from "../../../requests/RoleActive";
import adminSave from "../../../requests/Admins/AdminSave";
import adminGet from "../../../requests/Admins/AdminGet";

const {Option} = Select;
const {Content} = Layout;

class AdminAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            previewImage: "",
            previewVisible: false,
            previewTitle: "",
            fileList: [],
            shops: [],
            roles: [],
            active: true,
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false
        };

        this.getActiveShops = this.getActiveShops.bind(this);
        this.getActiveRoles = this.getActiveRoles.bind(this);
        this.changeStatus = this.changeStatus.bind(this);

        this.getActiveShops();
        this.getActiveRoles();

        if (this.state.edit)
            this.getInfoById(this.state.id);
    }

    getInfoById = async (id) => {
        let data = await adminGet(id);
        if (data.data.success) {
            let admin = data.data.data;
            this.setState({
                active: admin.active == 1 ? true : false,
                fileList: [
                    {
                        uid: '-1',
                        name: admin.image_url,
                        status: 'done',
                        url: '/uploads/' + admin.image_url,
                    },
                ],
            });

            var phone = admin.phone.split(" ");

            this.formRef.current.setFieldsValue({
                dragger: this.state.fileList,
                name: admin.name,
                surname: admin.surname,
                email_admin: admin.email,
                prefix_phone: phone[0],
                phone: phone[1],
                shop: admin.id_shop,
                role: admin.id_role
            });
        }
    }

    getActiveShops = async () => {
        let data = await shopActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                shops: data.data.data,
            });

            this.formRef.current.setFieldsValue({
                shop: data.data.data[0].id
            });
        }
    }

    getActiveRoles = async () => {
        let data = await roleActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                roles: data.data.data,
            });

            this.formRef.current.setFieldsValue({
                role: data.data.data[1].id
            });
        }
    }

    changeStatus = (e) => {
        this.setState({
            active: e.target.checked
        });
    }

    onFinish = async (values) => {
        if (values.password_admin != values.confirm_password) {
            message.error('Password and confirm password mismatch');
            return false;
        }

        let data = await adminSave(values.name, values.surname, values.email_admin, values.prefix_phone + " " + values.phone, values.password_admin, values.shop, values.role, this.state.fileList[0].name, this.state.active, this.state.id);

        if (data.data.success == 1)
            window.history.back();
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
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/admins" className="nav-text">Admins</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => window.history.back()}
                    className="site-page-header"
                    title={this.state.edit ? "Admin Edit" : "Admin Add"}
                >
                    <Content
                        className="site-layout-background padding-20">
                        {
                            (this.state.shops.length > 0) ? (<Form
                                ref={this.formRef}
                                name="basic"
                                initialValues={{
                                    prefix_phone: "+1",
                                }}
                                layout="vertical"
                                onFinish={this.onFinish}
                                onFinishFailed={this.onFinishFailed}
                            >
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
                                        <Form.Item label="Shop" name="shop"
                                                   rules={[{required: true, message: 'Missing shop'}]}
                                                   tooltip="Select shop">
                                            <Select placeholder="Select shop">
                                                {
                                                    this.state.shops.map((item) => {
                                                        return (
                                                            <Option value={item.id} key={item.id}>{item.name}</Option>);
                                                    })
                                                }
                                            </Select>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Role" name="role"
                                                   rules={[{required: true, message: 'Missing role'}]}
                                                   tooltip="Select role">
                                            <Select placeholder="Select role">
                                                {
                                                    this.state.roles.map((item) => {
                                                        return (
                                                            <Option disabled={item.id == 1 ? true : false}
                                                                    value={item.id} key={item.id}>{item.name}</Option>);
                                                    })
                                                }
                                            </Select>
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
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Status" name="active"
                                                   tooltip="Uncheck if brand is inactive">
                                            <Checkbox checked={this.state.active}
                                                      onChange={this.changeStatus}>{this.state.active ? "Active" : "Inactive"}</Checkbox>
                                        </Form.Item>
                                    </div>
                                </div>
                                <Form.Item>
                                    <Button type="primary" className="btn-success" style={{marginTop: '40px'}}
                                            htmlType="submit">Save</Button>
                                </Form.Item>
                            </Form>) : (
                                <div className="d-flex flex-row justify-content-center" style={{height: '400px'}}>
                                    <Spin style={{marginTop: 'auto', marginBottom: 'auto'}} size="large"/>
                                </div>)
                        }
                    </Content>
                </PageHeader>
            </PageLayout>
        );
    }
}

export default AdminAdd;
