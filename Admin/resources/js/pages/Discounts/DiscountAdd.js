import React from 'react';
import {
    Breadcrumb,
    Button,
    Checkbox,
    DatePicker,
    Form,
    InputNumber,
    Layout,
    Modal,
    PageHeader,
    Select,
    Spin,
    Upload
} from "antd";
import {Link} from "react-router-dom";
import PageLayout from "../../layouts/PageLayout";
import shopActive from "../../requests/Shops/ShopActive";
import productActive from "../../requests/Products/ProductActive";
import discountSave from "../../requests/Discounts/DiscountSave";
import discountGet from "../../requests/Discounts/DiscountGet";
import * as moment from "moment";

const {Option} = Select;
const {Content} = Layout;

class DiscountAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            shops: [],
            active: true,
            is_countdown: false,
            start_date: "",
            end_date: "",
            products: [],
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false
        };

        this.getActiveShops = this.getActiveShops.bind(this);
        this.getActiveProducts = this.getActiveProducts.bind(this);
        this.changeStatus = this.changeStatus.bind(this);
        this.onChangeEndDate = this.onChangeEndDate.bind(this);
        this.onChangeStartDate = this.onChangeStartDate.bind(this);
        this.onChangeShop = this.onChangeShop.bind(this);

        this.getActiveShops();
    }

    componentDidMount() {
        if (this.state.edit)
            setTimeout(() => this.getInfoById(this.state.id), 1000);
    }

    getInfoById = async (id) => {
        let data = await discountGet(id);
        if (data.data.success) {
            let discount = data.data.data.discount;
            let discount_products = data.data.data.discount_products;

            this.getActiveProducts(discount.id_shop);

            this.setState({
                active: discount.active == 1 ? true : false,
                is_countdown: discount.is_count_down == 1 ? true : false,
                start_date: discount.start_time,
                end_date: discount.end_time
            });

            var productsArray = [];
            if (discount_products.length > 0) {
                for (var i = 0; i < discount_products.length; i++) {
                    productsArray.push(discount_products[i].id_product.toString());
                }
            }

            this.formRef.current.setFieldsValue({
                shop: discount.id_shop,
                discount_type: discount.discount_type,
                value: discount.discount_amount,
                start_date: moment(discount.start_time, 'YYYY-MM-DD HH:mm:ss'),
                end_date: moment(discount.end_time, 'YYYY-MM-DD HH:mm:ss'),
                products: productsArray,
            });
        }
    }

    getActiveProducts = async (shop_id) => {
        let data = await productActive(shop_id);
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                products: data.data.data,
            });
        }
    }

    getActiveShops = async () => {
        let data = await shopActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                shops: data.data.data,
            });

            this.getActiveProducts(data.data.data[0].id);

            this.formRef.current.setFieldsValue({
                shop: data.data.data[0].id
            });
        }
    }

    onChangeShop = (e) => {
        this.getActiveProducts(e);
    }

    changeStatus = (e) => {
        this.setState({
            active: e.target.checked
        });
    }

    changeCountDown = (e) => {
        this.setState({
            is_countdown: e.target.checked
        });
    }

    onFinish = async (values) => {
        let data = await discountSave(values.shop, values.discount_type, values.value, this.state.is_countdown, this.state.start_date, this.state.end_date, values.products, this.state.active, this.state.id);

        if (data.data.success == 1)
            window.history.back();
    };

    onFinishFailed = (errorInfo) => {
    };

    onChangeStartDate = (value, dateString) => {
        this.setState({
            start_date: dateString
        })
    }

    onChangeEndDate = (value, dateString) => {
        this.setState({
            end_date: dateString
        })
    }

    onOk = (value) => {
        console.log('onOk: ', value);
    }

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/discounts" className="nav-text">Discounts</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => window.history.back()}
                    className="site-page-header"
                    title={this.state.edit ? "Discount Edit" : "Discount Add"}
                >
                    <Content
                        className="site-layout-background padding-20">
                        {
                            (this.state.shops.length > 0) ? (<Form
                                ref={this.formRef}
                                name="basic"
                                initialValues={{
                                    discount_type: 1
                                }}
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
                                        <Form.Item label="Discount type" name="discount_type"
                                                   rules={[{required: true, message: 'Missing discount type'}]}
                                                   tooltip="Select discount type">
                                            <Select placeholder="Select discount type">
                                                <Option value={1} key={1}>Percentage</Option>
                                                <Option value={2} key={2}>Fixed price</Option>
                                            </Select>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Discount value" name="value"
                                                   rules={[{required: true, message: 'Missing discount value'}]}
                                                   tooltip="Enter discount value">
                                            <InputNumber placeholder="Discount value"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Has countdown" name="is_countdown"
                                                   tooltip="Uncheck if discount has not countdown">
                                            <Checkbox checked={this.state.is_countdown}
                                                      onChange={this.changeCountDown}>{this.state.is_countdown ? "Has countdown" : "No countdown"}</Checkbox>
                                        </Form.Item>
                                    </div>
                                    {
                                        this.state.is_countdown && (
                                            <div className="col-md-3 col-sm-6">
                                                <Form.Item name="start_date" label="Start date"
                                                           tooltip="Enter discount start date"
                                                           rules={[{
                                                               required: true,
                                                               message: 'Missing discount start date'
                                                           }]}>
                                                    <DatePicker showTime onChange={this.onChangeStartDate}
                                                                onOk={this.onOk}/>
                                                </Form.Item>
                                            </div>
                                        )
                                    }
                                    {
                                        this.state.is_countdown && (
                                            <div className="col-md-3 col-sm-6">
                                                <Form.Item name="end_date" label="End date"
                                                           tooltip="Enter discount end date"
                                                           rules={[{
                                                               required: true,
                                                               message: 'Missing discount end date'
                                                           }]}>
                                                    <DatePicker showTime onChange={this.onChangeEndDate}
                                                                onOk={this.onOk}/>
                                                </Form.Item>
                                            </div>
                                        )
                                    }
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Products" name="products"
                                                   rules={[{required: true, message: 'Missing products'}]}
                                                   tooltip="Select products">
                                            <Select placeholder="Select products" mode="tags">
                                                {
                                                    this.state.products.map((item) => {
                                                        return (
                                                            <Option value={item.id.toString()}
                                                                    key={item.id}>{item.name}</Option>);
                                                    })
                                                }
                                            </Select>
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

export default DiscountAdd;
