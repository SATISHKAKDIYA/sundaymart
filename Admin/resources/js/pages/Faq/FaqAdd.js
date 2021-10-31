import React from 'react';
import {Breadcrumb, Button, Checkbox, Form, Input, Layout, Modal, PageHeader, Radio, Select, Spin, Upload} from "antd";
import {Link} from "react-router-dom";
import PageLayout from "../../layouts/PageLayout";
import shopActive from "../../requests/Shops/ShopActive";
import languageActive from "../../requests/Language/LanguageActive";
import categoryGet from "../../requests/Categories/CategoryGet";
import faqSave from "../../requests/Faq/FaqSave";

const {Option} = Select;
const {Content} = Layout;
const {TextArea} = Input;

class FaqAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            shops: [],
            language: "en",
            languages: [],
            questions: {},
            answers: {},
            active: true,
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false
        };

        this.getActiveShops = this.getActiveShops.bind(this);
        this.onChangeAnswer = this.onChangeAnswer.bind(this);
        this.getActiveLanguages = this.getActiveLanguages.bind(this);
        this.changeStatus = this.changeStatus.bind(this);
        this.onChangeLanguage = this.onChangeLanguage.bind(this);
        this.onChangeQuestion = this.onChangeQuestion.bind(this);
        this.getInfoById = this.getInfoById.bind(this);

        this.getActiveLanguages();
        this.getActiveShops();
    }

    getInfoById = async (id) => {
        let data = await categoryGet(id);
        if (data.data.success) {
            let category = data.data.data.category;
            let categories_language = data.data.data.categories_language;

            var questionsArray = this.state.questions;
            for (let i = 0; i < categories_language.length; i++) {
                var lang = categories_language[i].short_name;
                questionsArray[lang] = categories_language[i].name;
            }

            this.setState({
                active: category.active == 1 ? true : false,
                questions: questionsArray,
                shop_id: category.id_shop,
            });

            this.formRef.current.setFieldsValue({
                name: questionsArray[this.state.language],
                shop: parseInt(category.id_shop),
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

            var questionsArray = this.state.questions;
            var answersArray = this.state.answers;

            for (let i = 0; i < data.data.data.length; i++) {
                var lang = data.data.data[i].short_name;
                questionsArray[lang] = "";
                answersArray[lang] = "";
            }

            this.setState({
                questions: questionsArray,
                answers: answersArray
            });

            if (this.state.edit)
                this.getInfoById(this.state.id);
        }
    }

    getActiveShops = async () => {
        let data = await shopActive();
        if (data.data.success == 1 && data.data.data.length > 0) {

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

    changeStatus = (e) => {
        this.setState({
            active: e.target.checked
        });
    }

    onChangeQuestion = (e) => {
        var questionsArray = this.state.questions;
        questionsArray[this.state.language] = e.target.value;
        this.setState({
            questions: questionsArray
        });
    }

    onChangeAnswer = (e) => {
        var answersArray = this.state.answers;
        answersArray[this.state.language] = e.target.value;
        this.setState({
            answers: questionsArray
        });
    }

    onChangeLanguage = (e) => {
        let lang = e.target.value;
        this.setState({
            language: lang
        });

        this.formRef.current.setFieldsValue({
            question: this.state.questions[lang],
            answer: this.state.answers[lang]
        });
    };

    onFinish = async (values) => {
        let data = await faqSave(this.state.questions, this.state.answers, values.shop, this.state.active, this.state.id);

        if (data.data.success == 1)
            window.history.back();
    };

    onFinishFailed = (errorInfo) => {
    };

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/faq" className="nav-text">Faq</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => window.history.back()}
                    className="site-page-header"
                    title={this.state.edit ? "Faq Edit" : "Faq Add"}
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
                                        <Form.Item label="Question" name="question"
                                                   rules={[{required: true, message: 'Missing question'}]}
                                                   tooltip="Enter question">
                                            <TextArea showCount maxLength={1000}
                                                      onChange={this.onChangeQuestion}/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Answer" name="answer"
                                                   rules={[{required: true, message: 'Missing answer'}]}
                                                   tooltip="Enter answer">
                                            <TextArea showCount maxLength={1000}
                                                      onChange={this.onChangeAnswer}/>
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

export default FaqAdd;
