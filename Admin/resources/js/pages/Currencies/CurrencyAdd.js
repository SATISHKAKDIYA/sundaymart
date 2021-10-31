import React from 'react';
import {Breadcrumb, Button, Checkbox, Form, Input, Layout, Modal, PageHeader, Radio, Select, Spin, Upload} from "antd";
import {Link} from "react-router-dom";
import PageLayout from "../../layouts/PageLayout";
import languageActive from "../../requests/Language/LanguageActive";
import currencySave from "../../requests/Currencies/CurrencySave";
import currencyGet from "../../requests/Currencies/CurrencyGet";

const {Content} = Layout;

class CurrencyAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            active: true,
            language: "en",
            languages: [],
            names: {},
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false
        };

        this.getActiveLanguages = this.getActiveLanguages.bind(this);
        this.onChangeName = this.onChangeName.bind(this);
        this.onChangeLanguage = this.onChangeLanguage.bind(this);

        this.getActiveLanguages();
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

    getInfoById = async (id) => {
        let data = await currencyGet(id);
        if (data.data.success) {
            let currency = data.data.data.currency;
            let currency_language = data.data.data.currency_language;

            var namesArray = this.state.names;
            for (let i = 0; i < currency_language.length; i++) {
                var lang = currency_language[i].short_name;
                namesArray[lang] = currency_language[i].name;
            }

            this.setState({
                active: currency.active == 1 ? true : false,
                names: namesArray,
            });

            this.formRef.current.setFieldsValue({
                name: namesArray[this.state.language],
                symbol: currency.symbol
            });
        }
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

    changeStatus = (e) => {
        this.setState({
            active: e.target.checked
        });
    }

    onFinish = async (values) => {
        let data = await currencySave(this.state.names, values.symbol, this.state.active, this.state.id);

        if (data.data.success == 1)
            window.history.back();
    };

    onFinishFailed = (errorInfo) => {
    };

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/currencies" className="nav-text">Currencies</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => window.history.back()}
                    className="site-page-header"
                    title={this.state.edit ? "Currency Edit" : "Currency Add"}
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
                                                   rules={[{required: true, message: 'Missing currency name'}]}
                                                   tooltip="Enter currency name">
                                            <Input placeholder="Name"
                                                   onChange={this.onChangeName}/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Symbol" name="symbol"
                                                   rules={[{required: true, message: 'Missing currency symbol'}]}
                                                   tooltip="Enter currency symbol">
                                            <Input placeholder="Symbol"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Status" name="active"
                                                   tooltip="Uncheck if currency is inactive">
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

export default CurrencyAdd;
