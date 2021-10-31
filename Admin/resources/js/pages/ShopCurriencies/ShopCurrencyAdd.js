import React from 'react';
import {Breadcrumb, Button, Checkbox, Form, Input, Layout, Modal, PageHeader, Radio, Select, Spin, Upload} from "antd";
import {Link} from "react-router-dom";
import PageLayout from "../../layouts/PageLayout";
import shopActive from "../../requests/Shops/ShopActive";
import currencyActive from "../../requests/Currencies/CurrencyActive";
import shopsCurrencyDefault from "../../requests/ShopCurrencies/ShopsCurrencyDefault";
import shopsCurrencySave from "../../requests/ShopCurrencies/ShopsCurrencySave";
import shopsCurrencyGet from "../../requests/ShopCurrencies/ShopsCurrencyGet";

const {Content} = Layout;
const {Option} = Select;

class ShopCurrencyAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            shops: [],
            currencies: [],
            defaultCurrency: null,
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false
        };

        this.onChangeLanguage = this.onChangeLanguage.bind(this);

        this.getActiveShops();
        this.getActiveCurrencies();

        if (this.state.edit)
            this.getInfoById(this.state.id);
    }

    getDefaultCurrency = async (id_shop) => {
        let data = await shopsCurrencyDefault(id_shop);
        console.log(data);
        if (data.data.success == 1) {
            this.setState({
                defaultCurrency: data.data.data,
            });
        }
    }

    getActiveShops = async () => {
        let data = await shopActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                shops: data.data.data,
            });

            this.getDefaultCurrency(data.data.data[0].id);

            this.formRef.current.setFieldsValue({
                shop: data.data.data[0].id
            });
        }
    }

    getActiveCurrencies = async () => {
        let data = await currencyActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                currencies: data.data.data,
            });

            this.formRef.current.setFieldsValue({
                currency: this.state.defaultCurrency != null && this.state.defaultCurrency.id != data.data.data[0].id ? data.data.data[0].id : data.data.data[1].id
            });
        }
    }

    getInfoById = async (id) => {
        let data = await shopsCurrencyGet(id);
        if (data.data.success) {
            let shopCurrency = data.data.data;

            this.formRef.current.setFieldsValue({
                value: shopCurrency.value,
                currency: shopCurrency.id_currency,
                shop: shopCurrency.id_shop
            });
        }
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

    onChangeShop = (e) => {
        this.getDefaultCurrency(e.target.value);
    }


    onFinish = async (values) => {
        let data = await shopsCurrencySave(values.shop, values.currency, this.state.defaultCurrency == null ? 1 : 0, this.state.defaultCurrency == null ? 1 : values.value, this.state.id);

        if (data.data.success == 1)
            window.history.back();
    };

    onFinishFailed = (errorInfo) => {
    };

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/shops-currencies" className="nav-text">Shop
                        currencies</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => window.history.back()}
                    className="site-page-header"
                    title={this.state.edit ? "Shop currency Edit" : "Shop currency Add"}
                >
                    <Content
                        className="site-layout-background padding-20">
                        {
                            (this.state.shops.length > 0) ? (<Form
                                ref={this.formRef}
                                name="basic"
                                initialValues={{}}
                                layout="vertical"
                                onFinish={this.onFinish}
                                onFinishFailed={this.onFinishFailed}
                            >
                                <div className="row">
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
                                        <Form.Item label="Currency" name="currency"
                                                   rules={[{required: true, message: 'Missing currency'}]}
                                                   tooltip="Select currency">
                                            <Select placeholder="Select currency">
                                                {
                                                    this.state.currencies.map((item) => {
                                                        if (this.state.defaultCurrency != null && this.state.defaultCurrency.id == item.id)
                                                            return null;
                                                        return (
                                                            <Option value={item.id} key={item.id}>{item.name}</Option>);
                                                    })
                                                }
                                            </Select>
                                        </Form.Item>
                                    </div>
                                    {
                                        this.state.defaultCurrency != null && (
                                            <div className="col-md-6 col-sm-12">
                                                <Form.Item label="Value" name="value"
                                                           rules={[{required: true, message: 'Missing currency value'}]}
                                                           tooltip="Enter currency value">
                                                    <Input placeholder="Value"
                                                           suffix={<div>{this.state.defaultCurrency.symbol}</div>}/>
                                                </Form.Item>
                                            </div>
                                        )
                                    }

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

export default ShopCurrencyAdd;
