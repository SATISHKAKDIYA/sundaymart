import React from 'react';
import PageLayout from "../../layouts/PageLayout";
import {
    Breadcrumb,
    Button,
    Layout,
    PageHeader,
    Form, Spin, Radio, Select, message,
} from "antd";
import {CKEditor} from "@ckeditor/ckeditor5-react";
import ClassicEditor from "@ckeditor/ckeditor5-build-classic";
import languageActive from "../../requests/Language/LanguageActive";
import shopActive from "../../requests/Shops/ShopActive";
import aboutSave from "../../requests/About/AboutSave";
import {Link} from "react-router-dom";
import aboutGet from "../../requests/About/AboutGet";

const {Content} = Layout;
const {Option} = Select;

class AboutAdd extends React.Component {
    formRef = React.createRef();

    state = {
        data: [],
        language: "en",
        languages: [],
        abouts: {},
        shops: [],
        id: 0
    };

    constructor(props) {
        super(props);

        this.getActiveLanguages = this.getActiveLanguages.bind(this);
        this.onChangeLanguage = this.onChangeLanguage.bind(this);
        this.getActiveShops = this.getActiveShops.bind(this);
        this.onChangeContent = this.onChangeContent.bind(this);

        this.getActiveLanguages();
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

            this.getData(data.data.data[0].id);
        }
    }

    getActiveLanguages = async () => {
        let data = await languageActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                languages: data.data.data,
                language: data.data.data[0].short_name
            });

            var aboutsArray = this.state.abouts;

            for (let i = 0; i < data.data.data.length; i++) {
                var lang = data.data.data[i].short_name;
                aboutsArray[lang] = "";
            }

            this.setState({
                abouts: aboutsArray
            });

            this.getActiveShops();
        }
    }

    onChangeLanguage = (e) => {// 99 805 5856
        let lang = e.target.value;
        this.setState({
            language: lang
        });

        this.formRef.current.setFieldsValue({
            abouts: this.state.abouts[lang]
        });
    };

    getData = async (id_shop) => {
        var aboutsArray = this.state.abouts;

        let data = await aboutGet(id_shop);
        if (data.data.success && data.data.data != null && data.data.data.languages.length > 0) {
            for (let i = 0; i < data.data.data.languages.length; i++) {
                var item = data.data.data.languages[i];
                var lang = item.language.short_name;
                aboutsArray[lang] = item.content != null ? item.content : "";
            }
        } else {
            for (let i = 0; i < this.state.languages.length; i++) {
                var lang = this.state.languages[i].short_name;
                aboutsArray[lang] = "";
            }
        }

        this.setState({
            abouts: aboutsArray
        });

        this.formRef.current.setFieldsValue({
            abouts: aboutsArray[this.state.language]
        });
    }

    onFinish = async (values) => {
        let data = await aboutSave(values.shop, this.state.abouts, this.state.id);
        console.log(data);
        if (data.data.success)
            window.history.back();
    };

    onFinishFailed = (errorInfo) => {
    };

    onChangeShop = (e) => {
        this.getData(e);
    }

    onChangeContent = (event, editor) => {
        const data = editor.getData();

        var aboutsArray = this.state.abouts;
        aboutsArray[this.state.language] = data;
        this.setState({
            abouts: aboutsArray
        });
    }

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/about" className="nav-text">About</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{"Edit"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    className="site-page-header"
                    title="Edit about"
                >
                    <Content
                        className="site-layout-background">
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
                                    <div className="col-md-4 col-sm-12">
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
                                    <div className="col-md-8 col-sm-12">
                                        <Form.Item label="About text" name="abouts"
                                                   tooltip="Enter about text">
                                            <CKEditor
                                                editor={ClassicEditor}
                                                data={this.state.abouts[this.state.language]}
                                                onChange={this.onChangeContent}

                                            />
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

export default AboutAdd;
