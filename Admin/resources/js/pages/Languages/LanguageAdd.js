import React from 'react';
import {Breadcrumb, Input, Layout, PageHeader, Form, Upload, Button, Checkbox, Modal, Spin} from "antd";
import {Link} from "react-router-dom";
import PageLayout from "../../layouts/PageLayout";
import {PlusOutlined} from '@ant-design/icons';
import languageSave from "../../requests/Language/LanguageSave";
import languageGet from "../../requests/Language/LanguageGet";

const {Content} = Layout;

class LanguageAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            active: true,
            previewImage: "",
            previewVisible: false,
            previewTitle: "",
            fileList: [],
            editInfo: {},
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false
        }

        this.changeStatus = this.changeStatus.bind(this);
        this.getInfoById = this.getInfoById.bind(this);
    }

    componentDidMount() {
        if (this.state.edit)
            setTimeout(() => this.getInfoById(this.state.id), 1000);
    }

    getInfoById = async (id) => {
        let data = await languageGet(id);
        if (data.data.success) {
            let language = data.data.data;
            this.setState({
                editInfo: language,
                active: language.active == 1 ? true : false,
                fileList: [
                    {
                        uid: '-1',
                        name: language.image_url,
                        status: 'done',
                        url: '/uploads/' + language.image_url,
                    },
                ],
            });

            this.formRef.current.setFieldsValue({
                name: this.state.editInfo.name,
                code: this.state.editInfo.short_name,
                dragger: this.state.fileList,
            });
        }
    }

    changeStatus = (e) => {
        this.setState({
            active: e.target.checked
        });
    }

    onFinish = async (values) => {
        let data = await languageSave(values.name, values.code, this.state.fileList[0].name, this.state.active, this.state.id);

        if (data.data.success == 1)
            window.history.back();

    };

    onFinishFailed = (errorInfo) => {
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

    normFile = (e) => {
        if (Array.isArray(e)) {
            return e;
        }

        return e && e.fileList;
    };

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/languages" className="nav-text">Languages</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => window.history.back()}
                    className="site-page-header"
                    title={this.state.edit ? "Language Edit" : "Language Add"}
                >
                    <Content
                        className="site-layout-background padding-20">
                        <Form
                            ref={this.formRef}
                            name="basic"
                            layout="vertical"
                            onFinish={this.onFinish}
                            onFinishFailed={this.onFinishFailed}
                        >
                            <div className="row">
                                <div className="col-md-6 col-sm-12">
                                    <Form.Item label="Name" name="name"
                                               rules={[{required: true, message: 'Missing language name'}]}
                                               tooltip="Write here language name">
                                        <Input placeholder="Name"/>
                                    </Form.Item>
                                </div>
                                <div className="col-md-6 col-sm-12">
                                    <Form.Item label="Short code" name="code"
                                               rules={[{required: true, message: 'Missing language short code'}]}
                                               tooltip="Write here language short code">
                                        <Input placeholder="Address"/>
                                    </Form.Item>
                                </div>
                                <div className="col-md-3 col-sm-6">
                                    <Form.Item label="Logo" tooltip="Upload language logo">
                                        <Form.Item name="dragger" valuePropName="fileList"
                                                   getValueFromEvent={this.normFile}
                                                   rules={[{
                                                       required: true,
                                                       message: 'Missing language logo image'
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
                                <div className="col-md-3 col-sm-6">
                                    <Form.Item label="Status" name="code"
                                               tooltip="Uncheck if language is inactive">
                                        <Checkbox checked={this.state.active}
                                                  onChange={this.changeStatus}>{this.state.active ? "Active" : "Inactive"}</Checkbox>
                                    </Form.Item>
                                </div>
                            </div>
                            <Form.Item>
                                <Button type="primary" className="btn-success" htmlType="submit">Save</Button>
                            </Form.Item>
                        </Form>
                    </Content>
                </PageHeader>
            </PageLayout>
        );
    }
}

export default LanguageAdd;
