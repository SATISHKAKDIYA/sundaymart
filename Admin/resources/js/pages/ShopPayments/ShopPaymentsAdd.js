import React from 'react';
import {Breadcrumb, Button, Checkbox, Form, Input, Layout, Modal, PageHeader, Radio, Select, Spin, Upload} from "antd";
import {Link} from "react-router-dom";
import PageLayout from "../../layouts/PageLayout";
import shopActive from "../../requests/Shops/ShopActive";
import shopsCurrencyGet from "../../requests/ShopCurrencies/ShopsCurrencyGet";
import paymentsActive from "../../requests/Payments/PaymentsActive";
import shopPaymentsSave from "../../requests/ShopPayments/ShopPaymentsSave";
import shopPaymentGet from "../../requests/ShopPayments/ShopPaymentsGet";

const {Content} = Layout;
const {Option} = Select;

class ShopPaymentsAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            shops: [],
            payments: [],
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false
        };

        this.onChangeLanguage = this.onChangeLanguage.bind(this);

        this.getActiveShops();
        this.getActivePayments();

        if (this.state.edit)
            this.getInfoById(this.state.id);
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

    getActivePayments = async () => {
        let data = await paymentsActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                payments: data.data.data,
            });

            this.formRef.current.setFieldsValue({
                payment: data.data.data[0].id
            });
        }
    }

    getInfoById = async (id) => {
        let data = await shopPaymentGet(id);
        if (data.data.success) {
            let shopPayment = data.data.data;

            this.formRef.current.setFieldsValue({
                payment: shopPayment.id_payment,
                shop: shopPayment.id_shop
            });
        }
    }

    onChangeLanguage = (e) => {
        let lang = e.target.value;
        this.setState({
            language: lang
        });

        this.formRef.current.setFieldsValue({
            name: this.state.names[lang]
        });
    };

    onFinish = async (values) => {
        let data = await shopPaymentsSave(values.shop, values.payment, this.state.id);

        if (data.data.success == 1)
            window.history.back();
    };

    onFinishFailed = (errorInfo) => {
    };

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/shops-payments" className="nav-text">Shop
                        payments</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => window.history.back()}
                    className="site-page-header"
                    title={this.state.edit ? "Shop payment Edit" : "Shop payment Add"}
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
                                        <Form.Item label="Payments" name="payment"
                                                   rules={[{required: true, message: 'Missing payment'}]}
                                                   tooltip="Select payment">
                                            <Select placeholder="Select payment">
                                                {
                                                    this.state.payments.map((item) => {
                                                        return (
                                                            <Option value={item.id} key={item.id}>{item.name}</Option>);
                                                    })
                                                }
                                            </Select>
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

export default ShopPaymentsAdd;
