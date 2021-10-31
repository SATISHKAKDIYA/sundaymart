import React from 'react';
import {Breadcrumb, Button, Checkbox, Form, Input, Layout, Modal, PageHeader, Select, Spin, Upload} from "antd";
import {Link} from "react-router-dom";
import PageLayout from "../../../layouts/PageLayout";
import brandSave from "../../../requests/Brands/BrandSave";
import brandGet from "../../../requests/Brands/BrandGet";
import permissionSave from "../../../requests/Permissions/PermissionSave";

const {Option} = Select;
const {Content} = Layout;

class PermissionAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false
        };

        if (this.state.edit)
            this.getInfoById(this.state.id);
    }

    getInfoById = async (id) => {
        let data = await brandGet(id);
        if (data.data.success) {
            let brand = data.data.data;
            this.setState({
                active: brand.active == 1 ? true : false,
                fileList: [
                    {
                        uid: '-1',
                        name: brand.image_url,
                        status: 'done',
                        url: '/uploads/' + brand.image_url,
                    },
                ],
            });

            this.formRef.current.setFieldsValue({
                dragger: this.state.fileList,
                name: brand.name,
                shop: brand.id_shop
            });
        }
    }

    onFinish = async (values) => {
        let data = await permissionSave(values.url, this.state.id);

        if (data.data.success == 1)
            window.history.back();
    };

    onFinishFailed = (errorInfo) => {
    };

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/permissions" className="nav-text">Permissions</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => window.history.back()}
                    className="site-page-header"
                    title={this.state.edit ? "Permission Edit" : "Permission Add"}
                >
                    <Content
                        className="site-layout-background padding-20">
                        <Form
                            ref={this.formRef}
                            name="basic"
                            initialValues={{}}
                            layout="vertical"
                            onFinish={this.onFinish}
                            onFinishFailed={this.onFinishFailed}
                        >
                            <div className="row">
                                <div className="col-md-6 col-sm-12">
                                    <Form.Item label="Url" name="url"
                                               rules={[{required: true, message: 'Missing url'}]}
                                               tooltip="Enter url">
                                        <Input placeholder="Url"/>
                                    </Form.Item>
                                </div>
                            </div>
                            <Form.Item>
                                <Button type="primary" className="btn-success" style={{marginTop: '40px'}}
                                        htmlType="submit">Save</Button>
                            </Form.Item>
                        </Form>
                    </Content>
                </PageHeader>
            </PageLayout>
        );
    }
}

export default PermissionAdd;
