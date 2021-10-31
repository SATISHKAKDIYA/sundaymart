import React from 'react';
import {Breadcrumb, Button, Checkbox, Form, Input, Layout, Modal, PageHeader, Radio, Select, Spin, Upload} from "antd";
import {Link} from "react-router-dom";
import PageLayout from "../../layouts/PageLayout";
import {PlusOutlined} from "@ant-design/icons";
import shopActive from "../../requests/Shops/ShopActive";
import categoryParent from "../../requests/Categories/CategoryParent";
import categorySave from "../../requests/Categories/CategorySave";
import languageActive from "../../requests/Language/LanguageActive";
import categoryGet from "../../requests/Categories/CategoryGet";

const {Option} = Select;
const {Content} = Layout;

class CategoryAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            previewImage: "",
            previewVisible: false,
            previewTitle: "",
            fileList: [],
            shops: [],
            shop_id: -1,
            category_id: -1,
            parents: [],
            language: "en",
            languages: [],
            names: {},
            active: true,
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false
        };

        this.getActiveShops = this.getActiveShops.bind(this);
        this.getActiveParent = this.getActiveParent.bind(this);
        this.getActiveLanguages = this.getActiveLanguages.bind(this);
        this.changeStatus = this.changeStatus.bind(this);
        this.onChangeLanguage = this.onChangeLanguage.bind(this);
        this.onChangeName = this.onChangeName.bind(this);
        this.onChangeShop = this.onChangeShop.bind(this);
        this.getInfoById = this.getInfoById.bind(this);

        this.getActiveLanguages();
        this.getActiveShops();
    }

    getInfoById = async (id) => {
        let data = await categoryGet(id);
        if (data.data.success) {
            let category = data.data.data.category;
            let categories_language = data.data.data.categories_language;

            this.getActiveParent(category.id_shop);

            var namesArray = this.state.names;
            for (let i = 0; i < categories_language.length; i++) {
                var lang = categories_language[i].short_name;
                namesArray[lang] = categories_language[i].name;
            }

            this.setState({
                active: category.active == 1 ? true : false,
                names: namesArray,
                shop_id: category.id_shop,
                category_id: category.parent,
                fileList: [
                    {
                        uid: '-1',
                        name: category.image_url,
                        status: 'done',
                        url: '/uploads/' + category.image_url,
                    },
                ],
            });

            this.formRef.current.setFieldsValue({
                dragger: this.state.fileList,
                name: namesArray[this.state.language],
                shop: parseInt(category.id_shop),
                parent: category.parent,
            });
        }
    }

    getActiveLanguages = async () => {
        let data = await languageActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                languages: data.data.data,
                language: data.data.data[0].short_name
            });

            var namesArray = this.state.names;

            for (let i = 0; i < data.data.data.length; i++) {
                var lang = data.data.data[i].short_name;
                namesArray[lang] = "";
            }

            this.setState({
                names: namesArray
            });

            if (this.state.edit)
                this.getInfoById(this.state.id);
        }
    }

    getActiveShops = async () => {
        let data = await shopActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.getActiveParent(data.data.data[0].id);

            this.setState({
                shops: data.data.data,
                shop_id: data.data.data[0].id
            });

            if (this.formRef.current != null)
                this.formRef.current.setFieldsValue({
                    shop: data.data.data[0].id
                });
        }
    }

    onChangeShop = (e) => {
        this.setState({
            shop_id: e
        });

        this.getActiveParent(e);
    }

    getActiveParent = async (shop_id) => {
        let data = await categoryParent(shop_id);
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                parents: data.data.data,
            });

            const index = data.data.data.findIndex((element, index) => {
                if (element.id === this.state.category_id) {
                    return true
                }
            });

            this.formRef.current.setFieldsValue({
                parent: index > -1 ? this.state.category_id : data.data.data[0].id
            });
        }
    }

    changeStatus = (e) => {
        this.setState({
            active: e.target.checked
        });
    }

    onChangeName = (e) => {
        var namesArray = this.state.names;
        namesArray[this.state.language] = e.target.value;
        this.setState({
            names: namesArray
        });
    }

    onChangeLanguage = (e) => {// 99 805 5856
        let lang = e.target.value;
        this.setState({
            language: lang
        });

        this.formRef.current.setFieldsValue({
            name: this.state.names[lang]
        });
    };

    onFinish = async (values) => {
        let data = await categorySave(this.state.names, values.shop, values.parent, this.state.fileList[0].name, this.state.active, this.state.id);

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
                    <Breadcrumb.Item><Link to="/categories" className="nav-text">Categories</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => window.history.back()}
                    className="site-page-header"
                    title={this.state.edit ? "Category Edit" : "Category Add"}
                >
                    <Content
                        className="site-layout-background padding-20">
                        {
                            (this.state.languages.length > 0) ? (<Form
                                ref={this.formRef}
                                name="basic"
                                initialValues={{}}
                                layout="vertical"
                                onFinish={this.onFinish}
                                onFinishFailed={this.onFinishFailed}
                            >
                                <div className="row">
                                    <div className="col-md-12 col-sm-12">
                                        <Radio.Group value={this.state.language} onChange={this.onChangeLanguage}
                                                     className="float-right">
                                            {
                                                this.state.languages.map((item) => {
                                                    return (
                                                        <Radio.Button value={item.short_name}
                                                                      key={item.short_name}>{item.name}</Radio.Button>);
                                                })
                                            }
                                        </Radio.Group>
                                    </div>
                                </div>
                                <div className="row">
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Name" name="name"
                                                   rules={[{required: true, message: 'Missing category name'}]}
                                                   tooltip="Enter category name">
                                            <Input placeholder="Name"
                                                   onChange={this.onChangeName}/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Shop" name="shop"
                                                   rules={[{required: true, message: 'Missing shop'}]}
                                                   tooltip="Select shop">
                                            <Select placeholder="Select shop" onChange={this.onChangeShop}>
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
                                        <Form.Item label="Parent category" name="parent"
                                                   rules={[{required: true, message: 'Missing parent category'}]}
                                                   tooltip="Select parent category">
                                            <Select placeholder="Select parent category">
                                                {
                                                    this.state.parents.map((item) => {
                                                        return (
                                                            <Option value={item.id} key={item.id}>{item.name}</Option>);
                                                    })
                                                }
                                            </Select>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item label="Logo" tooltip="Upload shop logo">
                                            <Form.Item name="dragger" valuePropName="fileList"
                                                       getValueFromEvent={this.normFile}
                                                       rules={[{
                                                           required: true,
                                                           message: 'Missing category image'
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
                                        <Form.Item label="Status" name="active"
                                                   tooltip="Uncheck if category is inactive">
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

export default CategoryAdd;
